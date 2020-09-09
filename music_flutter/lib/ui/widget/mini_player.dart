import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_flutter/bloc/audio_bloc.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/service/audio/audio_service.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatefulWidget {
  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context);
    return StreamBuilder<AudioState>(
      stream: audioBloc.audioStateStream,
      builder: (context, snapshot) {
        print('snapshot.data');
        if (snapshot.data == AudioState.none ||
            snapshot.data == AudioState.stopped) {
          return Container();
        } else {
          return _MiniPlayer();
        }
      },
    );
  }
}

class _MiniPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context);
    return StreamBuilder<Episode>(
      stream: audioBloc.playStream,
      builder: (context, snapshot) {
        print('audioBloc.playStream');
        if (snapshot.hasData) {
          final episode = snapshot.data;
          return Container(
            color: Colors.black12,
            child: ListTile(
              leading: CachedNetworkImage(
                imageUrl: episode.imageUrl,
              ),
              title: Text(episode.title),
              subtitle: Text(episode.author ?? ''),
              trailing: StreamBuilder<AudioState>(
                  stream: audioBloc.audioStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state == AudioState.playing) {
                      return InkWell(
                        onTap: () {
                          audioBloc.transitionState(TransitionState.pause);
                        },
                        child: Icon(
                          Icons.pause,
                          size: 38,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          audioBloc.transitionState(TransitionState.play);
                        },
                        child: Icon(
                          Icons.play_arrow,
                          size: 38,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }
                  }),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
