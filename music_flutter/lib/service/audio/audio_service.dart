import 'package:music_flutter/model/episode.dart';

enum AudioState {
  none,
  buffering,
  starting,
  playing,
  pausing,
  stopped,
}

abstract class AudioPlayerService {
  Future<void> play({Episode episode});

  Future<void> stop();

  Future<void> pause();

  Future<void> fastForward();

  Future<void> rewind();
}
