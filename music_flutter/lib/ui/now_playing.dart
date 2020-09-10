import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_flutter/bloc/audio_bloc.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/service/audio/audio_service.dart';
import 'package:provider/provider.dart';

const double _horizontalPadding = 20;
const double _verticalMargin = 50;

class NowPlaying extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios),
        ),
        title: Center(
          child: Text('Now playing'),
        ),
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context);
    return StreamBuilder<Episode>(
      stream: audioBloc.playStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final episode = snapshot.data;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: _verticalMargin,
              ),
              CachedNetworkImage(
                imageUrl: episode.imageUrl ?? '',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: _verticalMargin,
              ),
              Text(
                episode.title ?? 'Unknow',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                episode.author ?? 'Unknow',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: _verticalMargin,
              ),
              _buildSeekbar(audioBloc,episode)
            ],
          ),
        );
      },
    );
  }

  _buildSeekbar(AudioBloc audiobloc, Episode episode){
    return Container(
      color: Colors.black12,
      child: StreamBuilder<PositionState>(
        stream: audiobloc.postionStateStream,
        builder: (context, snapshot) {
          return Row(
            children: <Widget>[
              Text('${snapshot.data.position.inSeconds}'),
              SizedBox(
                width: 100,
              ),
              Text('${snapshot.data.percent}')
            ],
          );
        },
      ),
    );
  }
}
