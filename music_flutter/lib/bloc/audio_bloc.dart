import 'dart:math';

import 'package:music_flutter/bloc/bloc_base.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/service/audio/audio_service.dart';
import 'package:rxdart/rxdart.dart';

class AudioBloc extends BlocBase {
  final AudioPlayerService audioPlayerService;

  AudioBloc({this.audioPlayerService}){
    handlePlayEpisode();
  }

  BehaviorSubject<Episode> _playSubject = BehaviorSubject();

 handlePlayEpisode(){
   _playSubject.listen((episode) {
     print('handlePlayEpisode');
     audioPlayerService.play(episode: episode);
   });

 }
  @override
  void dispose() {
    // TODO: implement dispose
    _playSubject.close();
  }

  Function(Episode) get play => _playSubject.add;

  Stream<Episode> get playStream => _playSubject.stream;
}
