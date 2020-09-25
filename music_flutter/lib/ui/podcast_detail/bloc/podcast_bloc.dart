import 'package:music_flutter/bloc/bloc_base.dart';
import 'package:music_flutter/model/downloadable.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/model/podcast.dart';
import 'package:music_flutter/service/download/donwload_service.dart';
import 'package:music_flutter/service/download/download_service_impl.dart';
import 'package:music_flutter/state/bloc_state.dart';
import 'package:music_flutter/model/feed.dart';
import 'package:music_flutter/service/audio/podcast_service.dart';
import 'package:podcast_search/podcast_search.dart' as pcapi;
import 'package:rxdart/rxdart.dart';

class PodcastBloc extends BlocBase {
  final PodcastService podcastService;
  final DownloadService downloadService;

//  final AudioPlayerService audioPlayerService;
//  final DownloadService downloadService;

  PodcastBloc(this.podcastService, this.downloadService) {
    init();
  }

  BehaviorSubject<Feed> _podcastFeed = BehaviorSubject();
  BehaviorSubject<BlocState<Podcast>> _podcastLoad = BehaviorSubject();
  BehaviorSubject<List<Episode>> _podcastEpisode = BehaviorSubject();
  BehaviorSubject<Episode> _downloadSubject = BehaviorSubject();

  Function(Feed) get load => _podcastFeed.add;
  Function(Episode) get download => _downloadSubject.add;

  Stream<BlocState<Podcast>> get podcastStream => _podcastLoad.stream;
  Stream<List<Episode>> get listEpisode => _podcastEpisode.stream;
  Stream<DownloadProgress> get downloadProgressStream =>
      downloadService.downloadProgress;

  List<Episode> _episodes;
  Podcast _podcast;

  init() {
    _listenPodcastLoad();
    _listenDownloadRequest();
    _listenDownloadProgress();
    _listenEpisodeChange();
  }

  _listenPodcastLoad() async {
    _podcastFeed.listen((feed) async {
      _podcastLoad.sink.add(BlocLoadingState());
      _episodes = [];
      _podcastEpisode.sink.add(_episodes);
      _podcast = await podcastService.loadPodcast(podcast: feed.podcast);

      _episodes = _podcast.episodes;

      _podcastLoad.sink.add(BlocResultState(_podcast));
      _podcastEpisode.sink.add(_episodes);
      print(
          'Pushed podcast with ID ${_podcast.id} to the podcast stream with ${_episodes.length} episodes');
    });
  }

  _listenDownloadRequest() {
    _downloadSubject.listen((ep) async {
      print('_listenDownloadRequest');
      var episode =
          _episodes.firstWhere((e) => e.guid == ep.guid, orElse: () => null);
      episode.downloadState = DownloadState.queued;
      if (episode != null) {
        var result = await downloadService.downloadEpisode(ep);
        if (!result) {
          episode.downloadState = DownloadState.failed;
          _podcastEpisode.add(_episodes);
        }
      }
    });
  }

  _listenDownloadProgress() {
    downloadService.downloadProgress.listen((progress) {
      var episode =
          _episodes.firstWhere((e) => e.downloadTaskId == progress.id);
      print(
          '_listenDownloadProgress percent  ${progress.percent} state ${progress.state}');

      if (episode != null) {
        episode.downloadPercentage = progress.percent;
        episode.downloadState = progress.state;
        _podcastEpisode.add(_episodes);
      }
    });
  }

  _listenEpisodeChange() {
    downloadService.episodeListener.listen((ep) {
      var index = _episodes.indexOf(ep);
      if (index != -1) {
        _episodes[index] = ep;
        _podcastEpisode.add(_episodes);
      }
    });
  }

  @override
  void dispose() {
    print('PodcastBloc dispose');
    _podcastFeed.close();
    _podcastLoad.close();
    _podcastEpisode.close();
    _downloadSubject.close();
  }
}
