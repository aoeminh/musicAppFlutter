import 'package:music_flutter/model/episode.dart';

import 'download_service_impl.dart';

abstract class DownloadService {
  Future<bool> downloadEpisode(Episode episode);

  void dispose();

  Stream<DownloadProgress> downloadProgress;
  Stream<Episode> episodeListener;
}
