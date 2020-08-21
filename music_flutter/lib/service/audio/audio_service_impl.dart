import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:logging/logging.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/service/audio/audio_service.dart';
import 'package:rxdart/rxdart.dart';

import 'background_audio_player.dart';

class AudioPlayerServiceImpl extends AudioPlayerService {
  final log = Logger('MobileAudioPlayerService');

  final BehaviorSubject<AudioState> _audioStateSubject =
      BehaviorSubject.seeded(AudioState.none);

  @override
  Future<void> fastForward() {
    return null;
  }

  @override
  Future<void> pause() {
    // TODO: implement pause
    return null;
  }

  @override
  Future<void> play({Episode episode}) async {
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

      if (!AudioService.running) {
        await startAudioService();
      }

      await AudioService.customAction('play', trackDetail);
      await AudioService.play();
    }
  }

  @override
  Future<void> rewind() {
    // TODO: implement rewind
    return null;
  }

  @override
  Future<void> stop() async {}



  void initBackgroundTask() {
    AudioServiceBackground.run(() => BackgroundPlayerTask());
  }

  Future<bool> startAudioService() async {
    return AudioService.start(
      backgroundTaskEntrypoint: initBackgroundTask,
      androidNotificationIcon: 'mipmap/ic_launcher',
    );
  }

  Stream<AudioState> get audioStateStream => _audioStateSubject.stream;
}
