import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';

class Player {
  AudioPlayer _audioPlayer = AudioPlayer();
  final log = Logger('Player');
  String _uri;
  int _position;
  List<MediaControl> controls = [];
  AudioProcessingState _playbackState;
  bool _playing= false;

  Future<void> play()async{
    await _audioPlayer.setUrl(_uri);
    setStatePlaying();

  }
  Future<void> setStatePlaying()async{
    _playbackState = AudioProcessingState.ready;
    controls =
    [MediaControl.skipToPrevious, MediaControl.pause, MediaControl.skipToNext];
    _playing = true;
    await _setState();
  }

  Future<void> _setState()async{
    log.fine('_setState() to ');
    await AudioServiceBackground.setState(controls: controls, processingState: null, playing: true);
  }

  Future<void> setMediaItem(dynamic args) async {
    _uri = args[3];
    _position = int.parse(args[5]);
    await AudioServiceBackground.setMediaItem(
      MediaItem(
        id: '1000',
        title: args[1],
        artUri: _uri,
        album: args[0],
      ),
    );
  }
}
