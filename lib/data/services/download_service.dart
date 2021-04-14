import 'dart:async';
import 'dart:typed_data';

import 'package:projects/data/api/download_api.dart';

import 'package:projects/internal/locator.dart';

class DownloadService {
  final DownloadApi _api = locator<DownloadApi>();

  Future<Uint8List> downloadImage(String url) async {
    var projects = await _api.downloadImage(url);

    var success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      // ErrorDialog.show(projects.error);
      return null;
    }
  }
}
