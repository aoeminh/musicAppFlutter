import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/service/audio/audio_service.dart';
import 'package:rxdart/rxdart.dart';

import 'background_audio_player.dart';

class AudioPlayerServiceImpl extends AudioPlayerService {
  final log = Logger('MobileAudioPlayerService');
  Episode _episode;
  final BehaviorSubject<AudioState> _audioStateSubject =
      BehaviorSubject.seeded(AudioState.none);

  StreamSubscription _positionSubcription;
  final _durationTicker =
      Stream<int>.periodic(Duration(milliseconds: 500)).asBroadcastStream();

  final PublishSubject<PositionState> _positionSubject = PublishSubject();

  AudioPlayerServiceImpl() {
    handleAudioServiceTransitions();
  }

  @override
  Future<void> fastForward() => AudioService.fastForward();

  @override
  Future<void> pause() => AudioService.pause();

  @override
  Future<void> playEpisode({Episode episode}) async {
    if (episode.guid != '') {
      var trackDetail = <String>[];
      var startPosition = 0;
      var uri = episode.contentUrl;

      log.info('play Episode ${episode.title} - ${episode.contentUrl}');

      trackDetail = [
        episode.author ?? 'Unknow',
        episode.title ?? 'Unknow',
        episode.imageUrl,
        uri,
        episode.downloaded ? '1' : '0',
        startPosition.toString()
      ];
      print('playEpisode ${AudioService.running} ');
      _audioStateSubject.add(AudioState.buffering);

      if (!AudioService.running) {
        await _start();
      }
      _episode = episode;
      await AudioService.customAction('play', trackDetail);

      await AudioService.play();
    }
  }

  @override
  Future<void> rewind() => AudioService.rewind();

  @override
  Future<void> resume() async {
    print('resume');
    await AudioService.connect();

    if (_episode != null) {
      var playbackState = AudioService.playbackState;
      var audioProgressState =
          playbackState.processingState ?? AudioProcessingState.none;
      if (audioProgressState == AudioProcessingState.none) {
        _audioStateSubject.add(AudioState.stopped);
      } else {
        _startDurationTicker();
      }
    }
  }

  @override
  Future<void> play() => AudioService.play();

  @override
  Future<void> stop() async {
    AudioService.stop();
  }

  @override
  Future<void> suspend() async {
    print('suspend');
    await AudioService.disconnect();
    _stopDurationTicker();
  }

  @override
  Future<void> seek({@required int position}) async {
    var duration = _episode == null ? 0 : _episode.duration;
    if (duration > 0) {
      var percent = position > 0 ? (position / duration * 100) : 0;
      _positionSubject.add(PositionState(
          position: Duration(seconds: position), percent: percent.toDouble()));
    }
    await AudioService.seekTo(Duration(seconds: position));
  }

  Future<void> _start() async {
    await AudioService.start(
      backgroundTaskEntrypoint: backgroundPlay,
      androidResumeOnClick: true,
      androidNotificationChannelName: 'Anytime Podcast Player',
      androidNotificationColor: Colors.orange.value,
      androidStopForegroundOnPause: true,
      fastForwardInterval: Duration(seconds: 30),
    );
  }

  handleAudioServiceTransitions() async {
    AudioService.playbackStateStream.listen((state) async {
      if (state != null && state is PlaybackState) {
        final ps = state.processingState;
        print(
            ' Received state change from audio service ${ps.toString()} state.playing ${state.playing}');
        switch (ps) {
          case AudioProcessingState.none:
            // TODO: Handle this case.
            break;
          case AudioProcessingState.connecting:
            // TODO: Handle this case.
            break;
          case AudioProcessingState.ready:
            if (state.playing) {
              await _onPlay();
            } else {
              await _onPause();
            }
            break;
          case AudioProcessingState.buffering:
//            await _onBuffering();
            break;
          case AudioProcessingState.fastForwarding:
            // TODO: Handle this case.
            break;
          case AudioProcessingState.rewinding:
            // TODO: Handle this case.
            break;
          case AudioProcessingState.skippingToPrevious:
            // TODO: Handle this case.
            break;
          case AudioProcessingState.skippingToNext:
            // TODO: Handle this case.
            break;
          case AudioProcessingState.skippingToQueueItem:
            // TODO: Handle this case.
            break;
          case AudioProcessingState.completed:
            // TODO: Handle this case.
            break;
          case AudioProcessingState.stopped:
            _onStop();
            break;
          case AudioProcessingState.error:
            // TODO: Handle this case.
            break;
        }
      }
    });
  }

  Future<void> _onBuffering() async {
    _audioStateSubject.add(AudioState.buffering);
  }

  Future<void> _onPlay() async {
    _audioStateSubject.add(AudioState.playing);
    _startDurationTicker();
  }

  Future<void> _onPause() async {
    _audioStateSubject.add(AudioState.pausing);
    _stopDurationTicker();
  }

  Future<void> _onStop() async {
    var playbackState = await AudioService.playbackState;
    _episode = null;
    print('_onStop() ${playbackState.position}');
    await _stopDurationTicker();

    await Future<int>.delayed(Duration(seconds: 1));
    print('SAAadsfadsfAA ${AudioService.running}');
    _audioStateSubject.add(AudioState.stopped);
  }

  _startDurationTicker() {
    print('_startDurationTicker');
    if (_positionSubcription == null) {
      _positionSubcription = _durationTicker.listen((onData) {
        _updatePosition();
      });
    } else {
      _positionSubcription.resume();
    }
  }

  Future<void> _stopDurationTicker() async {
    if (_positionSubcription != null) {
      await _positionSubcription.cancel();
      _positionSubcription = null;
    }
  }

  _updatePosition() {
    var playbackState = AudioService.playbackState;
    if (playbackState != null) {
      var position = playbackState.currentPosition;
      var duration = _episode == null ? 0 : _episode.duration;
      if (duration > 0) {
        print('position $position ${Duration(seconds: _episode.duration)}');
        var percent =
            position.inSeconds > 0 ? (position.inSeconds / duration * 100) : 0;
        _positionSubject.add(
            PositionState(position: position, percent: percent.toDouble()));
      }
    }
  }

  Stream<AudioState> get audioStateStream => _audioStateSubject.stream;
  Stream<PositionState> get positionStateStream => _positionSubject.stream;
}

void backgroundPlay() {
  AudioServiceBackground.run(() => BackgroundPlayerTask());
}
