import 'package:music_flutter/api/podcast_api.dart';
import 'package:music_flutter/service/podcast_service.dart';
import 'package:podcast_search/podcast_search.dart';

class PodcastServiceImpl extends PodcastService{
  PodcastServiceImpl(PodCastApi api) : super(api);

  @override
  Future<SearchResult> charts(int size) {
    return api.charts(size);
  }
}