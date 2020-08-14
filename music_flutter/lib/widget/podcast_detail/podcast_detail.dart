import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_flutter/generated/l10n.dart';
import 'package:music_flutter/model/podcast.dart';
import 'package:music_flutter/widget/podcast_detail/espisode.dart';

class PodcastDetail extends StatefulWidget {
  final PodcastMusic podcastMusic;

  const PodcastDetail({Key key, this.podcastMusic}) : super(key: key);

  @override
  _PodcastDetailState createState() => _PodcastDetailState();
}

class _PodcastDetailState extends State<PodcastDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: Icon(Icons.close),
            title: Text(widget.podcastMusic.title),
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'Hl ${widget.podcastMusic.title}',
                child: ExcludeSemantics(
                  child: CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    imageUrl: widget.podcastMusic.imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                ),
              ),
            ),
          ),
          widget.podcastMusic.episodes != null
              ? SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return EpisodeWidget(
                      espisode: widget.podcastMusic.episodes[index],
                    );
                  }),
                )
              : SliverToBoxAdapter(
//            hasScrollBody: false,
                  child: Container(
                  child: Text('Empty'),
                ))
        ],
      ),
    );
  }
}
