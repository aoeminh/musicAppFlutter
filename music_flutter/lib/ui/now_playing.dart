import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_flutter/bloc/audio_bloc.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/service/audio/audio_service.dart';
import 'package:provider/provider.dart';

const double _horizontalPadding = 20;
const double _verticalMargin = 50;

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios),
        ),
        title: Center(
          child: Text('Now playing'),
        ),
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context);
    return StreamBuilder<Episode>(
      stream: audioBloc.playStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final episode = snapshot.data;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: _verticalMargin,
              ),
              CachedNetworkImage(
                imageUrl: episode.imageUrl ?? '',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: _verticalMargin,
              ),
              Text(
                episode.title ?? 'Unknow',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                episode.author ?? 'Unknow',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: _verticalMargin,
              ),
              _buildSeekbar(audioBloc, episode),
              SizedBox(
                height: _verticalMargin,
              ),
              _buildPlayback(audioBloc)
            ],
          ),
        );
      },
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inMinutes < 60) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  _buildSeekbar(AudioBloc audiobloc, Episode episode) {
    return Container(
      color: Colors.black12,
      child: StreamBuilder<PositionState>(
        stream: audiobloc.postionStateStream,
        builder: (context, snapshot) {
          var value = snapshot.hasData
              ? snapshot.data.position.inSeconds.toDouble()
              : 0.0;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                  '${_printDuration(snapshot.hasData ? snapshot.data.position : Duration(seconds: 0))}'),
              Expanded(
                  child: SliderTheme(
                data: SliderThemeData(
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6)),
                child: Slider(
                  onChanged: (value) {
                    audiobloc.changePosition(value.toInt());
                  },
                  value: value,
                  min: 0,
                  max: episode.duration.toDouble(),
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor:
                      Theme.of(context).primaryColor.withOpacity(0.3),
                ),
              )),
              Text('${_printDuration(Duration(seconds: episode.duration))}')
            ],
          );
        },
      ),
    );
  }

  _buildPlayback(AudioBloc audioBloc) {
    return StreamBuilder<AudioState>(
      stream: audioBloc.audioStateStream,
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
              onTap: () => audioBloc.transitionState(TransitionState.rewind),
              child: Icon(
                Icons.fast_rewind,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
            snapshot.hasData
                ? snapshot.data == AudioState.playing
                    ? InkWell(
                        onTap: () => audioBloc.transitionState(
                          TransitionState.pause,
                        ),
                        child: _buildPlayPauseButton(Icons.pause, context),
                      )
                    : InkWell(
                        onTap: () => audioBloc.transitionState(
                          TransitionState.play,
                        ),
                        child: _buildPlayPauseButton(Icons.play_arrow, context),
                      )
                : Icon(Icons.play_arrow),
            InkWell(
              onTap: () =>
                  audioBloc.transitionState(TransitionState.fastForward),
              child: Icon(
                Icons.fast_forward,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }

  _buildPlayPauseButton(IconData iconData, BuildContext context) => Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor, shape: BoxShape.circle),
      child: Icon(
        iconData,
        color: Colors.white,
      ));
}
