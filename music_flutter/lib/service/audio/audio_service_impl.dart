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
      }else{

      }
    }
  }

  @override
  Future<void> play() => AudioService.play();

  @override
  Future<void> stop() async {}

  @override
  Future<void> suspend() async {
     print('suspend');
    await AudioService.disconnect();
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
            ' Received state change from audio service ${ps.toString()} state.currentPosition ${state.currentPosition}');
        switch (ps) {
          case AudioProcessingState.none:
            // TODO: Handle this case.
            break;
          case AudioProcessingState.connecting:
            // TODO: Handle this case.
            break;
          case AudioProcessingState.ready:
            print('state.playing ${state.playing}');
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
  }

  Future<void> _onPause() async {
    _audioStateSubject.add(AudioState.pausing);
  }

  Future<void> _onStop() async {
    _audioStateSubject.add(AudioState.stopped);
  }

  Stream<AudioState> get audioStateStream => _audioStateSubject.stream;
}

void backgroundPlay() {
  AudioServiceBackground.run(() => BackgroundPlayerTask());
}
