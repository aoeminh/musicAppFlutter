import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_flutter/model/podcast.dart';

class PodcastTile extends StatelessWidget {
  final PodcastMusic podcast;

  const PodcastTile({Key key, this.podcast}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: podcast.thumbImageUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
      ),
      title: Text(podcast.title),
      subtitle: Text(podcast.copyright),
    );
  }
}
