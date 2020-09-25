import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:music_flutter/api/podcast_api.dart';
import 'package:music_flutter/model/podcast.dart';
import 'package:music_flutter/repository/repository.dart';
import 'package:podcast_search/podcast_search.dart' as psapi;

abstract class PodcastService{

  final PodCastApi api;
  final Repository repository;

  PodcastService(this.api, this.repository);

  Future<psapi.SearchResult> charts(int size);

  Future<Podcast> loadPodcast({
    @required Podcast podcast,
    bool refresh,
  });

  Future<Podcast> loadPodcastById({
    @required int id,
  });

}
