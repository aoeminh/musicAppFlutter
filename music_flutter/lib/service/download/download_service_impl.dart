import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:music_flutter/model/downloadable.dart';
import 'package:music_flutter/model/episode.dart';
import 'package:music_flutter/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart';
import 'donwload_service.dart';

final String port_name = 'downloader_send_port';

class DownloadProgress {
  final String id;
  final int percent;
  final DownloadState state;

  DownloadProgress(this.id, this.percent, this.state);
}

class DownloadServiceImpl extends DownloadService {
  static BehaviorSubject<DownloadProgress> downloadSubject = BehaviorSubject();
  static BehaviorSubject<Episode> updateEpdisodeSubject = BehaviorSubject();

  ReceivePort _port = ReceivePort();

  DownloadServiceImpl() {
    _init();
  }
  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping(port_name);
    updateEpdisodeSubject.close();
    downloadSubject.close();
  }

  @override
  Stream<DownloadProgress> get downloadProgress => downloadSubject.stream;

  @override
  Stream<Episode> get episodeListener => updateEpdisodeSubject.stream;

  @override
  Future<bool> downloadEpisode(Episode episode) async {
    final season = episode.season > 0 ? episode.season.toString() : '';
    final ep = episode.episode > 0 ? episode.episode.toString() : '';

    if (await hasStoragePermision()) {
      String downloadPath =
          join(await getStorageDirectory(), safePath(episode.podcast));

      print(
          'getStorageDirectory ${await getStorageDirectory()} safePath(episode.podcast) ${safePath(episode.podcast)}');
      print('downloadPath: $downloadPath');
      Directory(downloadPath).createSync(recursive: true);
      Uri uri = Uri.parse(episode.contentUrl);

      // Filename should be last segment of URI.
      var filename = safePath(uri.pathSegments
          .firstWhere((e) => e.endsWith('.mp3'), orElse: () => null));
      filename ??
          safePath(uri.pathSegments
              .firstWhere((e) => e.endsWith('.m4a'), orElse: () => null));
      if (filename != null) {
        // Some podcasts use the same file name for each episode, but also set the
        // iTunes season and episode number values. If these are set, use them as
        // part of the file name.
        filename = '$season$ep$filename';
        print('Download file (${episode?.title}) $filename to $downloadPath');
        final taskId = await FlutterDownloader.enqueue(
            url: episode.contentUrl,
            savedDir: downloadPath,
            fileName: filename,
            showNotification: true);
        print('taskId $taskId');
        episode.downloadTaskId = taskId;
        episode.filepath = downloadPath;
        episode.downloadState = DownloadState.downloading;
        episode.downloadPercentage = 0;
        episode.filename = filename;

        updateEpdisodeSubject.add(episode);
        return Future.value(true);
      }
    }

    return Future.value(false);
  }

  void _init() async {
    await FlutterDownloader.initialize();
    IsolateNameServer.registerPortWithName(_port.sendPort, port_name);

    _port.listen((data) {
      String id = data[0];
      var status = data[1] as DownloadTaskStatus;
      var process = data[2];
      print('_port id $id status $status process $process ');
      var state = DownloadState.none;
      if (status == DownloadTaskStatus.enqueued) {
        state = DownloadState.queued;
      } else if (status == DownloadTaskStatus.canceled) {
        state = DownloadState.cancelled;
      } else if (status == DownloadTaskStatus.complete) {
        state = DownloadState.downloaded;
        _clearDonwload(id);
      } else if (status == DownloadTaskStatus.running) {
        state = DownloadState.downloading;
      } else if (status == DownloadTaskStatus.failed) {
        state = DownloadState.failed;
      } else if (status == DownloadTaskStatus.paused) {
        state = DownloadState.paused;
      }
      downloadSubject.add(DownloadProgress(id, process, state));
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  _clearDonwload(String id) {
    FlutterDownloader.remove(taskId: id);
  }
}

void downloadCallback(String id, DownloadTaskStatus status, int process) {
  final send = IsolateNameServer.lookupPortByName(port_name);
  send.send([id, status, process]);
}
