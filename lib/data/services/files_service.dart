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

import 'package:get/get.dart';
import 'package:projects/data/api/files_api.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class FilesService {
  final FilesApi _api = locator<FilesApi>();
  final SecureStorage _secureStorage = locator<SecureStorage>();

  Future getTaskFiles({required int taskId}) async {
    final files = await _api.getTaskFiles(taskId: taskId);
    final success = files.response != null;

    if (success) {
      return files.response;
    } else {
      await Get.find<ErrorDialog>().show(files.error!.message);
      return null;
    }
  }

  Future<FoldersResponse?> getFilesByParams({
    int? startIndex,
    String? query,
    String? sortBy,
    String? sortOrder,
    int? folderId,
    String? typeFilter,
    String? authorFilter,
    String? entityType,
  }) async {
    final files = await _api.getFilesByParams(
      startIndex: startIndex,
      query: query,
      sortBy: sortBy,
      sortOrder: sortOrder,
      folderId: folderId,
      typeFilter: typeFilter,
      authorFilter: authorFilter,
      entityType: entityType,
    );
    final success = files.response != null;

    if (success) {
      return files.response;
    } else {
      await Get.find<ErrorDialog>().show(files.error!.message);
      return null;
    }
  }

  Future<Folder?> renameFolder(
      {required String folderId, required String newTitle}) async {
    final files = await _api.renameFolder(
      folderId: folderId,
      newTitle: newTitle,
    );
    final success = files.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.folder
      });
      return files.response;
    } else {
      await Get.find<ErrorDialog>().show(files.error!.message);
      return null;
    }
  }

  Future deleteFolder({required String folderId}) async {
    final result = await _api.deleteFolder(
      folderId: folderId,
    );
    final success = result.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.deleteEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.folder
      });
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return null;
    }
  }

  Future<PortalFile?> renameFile(
      {required String fileId, required String newTitle}) async {
    final files = await _api.renameFile(
      fileId: fileId,
      newTitle: newTitle,
    );
    final success = files.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.file
      });
      return files.response;
    } else {
      await Get.find<ErrorDialog>().show(files.error!.message);
      return null;
    }
  }

  Future deleteFile({required String fileId}) async {
    final result = await _api.deleteFile(
      fileId: fileId,
    );
    final success = result.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.deleteEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.file
      });
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return null;
    }
  }

  Future moveDocument(
      {String? movingFolder,
      String? movingFile,
      required String targetFolder}) async {
    final result = await _api.moveDocument(
        movingFolder: movingFolder,
        targetFolder: targetFolder,
        movingFile: movingFile);

    final success = result.response!.error == null;

    if (success) {
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return null;
    }
  }

  Future copyDocument(
      {String? copyingFolder,
      String? copyingFile,
      required String targetFolder}) async {
    final result = await _api.copyDocument(
      copyingFolder: copyingFolder,
      targetFolder: targetFolder,
      copyingFile: copyingFile,
    );

    final success = result.response!.error == null;

    if (success) {
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return null;
    }
  }
}
