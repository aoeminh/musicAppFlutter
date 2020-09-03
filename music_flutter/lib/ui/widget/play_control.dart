import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_flutter/bloc/audio_bloc.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/service/audio/audio_service.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class PlayControl extends StatelessWidget {
  final Episode episode;

  const PlayControl({Key key, this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _audioBloc = Provider.of<AudioBloc>(context);
    return StreamBuilder<PlayControlState>(
      stream: Rx.combineLatest2(
          _audioBloc.audioStateStream,
          _audioBloc.playStream,
          (audioState, nowPlaying) =>
              PlayControlState(episode: nowPlaying, audioState: audioState)),
      builder: (context, snapshot) {
        print('snapshot $snapshot');
        if (snapshot.hasData) {
          final nowPlaying = snapshot.data.episode;
          final audioState = snapshot.data.audioState;
          print('audioState $audioState nowPlaying ${nowPlaying.guid} ');
          if (episode.guid == nowPlaying.guid) {
            if (audioState == AudioState.buffering) {
              return PauseLoadingButton();
            } else if (audioState == AudioState.playing) {
              return PlayPauseButton(
                iconData: Icons.pause,
              );
            } else {
              return PlayPauseButton(
                iconData: Icons.play_arrow,
              );
            }
          }
        }

        return InkWell(
          onTap: () {
            _audioBloc.play(episode);
          },
          child: PlayPauseButton(
            iconData: Icons.play_arrow,
          ),
        );
      },
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  final IconData iconData;

  const PlayPauseButton({Key key, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularPercentIndicator(
        radius: 38,
        lineWidth: 2,
        backgroundColor: Theme.of(context).primaryColor,
        center: Icon(
          iconData,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class PauseLoadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 40,
      width: 38,
      child: Stack(children: <Widget>[
        CircularPercentIndicator(
          radius: 38,
          lineWidth: 2,
          center: Icon(
            Icons.pause,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SpinKitRing(
          size: 38,
          color: theme.primaryColor,
          lineWidth: 2,
        )
      ]),
    );
  }
}

class PlayControlState {
  final Episode episode;
  final AudioState audioState;

  PlayControlState({this.episode, this.audioState});
}
