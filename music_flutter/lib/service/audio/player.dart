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
  bool _isPlaying = false;
  bool _isLoadTrack = false;
  final Completer _completer = Completer<dynamic>();

  Future<void> play() async {
    if (_isLoadTrack) {
      await _audioPlayer.setUrl(_uri);
      if (_position > 0) {
        await _audioPlayer.seek(Duration(milliseconds: _position));
      }
      _isLoadTrack = false;
    }
    print('moving position to ${_position}');
    if (_audioPlayer.playbackEvent.state != AudioPlaybackState.connecting ||
        _audioPlayer.playbackEvent.state != AudioPlaybackState.none) {
      try {
        print(
            '_audioPlayer.playbackEvent.state ${_audioPlayer.playbackEvent.state}');
        _audioPlayer.play();
      } catch (e) {
        print('State error');
      }
    }

    await setStatePlaying();
  }

  Future<void> pause() async {
    print('player pause');
    await _audioPlayer.pause();
    await setPauseState();
  }

  Future<void> onClick() async {
    if (_uri.isNotEmpty) {
      if (_isPlaying) {
        await pause();
      } else {
        await play();
      }
    }
  }

  Future<void> onRewind() async {
    if (_position > 0) {
      _position -= 30000;

      if (_position < 0) {
        _position = 0;
      }

      await _audioPlayer.seek(Duration(milliseconds: _position));

      if (_isPlaying) {
        await setStatePlaying();
      } else {
        await setStateRewind();
      }
    }
  }

  Future<void> onFastForward() async {
    _position += 30000;
    await _audioPlayer.seek(Duration(milliseconds: _position));
    if (_isPlaying) {
      await setStatePlaying();
    } else {
      await setStateFastForward();
    }
  }

  Future<void> setStatePlaying() async {
    print('setStatePlaying');
    _playbackState = AudioProcessingState.ready;
    controls = [
      MediaControl.rewind,
      MediaControl.pause,
      MediaControl.fastForward
    ];
    _isPlaying = true;
    await _setState();
  }

  Future<void> setStateRewind() async {
    print('setStateRewind');
    _playbackState = AudioProcessingState.rewinding;
    await _setState();
  }

  Future<void> setStateFastForward() async {
    print('setStateFastForward');
    _playbackState = AudioProcessingState.fastForwarding;
    await _setState();
  }

  Future<void> setPauseState() async {
    print('setPauseState');
    _playbackState = AudioProcessingState.ready;
    controls = [
      MediaControl.rewind,
      MediaControl.play,
      MediaControl.fastForward
    ];
    _isPlaying = false;
    await _setState();
  }

  Future<void> _setStoppedState() async {
    log.fine('setStoppedState()');
    print('setStoppedState');
    await _audioPlayer.stop();
    await _audioPlayer.dispose();

    _playbackState = AudioProcessingState.stopped;
    _isPlaying = false;
    await _setState();

    _completer.complete();
  }

  Future<void> _setState() async {
    log.fine('_setState() to ');
    await AudioServiceBackground.setState(
        controls: controls,
        processingState: _playbackState,
        playing: _isPlaying);
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
    _isLoadTrack = true;
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
