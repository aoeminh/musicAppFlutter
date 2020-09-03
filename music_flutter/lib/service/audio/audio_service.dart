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
  /// Play a new episode, optionally resume at last save point.
  Future<void> playEpisode({Episode episode});

  /// Resume playing of current episode
  Future<void> play();

  /// Stop playing of current episode. Set update to false to stop
  /// playback without saving any episode or positional updates.
  Future<void> stop();

  /// Pause the current episode.
  Future<void> pause();

  /// Fast forward the current episode by pre-set number of seconds.
  Future<void> fastForward();

  /// Rewind the current episode by pre-set number of seconds.
  Future<void> rewind();

  /// Call when the app is resumed to re-establish the audio service.
  Future<void> resume();

  /// Call when the app is about to be suspended.
  Future<void> suspend();

  Stream<AudioState> audioStateStream;
}
