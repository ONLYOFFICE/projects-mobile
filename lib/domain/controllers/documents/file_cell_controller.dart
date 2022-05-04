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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:projects/data/enums/file_type.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
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

class FileCellController extends GetxController {
  final _api = locator<FilesService>();
  final downloadService = locator<DocumentsDownloadService>();

  final portalInfoController = Get.find<PortalInfoController>();

  late final PortalFile file;
  final fileIcon = AppIcon(
          width: 20,
          height: 20,
          icon: SvgIcons.documents,
          color: Get.theme.colors().onSurface.withOpacity(0.6))
      .obs;

  final progress = Rx<double>(0);
  String? downloadPath;

  FileCellController({required this.file}) {
    setupFileIcon();
  }

  bool get downloadInProgress => progress.value > 0;

  void setupFileIcon() {
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

    return await _api.waitFinishOperation(result[0].id!);
  }

  Future<bool> renameFile(String newName) async {
    final result = await _api.renameFile(
      fileId: file.id.toString(),
      newTitle: newName,
    );

    return result != null;
  }

  Future<void> downloadFileCallback(int id, int received, int total) async {
    if (id == file.id) {
      progress.value = received / total;

      if (received == total) {
        progress.value = 0;
      }

      /* if (status == DownloadTaskStatus.complete)
        MessagesHandler.showSnackBar(context: Get.context!, text: tr('downloadComplete'));
      else if (status == DownloadTaskStatus.failed)
        MessagesHandler.showSnackBar(context: Get.context!, text: tr('downloadError'));
      else if (status == DownloadTaskStatus.running) {
        this.progress.value = progress;
      } */
    }
  }

  Future<void> viewFileCallback(int id, int received, int total) async {
    if (id == file.id) {
      progress.value = received / total;

      if (received == total) {
        Get.back();

        progress.value = 0;

        if ((await tryToOpenAlreadyDownloadedFile())?.type != ResultType.done)
          MessagesHandler.showSnackBar(context: Get.context!, text: tr('openFileError'));
      } /*  else if (status == DownloadTaskStatus.failed) {
        Get.back();
        MessagesHandler.showSnackBar(context: Get.context!, text: tr('downloadError'));
      } else if (status == DownloadTaskStatus.running) {
        this.progress.value = progress;
      } */
    }
  }

  Future<void> downloadFile() async {
    if (downloadInProgress) return;

    downloadPath = await downloadService.downloadDocument(file);
    if (downloadPath == null) {
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('downloadError'));
      return;
    }

    downloadService.registerCallback(taskId: file.id!, callback: downloadFileCallback);
  }

  Future<void> cancelDownloadFile() async {
    if (downloadPath != null) {
      downloadService.cancelToken.cancel();
      progress.value = 0;
    }
  }

  Future<OpenResult?> tryToOpenAlreadyDownloadedFile() async {
    if (downloadPath != null)
      return await OpenFile.open(downloadPath);
    else
      return null;
  }

  Future<void> viewFile() async {
    if (downloadInProgress) return;

    if ((await tryToOpenAlreadyDownloadedFile())?.type == ResultType.done) return;

    unawaited(Get.dialog(
      SingleButtonDialog(
        titleText: '${tr('downloading')} ${file.title!}',
        acceptText: tr('cancel'),
        onAcceptTap: () async {
          Get.back();
          await cancelDownloadFile();
        },
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              Obx(
                () => LinearProgressIndicator(
                  value: progress.value,
                  color: Get.theme.colors().primary,
                  backgroundColor: Get.theme.colors().backgroundSecond,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 0),
                child: Row(
                  children: [
                    const Spacer(),
                    Obx(
                      () => Text(
                        '${(progress.value * 100).toStringAsFixed(0)} %',
                        style: TextStyleHelper.body2(color: Get.theme.colors().onSurface),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    ));

    downloadService.registerCallback(taskId: file.id!, callback: viewFileCallback);

    downloadPath = await downloadService.downloadDocument(file, temp: true);
    if (downloadPath == null) {
      Get.back();
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('downloadError'));
      return;
    }
  }

  Future openFile({int? parentId}) async {
    if (file.fileType! < 5 || file.fileExst == '.pdf')
      await viewFile();
    else
      await openFileInDocumentsApp(parentId: parentId);
  }

  Future openFileInDocumentsApp({int? parentId}) async {
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
