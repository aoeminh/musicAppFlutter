import 'package:audio_service/audio_service.dart';
import 'package:logging/logging.dart';
import 'package:music_flutter/service/audio/player.dart';

const customActionPlay = 'play';

class BackgroundPlayerTask extends BackgroundAudioTask {
  final log = Logger('BackgroundPlayerTask');

  Player player = Player();

  @override
  Future<void> onPlay() async{

    player.play();
  }

  @override
  Future<void> onPause() {
    // TODO: implement onPause
    return super.onPause();
  }

  @override
  Future<void> onStart(Map<String, dynamic> params) {
    // TODO: implement onStart
    return super.onStart(params);
  }

  @override
  Future<void> onStop() {
    // TODO: implement onStop
    return super.onStop();
  }

  @override
  Future<void> onFastForward() {
    // TODO: implement onFastForward
    return super.onFastForward();
  }

  @override
  Future<void> onRewind() {
    // TODO: implement onRewind
    return super.onRewind();
  }

  @override
  Future<void> onSkipToNext() {
    // TODO: implement onSkipToNext
    return super.onSkipToNext();
  }

  @override
  Future<void> onSkipToPrevious() {
    // TODO: implement onSkipToPrevious
    return super.onSkipToPrevious();
  }

  @override
  Future onCustomAction(String name, arguments) async {
    log.info('onCustomAction');
    switch (name) {
      case customActionPlay:
        await player.setMediaItem(arguments);

    }

    return super.onCustomAction(name, arguments);
  }
}
