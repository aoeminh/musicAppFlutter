import 'package:flutter/material.dart';
import 'package:music_flutter/generated/l10n.dart';
import 'package:music_flutter/model/podcast.dart';
import 'package:podcast_search/podcast_search.dart';

import 'podcast_tile.dart';

class PodcastList extends StatelessWidget {

  final SearchResult result;

  const PodcastList({Key key, this.result}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if(result.items.isNotEmpty){
      return ListView.builder(
          itemCount: result.items.length,
          itemBuilder: (context, index){
        final item = result.items[index];
        final podcast = PodcastMusic.fromSearchResultItem(item);
        return PodcastTile(podcast: podcast,
        );
      });
    } else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(S.of(context).no_search_results_message)
        ],
      );
    }

  }
}
