/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'dart:async';
import 'dart:io' show Platform;
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/api/download_api.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/internal/locator.dart';

class DownloadService {
  final _api = locator<DownloadApi>();

  Future<Uint8List?> downloadImage(String url) async {
    final projects = await _api.downloadImage(url);

    final success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      return null;
    }
  }

  Future<Uint8List?> downloadImageWithToken(String url, String token) async {
    final projects = await _api.downloadImageWithToken(url, token);

    final success = projects.response != null;

    if (success) {
      return projects.response;
    } else {
      return null;
    }
  }
}

class DocumentsDownloadService {
  DocumentsDownloadService() {
    IsolateNameServer.registerPortWithName(_port.sendPort, _portName);
    _port.listen((dynamic data) {
      final id = data[0] as String;
      final status = data[1] as DownloadTaskStatus;
      //final progress = data[2] as int;

      if (id == taskId) {
        if (status == DownloadTaskStatus.complete)
          MessagesHandler.showSnackBar(context: Get.context!, text: tr('downloadComplete'));
        else if (status == DownloadTaskStatus.failed)
          MessagesHandler.showSnackBar(context: Get.context!, text: tr('downloadError'));
      }
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  final _port = ReceivePort();
  static const _portName = 'downloader_send_port';
  String? taskId;

  Future<void> downloadDocument(String url) async {
    final path = await getPath();
    if (path == null || path.isEmpty) {
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
      return;
    }

    if (!(await _checkPermission())) {
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('noPermission'));
      return;
    }

    final headers = await locator.get<CoreApi>().getHeaders();
    headers.removeWhere((key, value) => !key.startsWith('Auth'));

    taskId = await FlutterDownloader.enqueue(
      url: url,
      headers: headers,
      savedDir: path,
      saveInPublicStorage: true,
    );

    if (taskId == null || taskId!.isEmpty) {
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
      return;
    }

    await FlutterDownloader.loadTasks();
  }

  Future<String?> getPath() async {
    String? path;
    if (Platform.isAndroid) {
      try {
        path = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        path = (await getExternalStorageDirectory())?.path;
      }
    } else {
      path = (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return path;
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) return true;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt! <= 28) {
      if (await Permission.storage.status != PermissionStatus.granted) {
        if (await Permission.storage.request() != PermissionStatus.granted) return false;
      }
    }

    return true;
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final send = IsolateNameServer.lookupPortByName(_portName);
    send?.send([id, status, progress]);
  }
}
