import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_flutter/bloc/audio_bloc.dart';
import 'package:music_flutter/model/downloadable.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/service/audio/audio_service.dart';
import 'package:music_flutter/service/download/download_service_impl.dart';
import 'package:music_flutter/ui/podcast_detail/bloc/podcast_bloc.dart';
import 'package:music_flutter/ui/widget/play_control.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class DownloadControl extends StatelessWidget {
  final Episode episode;

  const DownloadControl({Key key, this.episode}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final audiobloc = Provider.of<AudioBloc>(context);
    final podcastBloc = Provider.of<PodcastBloc>(context);

    return StreamBuilder<PlayControlState>(
      stream: Rx.combineLatest2(
          audiobloc.audioStateStream,
          audiobloc.playStream,
          (audioState, episode) =>
              PlayControlState(episode: episode, audioState: audioState)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var ep = snapshot.data.episode;
          var audioState = snapshot.data.audioState;
          if (episode.guid == ep.guid &&
              (audioState == AudioState.buffering ||
                  audioState == AudioState.playing)) {
            return Opacity(
              opacity: 0.2,
              child: DownloadButton(
                iconData: Icons.file_download,
              ),
            );
          }
        }

        if (episode.downloadState == DownloadState.downloading) {
          return ProgressDownloadButton(
            iconData: Icons.timer,
            percent: episode.downloadPercentage,
          );
        }

        return InkWell(
          onTap: () => podcastBloc.download(episode),
          child: DownloadButton(
            iconData: Icons.file_download,
          ),
        );
      },
    );
  }
}

class DownloadButton extends StatelessWidget {
  final IconData iconData;

  const DownloadButton({Key key, this.iconData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      child: CircularPercentIndicator(
        backgroundColor: themeData.primaryColor,
        lineWidth: 2,
        radius: 38,
        center: Icon(
          iconData,
          color: themeData.primaryColor,
        ),
      ),
    );
  }
}

class ProgressDownloadButton extends StatelessWidget {
  final IconData iconData;
  final int percent;

  const ProgressDownloadButton({Key key, this.iconData, this.percent})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('ProgressDownloadButton $percent');
    return Container(
      child: CircularPercentIndicator(
        backgroundColor: Colors.green,
        radius: 38,
        lineWidth: 2,
        percent: percent.toDouble() / 100,
        center: Text(
          '$percent%',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
