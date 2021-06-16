import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/api/download_api.dart';
import 'package:projects/internal/locator.dart';

class DownloadService {
  final DownloadApi _api = locator<DownloadApi>();
  var coreApi = locator<CoreApi>();

  Future<Uint8List> downloadImage(String url) async {
    var projects = await _api.downloadImage(url);

    var success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      return null;
    }
  }

  Future downloadDocument(String url) async {
    var dir;
    if (Platform.isAndroid)
      dir = await getExternalStorageDirectory();
    else
      dir = await getApplicationDocumentsDirectory();

    var path = dir.path;
    print(path);

    var headers = await coreApi.getHeaders();
    FlutterDownloader.registerCallback(downloadCallback);

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      headers: headers,
      savedDir: path,
      showNotification: true,
      openFileFromNotification: true,
    );

    var waitTask = true;
    while (waitTask) {
      var query = "SELECT * FROM task WHERE task_id='$taskId'";
      var _tasks = await FlutterDownloader.loadTasksWithRawQuery(query: query);
      var taskStatus = _tasks[0].status.toString();
      var taskProgress = _tasks[0].progress;
      if (taskStatus == 'DownloadTaskStatus(3)' && taskProgress == 100) {
        waitTask = false;
      }
    }

    await FlutterDownloader.open(taskId: taskId);
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {}
}
