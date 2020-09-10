import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_flutter/bloc/bloc_base.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/service/audio/audio_service.dart';
import 'package:rxdart/rxdart.dart';

enum TransitionState {
  play,
  pause,
  stop,
  fastForward,
  rewind,
}

class AudioBloc extends BlocBase {
  final AudioPlayerService audioPlayerService;

  AudioBloc({this.audioPlayerService}) {
    handlePlayEpisode();
    handleTransitionPlayingState();
    handleAppLifecycleChange();
  }

  BehaviorSubject<Episode> _playSubject = BehaviorSubject();

  BehaviorSubject<AppLifecycleState> _appLifeCycleSubject = BehaviorSubject();
  BehaviorSubject<TransitionState> _transitionState = BehaviorSubject();

  handlePlayEpisode() {
    _playSubject.listen((episode) {
      print('handlePlayEpisode');
      audioPlayerService.playEpisode(episode: episode);
    });
  }

  handleAppLifecycleChange() {
    _appLifeCycleSubject.listen((state) {
      if (state == AppLifecycleState.resumed) {
        audioPlayerService.resume();
      } else if (state == AppLifecycleState.paused) {
        audioPlayerService.suspend();
      }
    });
  }

  handleTransitionPlayingState() {
    _transitionState.listen((state) async {
      print('handleTransitionPlayingState $state');
      switch (state) {
        case TransitionState.play:
          await audioPlayerService.play();
          break;
        case TransitionState.pause:
          await audioPlayerService.pause();
          break;
        case TransitionState.stop:
          await audioPlayerService.stop();
          break;
        case TransitionState.fastForward:
          await audioPlayerService.fastForward();
          break;
        case TransitionState.rewind:
          await audioPlayerService.rewind();
          break;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _playSubject.close();
    _appLifeCycleSubject.close();
    _transitionState.close();
  }

  Function(Episode) get play => _playSubject.add;

  Function(AppLifecycleState) get changeLifecycle => _appLifeCycleSubject.add;

  Function(TransitionState) get transitionState => _transitionState.add;

  Stream<Episode> get playStream => _playSubject.stream;

  Stream<AppLifecycleState> get lifecycleStream => _appLifeCycleSubject.stream;

  Stream<AudioState> get audioStateStream =>
      audioPlayerService.audioStateStream;
  Stream<PositionState> get postionStateStream => audioPlayerService.positionStateStream;
}
