import 'package:audio_service/audio_service.dart';
import 'package:logging/logging.dart';
import 'package:music_flutter/service/audio/player.dart';

const customActionPlay = 'play';

class BackgroundPlayerTask extends BackgroundAudioTask {
  final log = Logger('BackgroundPlayerTask');

  Player player = Player();

  @override
  Future<void> onPlay() async{
    print('onPlay');
    player.play();
  }

  @override
  Future<void> onPause() {
    print('onPause');
//    return super.onPause();
  }

  @override
  Future<void> onStart(Map<String, dynamic> params) {
    print('onStart');
    player.start();
 }

  @override
  Future<void> onStop() {
    print('onStop');
//    return super.onStop();
  }

  @override
  Future<void> onFastForward() {
    // TODO: implement onFastForward
//    return super.onFastForward();
  }

  @override
  Future<void> onRewind() {
    // TODO: implement onRewind
//    return super.onRewind();
  }

  @override
  Future<void> onSkipToNext() {
    // TODO: implement onSkipToNext
//    return super.onSkipToNext();
  }

  @override
  Future<void> onSkipToPrevious() {
    print('onSkipToPrevious');
  }

  @override
  Future<dynamic> onCustomAction(String name, dynamic arguments) async {
    log.info('onCustomAction');
    print('onCustomAction');
    switch (name) {
      case customActionPlay:
        await player.setMediaItem(arguments);

    }

  }
}
