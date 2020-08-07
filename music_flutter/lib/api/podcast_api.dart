import 'package:podcast_search/podcast_search.dart';

abstract class PodCastApi{

  /// request the top pad cast charts from itunes, and at most [size] records
  Future<SearchResult> charts(int size);

  /// Search iTunes for podcasts matching the search criteria. Returns a
  /// [SearchResult] instance.
  Future<SearchResult> search(
      String term, {
        String country,
        String attribute,
        int limit,
        String language,
        int version = 0,
        bool explicit = false,
      });

}