import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_flutter/bloc/audio_bloc.dart';
import 'package:music_flutter/generated/l10n.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/ui/widget/play_control.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class EpisodeWidget extends StatefulWidget {
  final Episode espisode;

  const EpisodeWidget({Key key, this.espisode}) : super(key: key);

  @override
  _EpisodeWidgetState createState() => _EpisodeWidgetState();
}

class _EpisodeWidgetState extends State<EpisodeWidget> {
  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context);
    final textTheme = Theme.of(context).textTheme;
    return ExpansionTile(
      leading: CachedNetworkImage(
        imageUrl: widget.espisode.thumbImageUrl,
        placeholder: (context, url) => Center(child: Container()),
      ),
      title: Text(
        widget.espisode.title ?? '',
        style: textTheme.body2.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(widget.espisode.author ?? '', style: textTheme.caption),
      trailing: SizedBox(
        width: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(0.0),
              height: 40.0,
              width: 38.0,
              child: Stack(
                children: <Widget>[
                  CircularPercentIndicator(
                      radius: 38.0,
                      lineWidth: 2.0,
                      percent: 0.8,
                      center: Icon(
                        Icons.file_download,
                        size: 28,
                        color: Theme.of(context).primaryColor,
                      )),
//                 const SpinKitRing(
//                   lineWidth: 2.0,
//                   color: Colors.blue,
//                   size: 38.0,
//                 ),
                ],
              ),
            ),
            PlayControl(
              episode: widget.espisode,
            )
          ],
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 4.0,
          ),
          child: Text(
            widget.espisode.description,
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
          ),
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
