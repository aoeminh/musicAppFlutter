import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_flutter/bloc/bloc_base.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/service/audio/audio_service.dart';
import 'package:rxdart/rxdart.dart';

class AudioBloc extends BlocBase {
  final AudioPlayerService audioPlayerService;

  AudioBloc({this.audioPlayerService}) {
    handlePlayEpisode();
  }

  BehaviorSubject<Episode> _playSubject = BehaviorSubject();

  BehaviorSubject<AppLifecycleState> _appLifeCycleSubject = BehaviorSubject();


  handlePlayEpisode() {
    _playSubject.listen((episode) {
      print('handlePlayEpisode');
      audioPlayerService.playEpisode(episode: episode);
    });
  }

  handleAppLifecycleChange(){
    _appLifeCycleSubject.listen((state){
      if(state == AppLifecycleState.resumed){
        audioPlayerService.resume();
      }else if( state == AppLifecycleState.paused){
        audioPlayerService.suspend();
      }

    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _playSubject.close();
    _appLifeCycleSubject.close();
  }

  Function(Episode) get play => _playSubject.add;

  Function(AppLifecycleState) get changeLifecycle => _appLifeCycleSubject.add;

  Stream<Episode> get playStream => _playSubject.stream;

  Stream<AppLifecycleState> get lifecycleStream => _appLifeCycleSubject.stream;

  Stream<AudioState> get audioStateStream => audioPlayerService.audioStateStream;

}
