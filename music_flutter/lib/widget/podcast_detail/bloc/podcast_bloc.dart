import 'dart:async';
import 'dart:async';

import 'package:music_flutter/bloc/bloc_base.dart';
import 'package:music_flutter/bloc/bloc_state.dart';
import 'package:music_flutter/model/feed.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:rxdart/rxdart.dart';

class PodcastBloc extends BlocBase {
  BehaviorSubject<Feed> _podcastFeed = BehaviorSubject();
  BehaviorSubject<BlocState<Podcast>> _podcastLoad = BehaviorSubject();

  Function(Feed) get load => _podcastFeed.add;

  init() {}

  _listenPodcastLoad() {
    _podcastFeed.listen((feed) {});
  }



  @override
  void dispose() {
    _podcastFeed.close();
    _podcastLoad.close();
  }
}
