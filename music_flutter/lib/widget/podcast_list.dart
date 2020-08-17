import 'package:flutter/material.dart';
import 'package:music_flutter/generated/l10n.dart';
import 'package:music_flutter/model/podcast.dart';
import 'package:music_flutter/widget/podcast_detail/espisode.dart';
import 'package:music_flutter/widget/podcast_detail/podcast_detail.dart';
import 'package:podcast_search/podcast_search.dart' as podapi;

import 'podcast_tile.dart';

class PodcastList extends StatelessWidget {
  final podapi.SearchResult result;

  const PodcastList({Key key, this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (result.items.isNotEmpty) {
      return ListView.builder(
          itemCount: result.items.length,
          itemBuilder: (context, index) {
            final item = result.items[index];
            final podcast = Podcast.fromSearchResultItem(item);
            print(' episode ${podcast.episodes}');
            return Hero(
              tag: 'Hl ${podcast.title}',
              child: Material(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PodcastDetail(
                                podcastMusic: podcast,
                              ))),
                  child: PodcastTile(
                    podcast: podcast,
                  ),
                ),
              ),
            );
          });
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[Text(S.of(context).no_search_results_message)],
      );
    }
  }
}
