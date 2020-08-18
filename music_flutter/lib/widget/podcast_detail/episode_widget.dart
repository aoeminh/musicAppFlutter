import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_flutter/generated/l10n.dart';
import 'package:music_flutter/model/episode.dart';

class EpisodeWidget extends StatefulWidget {
  final Episode espisode;

  const EpisodeWidget({Key key, this.espisode}) : super(key: key);

  @override
  _EpisodeWidgetState createState() => _EpisodeWidgetState();
}

class _EpisodeWidgetState extends State<EpisodeWidget> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: Key('${widget.espisode.guid}'),
      leading: CachedNetworkImage(
        imageUrl: widget.espisode.thumbImageUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
      ),
      title: Text(widget.espisode.title),
      subtitle: Text(widget.espisode.author),
      trailing: SizedBox(
        width: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(Icons.file_download),
            Icon(Icons.play_circle_outline)
          ],
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 4.0,
          ),
          child: Text(widget.espisode.description,overflow: TextOverflow.ellipsis,
          maxLines: 10,),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Icon(Icons.delete),
                Text(S.of(context).delete_label)
              ],
            ),
            Column(
              children: <Widget>[
                Icon(Icons.bookmark_border),
                Text(S.of(context).mark_unplayed_label)
              ],
            )
          ],
        )
      ],
    );
  }
}
