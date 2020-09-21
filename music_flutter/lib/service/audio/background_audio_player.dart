import 'package:audio_service/audio_service.dart';
import 'package:logging/logging.dart';
import 'package:music_flutter/service/audio/player.dart';

const customActionPlay = 'play';

class BackgroundPlayerTask extends BackgroundAudioTask {
  final log = Logger('BackgroundPlayerTask');

  Player player = Player();

  @override
  Future<void> onPlay() async {
    print('onPlay');
    player.play();
  }

  @override
  Future<void> onPause() {
    print('onPause');
    player.pause();
  }

  @override
  Future<void> onStart(Map<String, dynamic> params) {
    print('onStart');
    player.start();
  }

  @override
  Future<void> onStop() async {
    print('onStop');
    player.stop();
    await super.onStop();
  }

  @override
  Future<void> onFastForward() {
    print('onFastForward');
    player.onFastForward();
  }

  @override
  Future<void> onRewind() {
    print('onRewind');
    player.onRewind();
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
  Future onClick(MediaButton button) {
    print('onClick');
    player.onClick();
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    await player.onSeekTo(position);
  }

  @override
  Future<dynamic> onCustomAction(String name, dynamic arguments) async {
    print('onCustomAction');
    switch (name) {
      case customActionPlay:
        await player.setMediaItem(arguments);
        break;
    }
  }
}
