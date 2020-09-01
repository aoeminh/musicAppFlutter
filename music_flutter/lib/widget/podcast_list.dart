import 'package:flutter/material.dart';
import 'package:music_flutter/generated/l10n.dart';
import 'package:music_flutter/model/podcast.dart';
import 'package:music_flutter/widget/discovery/bloc/discover_block.dart';
import 'package:music_flutter/widget/discovery/bloc/discover_event_state.dart';
import 'package:music_flutter/widget/podcast_detail/bloc/podcast_bloc.dart';
import 'package:music_flutter/widget/podcast_detail/episode_widget.dart';
import 'package:music_flutter/widget/podcast_detail/podcast_detail.dart';
import 'package:podcast_search/podcast_search.dart' as podapi;
import 'package:provider/provider.dart';

import 'podcast_tile.dart';

class PodcastList extends StatelessWidget {
  final podapi.SearchResult result;
  final DiscoverBloc bloc;
  const PodcastList({Key key, this.result, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final podcastBloc = Provider.of<PodcastBloc>(context);
      return ListView.builder(
          itemCount: result.items.length,
          itemBuilder: (context, index) {
            final item = result.items[index];
            final podcast = Podcast.fromSearchResultItem(item);
            return Hero(
              tag: 'Hl ${podcast.title}',
              child: Material(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PodcastDetail(
                                podcastMusic: podcast,bloc: podcastBloc,
                              ))),
                  child: PodcastTile(
                    podcast: podcast,
                  ),
                ),
              ),
            );


    });
  }
}
