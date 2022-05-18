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
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:launch_review/launch_review.dart';
import 'package:projects/data/enums/file_type.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/loading_hud.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/internal/constants.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/domain/controllers/portal_info_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:open_file/open_file.dart';
import 'package:synchronized/synchronized.dart';

enum FileAction { OnlyDownload, DownloadAndOpen }

class FileCellController extends GetxController {
  final _api = locator<FilesService>();
  final downloadService = locator<DocumentsDownloadService>();

  final portalInfoController = Get.find<PortalInfoController>();

  final _openFileLock = Lock();

  late final LoadingWithProgress loadingWithProgress;

  String? downloadTaskId;
  final progress = Rx<double>(0);
  final fileAction = Rx<FileAction>(FileAction.OnlyDownload);
  StreamSubscription? downloadProgressListener;

  late final PortalFile file;
  final fileIcon = AppIcon(
          width: 20,
          height: 20,
          icon: SvgIcons.documents,
          color: Theme.of(Get.context as BuildContext).colors().onSurface.withOpacity(0.6))
      .obs;

  FileCellController({required this.file}) {
    loadingWithProgress = LoadingWithProgress(
        title: tr('downloading'),
        progress: progress,
        onCancelTap: () async {
          loadingWithProgress.showLoading(false);
          await cancelDownloadFile();
        });

    _setupFileIcon();
  }

  void _setupFileIcon() {
    var iconString = '';

    final fileExtention = file.fileExst?.replaceAll('.', '');
    switch (fileExtention) {
      case 'csv':
        iconString = SvgIcons.csv;
        break;
      case 'docxf':
        iconString = SvgIcons.docxf;
        break;
      case 'dotx':
        iconString = SvgIcons.dotx;
        break;
      case 'html':
        iconString = SvgIcons.html;
        break;
      case 'jpg':
        iconString = SvgIcons.jpg;
        break;
      case 'odp':
        iconString = SvgIcons.odp;
        break;
      case 'ods':
        iconString = SvgIcons.ods;
        break;
      case 'odt':
        iconString = SvgIcons.odt;
        break;
      case 'oform':
        iconString = SvgIcons.oform;
        break;
      case 'otp':
        iconString = SvgIcons.otp;
        break;
      case 'ots':
        iconString = SvgIcons.ots;
        break;
      case 'ott':
        iconString = SvgIcons.ott;
        break;
      case 'pdf':
        iconString = SvgIcons.pdf;
        break;
      case 'pdfa':
        iconString = SvgIcons.pdfa;
        break;
      case 'png':
        iconString = SvgIcons.png;
        break;
      case 'potx':
        iconString = SvgIcons.potx;
        break;
      case 'rtf':
        iconString = SvgIcons.rtf;
        break;
      case 'txt':
        iconString = SvgIcons.txt;
        break;
      case 'xltx':
        iconString = SvgIcons.xltx;
        break;

      default:
        iconString = '';
    }

    if (iconString.isEmpty) {
      switch (file.fileType) {
        case FileType.Unknown:
          iconString = SvgIcons.unknown;
          break;
        case FileType.Archive:
          iconString = SvgIcons.archive;
          break;
        case FileType.Video:
          iconString = SvgIcons.video;
          break;
        case FileType.Audio:
          iconString = SvgIcons.audio;
          break;
        case FileType.Image:
          iconString = SvgIcons.image;
          break;
        case FileType.Spreadsheet:
          iconString = SvgIcons.spreadsheet_old;
          break;
        case FileType.Presentation:
          iconString = SvgIcons.presentation_old;
          break;
        case FileType.Document:
          iconString = SvgIcons.document_old;
          break;
        default:
          iconString = SvgIcons.unknown;
      }
    }

    fileIcon.value = AppIcon(width: 20, height: 20, icon: iconString);
  }

  Future<String?> deleteFile() async {
    final result = await _api.deleteFile(fileId: file.id.toString());

    if (result == null || result.isEmpty) return tr('error');

    final loading = LoadingWithoutProgress();
    loading.showLoading(true);

    final res = await _api.waitFinishOperation(result[0].id!);

    loading.showLoading(false);

    return res;
  }

  Future<bool> renameFile(String newName) async {
    final result = await _api.renameFile(
      fileId: file.id.toString(),
      newTitle: newName,
    );

    return result != null;
  }

  Future<void> _downloadFileCallback(String id, DownloadTaskStatus status, int progress) async {
    if (downloadTaskId != null && id == downloadTaskId) {
      if (status == DownloadTaskStatus.running &&
          progress != 0 &&
          this.progress.value != progress / 100 &&
          (Platform.isAndroid || progress / 100 != 1)) {
        this.progress.value = progress / 100;
      }
      if (status == DownloadTaskStatus.complete) {
        if (this.progress.value != 1) this.progress.value = 1;

        MessagesHandler.showSnackBar(context: Get.context!, text: tr('downloadComplete'));
      }
      if (status == DownloadTaskStatus.failed && Platform.isIOS) {
        this.progress.value = 0;

        MessagesHandler.showSnackBar(context: Get.context!, text: tr('downloadError'));
      }
    }
  }

  Future<ResultType?> _openAlreadyDownloadedFile() async {
    final res = await downloadService.getTaskContent(downloadTaskId!);
    if (res == null) return null;

    final savedDir = fileAction.value == FileAction.OnlyDownload && Platform.isAndroid
        ? downloadService.downloadPath!
        : downloadService.tempPath!;

    return (await OpenFile.open('$savedDir/${res.filename!}')).type;
  }

  Future<ShareResultStatus?> _shareFileForIos(
    BuildContext context, {
    bool deleteAfter = true,
  }) async {
    if (downloadTaskId == null) return null;

    final res = await downloadService.getTaskContent(downloadTaskId!);
    if (res == null) return null;

    final savedDir = fileAction.value == FileAction.OnlyDownload && Platform.isAndroid
        ? downloadService.downloadPath!
        : downloadService.tempPath!;

    final _file = File('$savedDir/${res.filename!}');
    // ignore: avoid_slow_async_io
    if (!(await _file.exists())) return null;

    final box = context.findRenderObject() as RenderBox;
    final result = (await Share.shareFilesWithResult(
      ['$savedDir/${res.filename!}'],
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    ))
        .status;

    if (deleteAfter && result == ShareResultStatus.success) await _file.delete();

    return result;
  }

  Future<bool> cancelDownloadFile() async {
    var tryes = 0;
    while (downloadTaskId == null && tryes < 5) {
      await Future.delayed(const Duration(seconds: 1));
      tryes++;
    }

    await FlutterDownloader.cancel(taskId: downloadTaskId!);
    progress.value = 0;

    return true;
  }

  Future<void> downloadFile(BuildContext context) async {
    if (progress.value > 0) return;

    if (Platform.isIOS && (await _shareFileForIos(context)) != null) return;

    await downloadProgressListener?.cancel();

    fileAction.value = FileAction.OnlyDownload;
    progress.value = 0.01;

    downloadTaskId = await downloadService.downloadDocument(file, temp: Platform.isIOS);
    if (downloadTaskId == null) {
      progress.value = 0;
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('downloadError'));
      return;
    }

    downloadProgressListener = progress.listen((value) async {
      if (value == 1) {
        progress.value = 0;
        if (Platform.isIOS) await _shareFileForIos(context);
      }
    });

    downloadService.registerCallback(taskId: downloadTaskId!, callback: _downloadFileCallback);
  }

  Future<void> _viewFile() async {
    if (progress.value > 0) return;
    await downloadProgressListener?.cancel();

    if (downloadTaskId != null && ((await _openAlreadyDownloadedFile()) == ResultType.done)) return;

    loadingWithProgress.showLoading(true);
    fileAction.value = FileAction.DownloadAndOpen;

    downloadTaskId = await downloadService.downloadDocument(file, temp: true);
    if (downloadTaskId == null) {
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('downloadError'));
      loadingWithProgress.showLoading(false);
      return;
    }

    downloadProgressListener = progress.listen((value) async {
      if (value == 0) {
        loadingWithProgress.showLoading(false);
        return;
      }

      if (value == 1) {
        progress.value = 0;
        if ((await _openAlreadyDownloadedFile()) != ResultType.done)
          MessagesHandler.showSnackBar(context: Get.context!, text: tr('openFileError'));
      } else
        loadingWithProgress.showLoading(true);
    });

    downloadService.registerCallback(taskId: downloadTaskId!, callback: _downloadFileCallback);
  }

  void openFile({int? parentId}) {
    if (_openFileLock.locked) return;

    _openFileLock.synchronized(() async {
      if (file.fileType == FileType.Audio ||
          file.fileType == FileType.Video ||
          file.fileType == FileType.Image ||
          file.fileType == FileType.Archive ||
          file.fileType == FileType.Unknown) return await _viewFile();

      if (file.fileExst != '.pdf' && file.fileExst != '.fb2' && file.fileExst != '.epub')
        await _openFileInDocumentsApp(parentId: parentId);
      else
        await _viewFile();
    });
  }

  Future _openFileInDocumentsApp({int? parentId}) async {
    final userController = Get.find<UserController>();
    await userController.getUserInfo();

    final body = <String, dynamic>{
      'portal': portalInfoController.portalName,
      'email': userController.user.value!.email,
      'originalUrl': file.viewUrl,
      'file': <String, int?>{'id': file.id},
      'folder': {
        'id': file.folderId,
        'parentId': parentId,
        'rootFolderType': file.rootFolderType,
      }
    };

    final bodyString = jsonEncode(body);
    final stringToBase64 = utf8.fuse(base64);
    final encodedBody = stringToBase64.encode(bodyString);
    final urlString = '${Const.Urls.openDocument}$encodedBody';

    var canOpen = false;
    if (GetPlatform.isAndroid) {
      canOpen = await canLaunch(urlString);
      if (canOpen) await launch(urlString);
    } else {
      canOpen = await launch(urlString);
    }

    if (canOpen) {
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.openEditor, {
        AnalyticsService.Params.Key.portal: portalInfoController.portalName,
        AnalyticsService.Params.Key.extension: extension(file.title!)
      });
    } else
      await LaunchReview.launch(
        androidAppId: Const.Identificators.documentsAndroidAppBundle,
        iOSAppId: Const.Identificators.documentsAppStore,
        writeReview: false,
      );
  }
}
