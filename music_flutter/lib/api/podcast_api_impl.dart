import 'package:music_flutter/api/podcast_api.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:flutter/foundation.dart';

class PodCastApiImpl extends PodCastApi {
  final Search api = Search();

  @override
  Future<SearchResult> charts(int size) async{
    return _chart(size);
  }

  Future<SearchResult> _chart(int size){
    return api.charts(limit: size??10).timeout(Duration(seconds: 20));
  }

  @override
  Future<SearchResult> search(String term,
      {String country,
      String attribute,
      int limit,
      String language,
      int version = 0,
      bool explicit = false}) {
    return null;
  }
}
