import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/model/feed.dart';
import 'package:music_flutter/model/podcast.dart';
import 'package:music_flutter/state/bloc_state.dart';
import 'bloc/podcast_bloc.dart';
import '../podcast_detail/episode_widget.dart';
import 'package:provider/provider.dart';

import '../decorate_icon_button.dart';

const double expandHeight = 300;

class PodcastDetail extends StatefulWidget {
  final Podcast podcastMusic;
  final PodcastBloc bloc;

  const PodcastDetail({Key key, this.podcastMusic, this.bloc})
      : super(key: key);

  @override
  _PodcastDetailState createState() => _PodcastDetailState();
}

class _PodcastDetailState extends State<PodcastDetail> {
  ScrollController _scrollController = ScrollController();
  bool _toolbarCollap = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bloc.load(Feed(podcast: widget.podcastMusic));
    _scrollController.addListener(() {
      if (!_toolbarCollap &&
          _scrollController.hasClients &&
          _scrollController.offset > (expandHeight - kToolbarHeight)) {
        setState(() {
          _toolbarCollap = true;
        });
      } else if (_toolbarCollap &&
          _scrollController.hasClients &&
          _scrollController.offset < (expandHeight - kToolbarHeight)) {
        setState(() {
          _toolbarCollap = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PodcastBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            leading: DecorateIconButton(
              icon: Icons.close,
              iconColor: _toolbarCollap ? Colors.black : Colors.white,
              decorationColor:
                  _toolbarCollap ? Colors.white : Color(0x22000000),
              onPress: () => Navigator.pop(context),
            ),
            title: _toolbarCollap
                ? Text(widget.podcastMusic.title,
                    style: TextStyle(color: Colors.black))
                : Text(''),
            expandedHeight: expandHeight,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'Hl ${widget.podcastMusic.title}',
                child: ExcludeSemantics(
                  child: CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    imageUrl: widget.podcastMusic.imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildHeder(bloc),
          _buildListEpisode(bloc)
        ],
      ),
    );
  }

  _buildListEpisode(PodcastBloc bloc) => StreamBuilder(
        stream: bloc.listEpisode,
        builder: (context, AsyncSnapshot<List<Episode>> snapshot) {
          if (snapshot.hasData) {
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return InkWell(
                  onTap: (){

                  },
                  child: EpisodeWidget(
                    espisode: snapshot.data[index],

                  ),
                );
              }, childCount: snapshot.data.length),
            );
          } else {
            return SliverToBoxAdapter(
              child: Container(),
            );
          }
        },
      );

  _buildHeder(PodcastBloc bloc) {
    final textTheme = Theme.of(context).textTheme;
    return StreamBuilder<BlocState<Podcast>>(
      stream: bloc.podcastStream,
      initialData: BlocLoadingState(),
      builder: (context, AsyncSnapshot<BlocState<Podcast>> snapshot) {
        final state = snapshot.data;
        if (state is BlocLoadingState) {
          return SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is BlocResultState<Podcast>) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    state.result.title,
                    style: textTheme.headline,
                  ),
                  Text(state.result.copyright, style: textTheme.caption),
                  Text(state.result.description, style: textTheme.body1)
                ],
              ),
            ),
          );
        } else {
          return SliverToBoxAdapter(
            child: Center(
              child: Text('Empty'),
            ),
          );
        }
      },
    );
  }
}
