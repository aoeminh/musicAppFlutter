import 'package:music_flutter/bloc/bloc_base.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/model/podcast.dart';
import 'package:music_flutter/state/bloc_state.dart';
import 'package:music_flutter/model/feed.dart';
import 'package:music_flutter/service/podcast_service.dart';
import 'package:podcast_search/podcast_search.dart' as pcapi;
import 'package:rxdart/rxdart.dart';

class PodcastBloc extends BlocBase {
  final PodcastService podcastService;

//  final AudioPlayerService audioPlayerService;
//  final DownloadService downloadService;

  PodcastBloc(this.podcastService){
    init();
  }

  BehaviorSubject<Feed> _podcastFeed = BehaviorSubject();
  BehaviorSubject<BlocState<Podcast>> _podcastLoad = BehaviorSubject();


  Function(Feed) get load => _podcastFeed.add;

  List<Episode> _episodes;
  Podcast _podcast;
  init() {
    _listenPodcastLoad();
  }

  _listenPodcastLoad() async{
    _podcastFeed.listen((feed) async{
      _podcastLoad.sink.add(BlocLoadingState());
      _episodes = [];
      _podcast =await podcastService.loadPodcast(podcast: feed.podcast);

      _episodes = _podcast.episodes;
      _podcastLoad.sink.add(BlocResultState(_podcast));
      print('Pushed podcast with ID ${_podcast.id} to the podcast stream with ${_episodes.length} episodes');
    });
  }

  @override
  void dispose() {
    _podcastFeed.close();
    _podcastLoad.close();
  }
}
