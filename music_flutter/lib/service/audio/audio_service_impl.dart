import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
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

//      if (!AudioService.running) {
       await  _start();

//      }
//      print(trackDetail);
//      print('customAction');

//      await AudioService.customAction('track', trackDetail);
//      await AudioService.play();
    }
  }

  @override
  Future<void> rewind() {
    // TODO: implement rewind
    return null;
  }

  @override
  Future<void> stop() async {}

  Future<void> _start() async {
    var fs =await AudioService.start(
      backgroundTaskEntrypoint: backgroundPlay,
      androidResumeOnClick: true,
      androidNotificationChannelName: 'Anytime Podcast Player',
      androidNotificationColor: Colors.orange.value,
      androidStopForegroundOnPause: true,
      fastForwardInterval: Duration(seconds: 30),
    );
    print('dddd $fs');
  }
  Future<bool> startAudioService() async {

    AudioService.start(
      backgroundTaskEntrypoint: backgroundPlay,
      androidResumeOnClick: true,
      androidNotificationChannelName: 'Anytime Podcast Player',
      androidNotificationColor: Colors.orange.value,
      androidNotificationIcon: 'drawable/ic_stat_name',
      androidStopForegroundOnPause: true,
      fastForwardInterval: Duration(seconds: 30),
    ).then((value){
      print('dddd $value');
    }).catchError((){
      print('error');
    });

  }

  Stream<AudioState> get audioStateStream => _audioStateSubject.stream;
}

void backgroundPlay() {
  AudioServiceBackground.run(() => BackgroundPlayerTask());
}