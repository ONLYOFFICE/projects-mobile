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
import 'dart:io' show Directory, File;
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projects/data/api/download_api.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/portal_info_controller.dart';
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
    if (!IsolateNameServer.registerPortWithName(_port.sendPort, _portName)) {
      IsolateNameServer.removePortNameMapping(_portName);
      if (!IsolateNameServer.registerPortWithName(_port.sendPort, _portName))
        debugPrint('error register port');
    }

    _port.listen((dynamic data) async {
      final id = data[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      debugPrint('Downloading: task ($id), status: ($status), progress: ($progress)');

      await _callbacksList[id]?.call(id, status, progress);

      if (status == DownloadTaskStatus.complete ||
          status == DownloadTaskStatus.canceled ||
          status == DownloadTaskStatus.failed) _callbacksList.remove(id);
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  final _port = ReceivePort();
  static const _portName = 'downloader_send_port';

  String? tempPath;
  String? downloadPath;

  final _callbacksList = <String, Function(String id, DownloadTaskStatus status, int progress)>{};

  bool registerCallback({
    required String taskId,
    required Function(String id, DownloadTaskStatus status, int progress) callback,
  }) {
    _callbacksList[taskId] = callback;

    return true;
  }

  Future<String?> downloadDocument(PortalFile file, {bool temp = false}) async {
    if (!(await _checkPermission())) {
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('noPermission'));
      return null;
    }

    if (tempPath == null || downloadPath == null) await initPaths();

    File _file;
    if (temp) {
      _file = File('$tempPath/${file.title!}');
      // ignore: avoid_slow_async_io
      if (await _file.exists()) await _file.delete();
    } else {
      _file = File('$downloadPath/${file.title!}');
      // ignore: avoid_slow_async_io
      while (await _file.exists()) {
        final dotIndex = _file.path.lastIndexOf('.');
        _file = File('${_file.path.substring(0, dotIndex)}(1)${file.fileExst!}');
      }
    }
    final fileName = _file.path.substring(_file.path.lastIndexOf('/') + 1);

    final finalUrl = await getRedirectedUrl(file.viewUrl!);

    Map<String, String>? headers;
    if (finalUrl.contains(Get.find<PortalInfoController>().portalName!))
      headers = Get.find<PortalInfoController>().getAuthHeader;

    return await FlutterDownloader.enqueue(
      url: finalUrl,
      fileName: fileName,
      headers: headers,
      savedDir: temp ? tempPath! : downloadPath!,
      showNotification: !temp,
    );
  }

  Future<String> getRedirectedUrl(String initialUrl) async {
    final headers = Get.find<PortalInfoController>().getAuthHeader;

    var statusCode = 302;
    var finalUrl = Uri.parse(initialUrl);

    while (statusCode == 302) {
      if (!finalUrl.hasAuthority)
        finalUrl = Uri.parse(Get.find<PortalInfoController>().portalUri! + finalUrl.toString());

      final request = Request('GET', finalUrl)..followRedirects = false;

      if (finalUrl.authority.contains(Get.find<PortalInfoController>().portalName!))
        request.headers.addAll(headers!);

      final client = Client();
      final response = await client.send(request);
      client.close();

      statusCode = response.statusCode;
      if (statusCode == 302) finalUrl = Uri.parse(response.headers['location'].toString());
    }

    return finalUrl.toString();
  }

  Future<void> initPaths() async {
    final _tempPath = (await getTemporaryDirectory()).absolute.path;
    // ignore: avoid_slow_async_io
    if (!(await Directory(_tempPath).exists())) await Directory(_tempPath).create();

    tempPath = _tempPath;

    String? _downloadPath;
    if (GetPlatform.isAndroid) {
      try {
        _downloadPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        _downloadPath = (await getExternalStorageDirectory())?.absolute.path;
      }
    } else {
      _downloadPath = (await getApplicationDocumentsDirectory()).absolute.path;
    }

    // ignore: avoid_slow_async_io
    if (!(await Directory(_downloadPath!).exists())) await Directory(_downloadPath).create();

    downloadPath = _downloadPath;
  }

  Future<bool> _checkPermission() async {
    if (await Permission.storage.status != PermissionStatus.granted) {
      if (await Permission.storage.request() != PermissionStatus.granted) return false;
    }

    return true;
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final send = IsolateNameServer.lookupPortByName(_portName);
    send?.send([id, status, progress]);
  }
}
