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

import 'package:event_hub/event_hub.dart';
import 'package:launch_review/launch_review.dart';
import 'package:projects/data/enums/file_type.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';
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

class FileCellController extends GetxController {
  final FilesService _api = locator<FilesService>();

  PortalInfoController portalInfoController = Get.find<PortalInfoController>();

  RxBool loaded = false.obs;

  TextEditingController searchInputController = TextEditingController();

  var file = PortalFile();
  var fileIcon = AppIcon(
          width: 20,
          height: 20,
          icon: SvgIcons.documents,
          color: Get.theme.colors().onSurface.withOpacity(0.6))
      .obs;

  void onFilePopupMenuSelected(value, PortalFile element) {}

  FileCellController({required PortalFile portalFile}) {
    file = portalFile;

    setupFileIcon();
  }

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

  Future<bool> deleteFile(PortalFile element) async {
    final result = await _api.deleteFile(
      fileId: element.id.toString(),
    );

    locator<EventHub>().fire('needToRefreshDocuments');

    return result != null;
  }

  Future<bool> renameFile(PortalFile element, String newName) async {
    final result = await _api.renameFile(
      fileId: element.id.toString(),
      newTitle: newName,
    );
    locator<EventHub>().fire('needToRefreshDocuments');
    return result != null;
  }

  Future<void> downloadFile(String viewUrl) async {
    await locator<DocumentsDownloadService>().downloadDocument(viewUrl);
  }

  Future openFile(PortalFile selectedFile) async {
    final userController = Get.find<UserController>();

    await userController.getUserInfo();
    final body = <String, dynamic>{
      'portal': portalInfoController.portalName,
      'email': userController.user.value!.email,
      'file': <String, int?>{'id': selectedFile.id},
      'folder': {
        'id': selectedFile.folderId,
        'parentId': null,
        'rootFolderType': selectedFile.rootFolderType
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
        AnalyticsService.Params.Key.extension: extension(selectedFile.title!)
      });
    } else {
      await LaunchReview.launch(
        androidAppId: Const.Identificators.documentsAndroidAppBundle,
        iOSAppId: Const.Identificators.documentsAppStore,
        writeReview: false,
      );
    }
  }
}
