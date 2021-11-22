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

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/move_folder_response.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class FilesApi {
  Future<ApiDTO<List<PortalFile>>> getTaskFiles({int? taskId}) async {
    var url = await locator.get<CoreApi>().getTaskFilesUrl(taskId: taskId);

    var result = ApiDTO<List<PortalFile>>();

    try {
      var response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => PortalFile.fromJson(i))
            .toList();
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<FoldersResponse>> getFilesByParams({
    int? startIndex,
    String? query,
    String? sortBy,
    String? sortOrder,
    int? folderId,
    String? typeFilter,
    String? authorFilter,
    String? entityType,
  }) async {
    var url = await locator.get<CoreApi>().getFilesBaseUrl();

    if (entityType != null && entityType == 'task') {
      url = await locator
          .get<CoreApi>()
          .getEntityFilesUrl(entityId: folderId.toString());
      url += '?entityType=task';
    } else {
      if (folderId != null)
        url += '${folderId.toString()}?';
      else
        url += '@projects?';
    }

    if (query != null) {
      url += '&filterBy=title&filterOp=contains&filterValue=$query';
    }

    if (startIndex != null) {
      url += '&Count=25&StartIndex=$startIndex';
    }

    if (typeFilter != null) {
      url += typeFilter;
    }
    if (authorFilter != null) {
      url += authorFilter;
    }

    if (sortBy != null &&
        sortBy.isNotEmpty &&
        sortOrder != null &&
        sortOrder.isNotEmpty) url += '&sortBy=$sortBy&sortOrder=$sortOrder';

    var result = ApiDTO<FoldersResponse>();

    try {
      var response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        if (entityType != null && entityType == 'task') {
          var taskFiles = (responseJson['response'] as List)
              .map((i) => PortalFile.fromJson(i))
              .toList();

          result.response = FoldersResponse();
          result.response!.files = taskFiles;
        } else
          result.response = FoldersResponse.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<Folder>> renameFolder(
      {String? folderId, String? newTitle}) async {
    var url = await locator.get<CoreApi>().getFolderByIdUrl(folderId: folderId);
    var body = {'title': newTitle};

    var result = ApiDTO<Folder>();

    try {
      var response = await locator.get<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = Folder.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalFile>> renameFile(
      {String? fileId, String? newTitle}) async {
    var url = await locator.get<CoreApi>().getFileByIdUrl(fileId: fileId);
    var body = {'title': newTitle};

    var result = ApiDTO<PortalFile>();

    try {
      var response = await locator.get<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = PortalFile.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> deleteFolder({String? folderId}) async {
    var url = await locator.get<CoreApi>().getFolderByIdUrl(folderId: folderId);
    var result = ApiDTO();

    try {
      var response = await locator.get<CoreApi>().deleteRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = responseJson['response'];
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> deleteFile({String? fileId}) async {
    var url = await locator.get<CoreApi>().getFileByIdUrl(fileId: fileId);
    var result = ApiDTO();

    try {
      var response = await locator.get<CoreApi>().deleteRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = responseJson['response'];
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<MoveFolderResponse>> moveDocument({
    String? movingFolder,
    String? targetFolder,
    String? movingFile,
  }) async {
    var url = await locator.get<CoreApi>().getMoveOpsUrl();

    var folderIds = [];
    if (movingFolder != null) folderIds.add(movingFolder.toString());
    var fileIds = [];
    if (movingFile != null) fileIds.add(movingFile.toString());

    var body = {
      'destFolderId': targetFolder,
      'folderIds': folderIds,
      'fileIds': fileIds,
      'conflictResolveType': 'skip',
      'deleteAfter': true
    };

    var result = ApiDTO<MoveFolderResponse>();

    try {
      var response = await locator.get<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response =
            MoveFolderResponse.fromJson(responseJson['response'][0]);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<MoveFolderResponse>> copyDocument({
    String? copyingFolder,
    String? targetFolder,
    String? copyingFile,
  }) async {
    var url = await locator.get<CoreApi>().getCopyOpsUrl();

    var folderIds = [];
    if (copyingFolder != null) folderIds.add(copyingFolder.toString());
    var fileIds = [];
    if (copyingFile != null) fileIds.add(copyingFile.toString());

    var body = {
      'destFolderId': targetFolder,
      'folderIds': folderIds,
      'fileIds': fileIds,
      'conflictResolveType': 'skip',
      'deleteAfter': true
    };

    var result = ApiDTO<MoveFolderResponse>();

    try {
      var response = await locator.get<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response =
            MoveFolderResponse.fromJson(responseJson['response'][0]);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
