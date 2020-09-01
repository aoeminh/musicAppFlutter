import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';

class Player {
  AudioPlayer _audioPlayer = AudioPlayer();
  final log = Logger('Player');
  String _uri;
  int _position;
  List<MediaControl> controls = [];
  AudioProcessingState _playbackState;
  bool _playing = false;
  final Completer _completer = Completer<dynamic>();

  Future<void> play() async {
    print('player $_uri');
    await _audioPlayer.setUrl(_uri);
    _audioPlayer.play();
    if (_audioPlayer.playbackEvent.state != AudioPlaybackState.connecting ||
        _audioPlayer.playbackEvent.state != AudioPlaybackState.none) {
      try {

      } catch (e) {
        print('State error');
      }
    }

    if (_position > 0) {
      log.fine('moving position to ${_position}');
      await _audioPlayer.seek(Duration(milliseconds: _position));
    }
    setStatePlaying();
  }

  Future<void> pause()async{
    print('onPause1');
    log.fine("pause");
    await _audioPlayer.pause();
    await setPauseState();
  }

  Future<void> setStatePlaying() async {
    print('setStatePlaying');
    _playbackState = AudioProcessingState.ready;
    controls = [
      MediaControl.skipToPrevious,
      MediaControl.pause,
      MediaControl.skipToNext
    ];
    _playing = true;
    await _setState();
  }

  Future<void> setPauseState()async{
    print('setPauseState');
    _playbackState = AudioProcessingState.ready;
    controls= [  MediaControl.skipToPrevious,
      MediaControl.play,
      MediaControl.skipToNext];
    await _setState();
  }

  Future<void> _setStoppedState() async {
    log.fine('setStoppedState()');
    print('setStoppedState');
    await _audioPlayer.stop();
    await _audioPlayer.dispose();

    _playbackState = AudioProcessingState.stopped;

    await _setState();

    _completer.complete();
  }
  Future<void> _setState() async {
    log.fine('_setState() to ');
    await AudioServiceBackground.setState(
        controls: controls, processingState: _playbackState, playing: true);
  }

  Future<void> start() async {
    log.fine('start()');

    var playerStateSubscription = _audioPlayer.playbackStateStream
        .where((state) => state == AudioPlaybackState.completed)
        .listen((state) async {
      await complete();
    });

    var eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      if (event.state == AudioPlaybackState.playing) {
        _position = event.position.inMilliseconds;
      }
    });

    await _completer.future;

    await playerStateSubscription.cancel();
    await eventSubscription.cancel();

    await _audioPlayer.dispose();
  }

  Future<void> complete() async {
    log.fine('complete()');

    await _audioPlayer.stop();

    _position = -1;

    await _setStoppedState();
  }

  Future<void> setMediaItem(dynamic args) async {
    _uri = args[3];
    _position = int.parse(args[5]);
    print('setMediaItem $_position');
    await AudioServiceBackground.setMediaItem(
      MediaItem(
        id: '1000',
        title: args[1],
        artUri: args[2],
        album: args[0],
      ),
    );
  }
}
