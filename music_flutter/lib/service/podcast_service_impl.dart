import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:music_flutter/api/podcast_api.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/model/podcast.dart';
import 'package:music_flutter/repository/repository.dart';
import 'package:music_flutter/service/podcast_service.dart';
import 'package:podcast_search/podcast_search.dart'  as psapi;

class PodcastServiceImpl extends PodcastService{
  PodcastServiceImpl(PodCastApi api, Repository repository) : super(api, repository);
  final _cache = _PodcastCache(maxItems: 10, expiration: Duration(minutes: 30));
  @override
  Future<psapi.SearchResult> charts(int size) {
    return api.charts(size);
  }

  /// Loads the specified [Podcast]. If the Podcast instance has an ID we'll fetch
  /// it from storage. If not, we'll check the cache to see if we have seen it
  /// recently and return that if available. If not, we'll make a call to load
  /// it from the network.
  @override
  Future<Podcast> loadPodcast({@required Podcast podcast, bool refresh= false}) async {
    if (podcast.id == null || refresh) {
      psapi.Podcast loadedPodcast;
      var title = '';
      var description = '';
      var copyright = '';

      if (!refresh) {
        loadedPodcast = _cache.item(podcast.url);
      }

      // If we didn't get a cache hit load the podcast feed.
      if (loadedPodcast == null) {
        try {
          loadedPodcast = await _loadPodcastFeed(url: podcast.url);
        } on Exception {
          rethrow;
        }

        _cache.store(loadedPodcast);
      }

      // Sometimes, key values such as title, description etc contain new lines and empty
      // spaces. We need to ensure these are all trimmed before we make the data available
      // to the user.
      if (loadedPodcast.title != null) {
        title = loadedPodcast.title.replaceAll('\n', '').trim();
      }
      if (loadedPodcast.description != null) {
        description = loadedPodcast.description.replaceAll('\n', '').trim();
      }
      if (loadedPodcast.copyright != null) {
        copyright = loadedPodcast.copyright.replaceAll('\n', '').trim();
      }

      final existingEpisodes = await repository.findEpisodesByPodcastGuid(loadedPodcast.url);

      final pc = Podcast(
        guid: loadedPodcast.url,
        url: loadedPodcast.url,
        link: loadedPodcast.link,
        title: title,
        description: description,
        imageUrl: podcast.imageUrl ?? loadedPodcast.image,
        thumbImageUrl: podcast.thumbImageUrl ?? loadedPodcast.image,
        copyright: copyright,
        episodes: <Episode>[],
      );

      /// We could be subscribed to this podcast already. Let's check.
      var r = await repository.findPodcastByGuid(loadedPodcast.url);

      if (r != null) {
        // We are, so swap in the stored ID so we update the saved version later.
        pc.id = r.id;
      }

      // Find all episodes from the feed.
      if (loadedPodcast.episodes != null) {
        // Usually, episodes are order by reverse publication date - but not always.
        // Enforce that ordering. To prevent unnecessary sorting, we'll sample the
        // first two episodes to see what order they are in.
        if (loadedPodcast.episodes.length > 1) {
          if (loadedPodcast.episodes[0].publicationDate.millisecondsSinceEpoch <
              loadedPodcast.episodes[1].publicationDate.millisecondsSinceEpoch) {
            loadedPodcast.episodes.sort((e1, e2) => e2.publicationDate.compareTo(e1.publicationDate));
          }
        }

        for (final episode in loadedPodcast.episodes) {
          var existingEpisode = existingEpisodes.firstWhere((ep) => ep.guid == episode.guid, orElse: () => null);

          if (existingEpisode == null) {
            var author = episode.author;
            var title = episode.title;
            var description = episode.description;

            if (author != null) {
              author = author.replaceAll('\n', '').trim();
            }

            if (title != null) {
              title = title.replaceAll('\n', '').trim();
            }

            if (description != null) {
              description = description.replaceAll('\n', '').trim();
            }

            pc.episodes.add(Episode(
              pguid: pc.guid,
              guid: episode.guid,
              podcast: pc.title,
              title: title,
              description: description,
              author: author,
              season: episode.season ?? 0,
              episode: episode.episode ?? 0,
              contentUrl: episode.contentUrl,
              link: episode.link,
              imageUrl: pc.imageUrl,
              thumbImageUrl: pc.thumbImageUrl,
              duration: episode.duration?.inSeconds ?? 0,
              publicationDate: episode.publicationDate,
            ));
          } else {
            pc.episodes.add(existingEpisode);
          }
        }
      }

      // Add any downloaded episodes that are no longer in the feed - they
      // may have expired but we still want them.
      for (final episode in existingEpisodes) {
        var feedEpisode = loadedPodcast.episodes.firstWhere((ep) => ep.guid == episode.guid, orElse: () => null);

        if (feedEpisode == null) {
          pc.episodes.add(episode);
        }
      }

      // If we are subscribed to this podcast and are simply refreshing we
      // need to save the updated subscription. A non-null ID indicates this
      // podcast is subscribed too.
      if (podcast.id != null && refresh) {
        await repository.savePodcast(pc);
      }

      return pc;
    } else {
      return await loadPodcastById(id: podcast.id);
    }
  }
  /// Loading and parsing a podcast feed can take several seconds. Larger feeds
  /// can end up blocking the UI thread. We perform our feed load in a
  /// separate isolate so that the UI can continue to present a loading
  /// indicator whilst the data is fetched without locking the UI.
  Future<psapi.Podcast> _loadPodcastFeed({@required String url}) {
    return psapi.Podcast.loadFeed(url: url);
  }

  @override
  Future<Podcast> loadPodcastById({@required int id}) {
    return repository.findPodcastById(id);
  }

}
/// A simple cache to reduce the number of network calls when loading podcast
/// feeds. We can cache up to [maxItems] items with each item having an
/// expiration time of [expiration]. The cache works as a FIFO queue, so if we
/// attempt to store a new item in the cache and it is full we remove the
/// first (and therefore oldest) item from the cache. Cache misses are returned
/// as null.
class _PodcastCache {
  final int maxItems;
  final Duration expiration;
  final Queue<_CacheItem> _queue;

  _PodcastCache({@required this.maxItems, @required this.expiration}) : _queue = Queue<_CacheItem>();

  psapi.Podcast item(String key) {
    var hit = _queue.firstWhere((_CacheItem i) => i.podcast.url == key, orElse: () => null);
    psapi.Podcast p;

    if (hit != null) {
      var now = DateTime.now();

      if (now.difference(hit.dateAdded) <= expiration) {
        p = hit.podcast;
      } else {
        _queue.remove(hit);
      }
    }

    return p;
  }

  void store(psapi.Podcast podcast) {
    if (_queue.length == maxItems) {
      _queue.removeFirst();
    }

    _queue.addLast(_CacheItem(podcast));
  }
}

/// A simple class that stores an instance of a Postcast and the
/// date and time it was added. This can be used by the cache to
/// keep a small and up-to-date list of searched for Podcasts.
class _CacheItem {
  final psapi.Podcast podcast;
  final DateTime dateAdded;

  _CacheItem(this.podcast) : dateAdded = DateTime.now();
}
