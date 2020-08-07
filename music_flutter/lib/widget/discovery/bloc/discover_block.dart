import 'dart:html';
import 'dart:math';

import 'package:music_flutter/bloc/bloc_base.dart';
import 'package:music_flutter/widget/discovery/bloc/discover_event_state.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:rxdart/rxdart.dart';

class DiscoverBloc extends BlocBase {

  BehaviorSubject<DiscoverEvent> _discoverBloc = BehaviorSubject();

  Stream<DiscoveryState>  _discoveryResult;
  SearchResult _result;


  DiscoverBloc(){
    _discoveryResult = _discoverBloc.switchMap((discoveryEvent) => getDiscovery(discoveryEvent));
  }

  Stream<DiscoveryState> getDiscovery(DiscoverEvent event) async*{
    yield DiscoveryLoadingState();
    if(event is DiscoverGetListEvent) {
//      _result = await
    }
  }

  Stream<DiscoveryState> get discoverStream => _discoveryResult;
  void Function(DiscoverEvent) get getDisCover => _discoverBloc.add;

  @override
  void dispose() {
    _discoverBloc.close();
  }

}