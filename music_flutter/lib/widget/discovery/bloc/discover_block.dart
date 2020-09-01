import 'package:music_flutter/bloc/bloc_base.dart';
import 'package:music_flutter/service/podcast_service.dart';
import 'package:music_flutter/widget/discovery/bloc/discover_event_state.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:rxdart/rxdart.dart';

class DiscoverBloc extends BlocBase {
  PodcastService podcastService;
  BehaviorSubject<DiscoverEvent> _discoverBloc = BehaviorSubject();
  Stream<DiscoveryState>  _discoveryResult;
  SearchResult _result;


  DiscoverBloc(this.podcastService){
    _discoveryResult = _discoverBloc.switchMap((discoveryEvent) => getDiscovery(discoveryEvent));
  }

  Stream<DiscoveryState> getDiscovery(DiscoverEvent event) async*{
    print('sfs');
    yield DiscoveryLoadingState();
    if(event is DiscoverGetListEvent) {
      _result ??= await podcastService.charts(event.count);
      yield DiscoveryResultState<SearchResult>(_result);
    }
  }

  Stream<DiscoveryState> get discoverStream => _discoveryResult;
  void Function(DiscoverEvent) get getDisCover => _discoverBloc.add;

  @override
  void dispose() {
    _discoverBloc.close();
  }

}