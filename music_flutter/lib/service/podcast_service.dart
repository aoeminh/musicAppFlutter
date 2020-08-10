import 'package:music_flutter/api/podcast_api.dart';
import 'package:podcast_search/podcast_search.dart';

abstract class PodcastService{

  final PodCastApi api;

  PodcastService(this.api);

  Future<SearchResult> charts(int size);

}