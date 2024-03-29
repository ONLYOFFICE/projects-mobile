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
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/error.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/operation.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/internal/locator.dart';

enum ConflictResolveType { Skip, Overwrite, Duplicate }

class FilesApi {
  Future<ApiDTO<List<PortalFile>>> getTaskFiles({required int taskId}) async {
    final url = await locator.get<CoreApi>().getTaskFilesUrl(taskId: taskId);

    final result = ApiDTO<List<PortalFile>>();

    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => PortalFile.fromJson(i as Map<String, dynamic>))
            .toList();
      } else {
        result.error = response as CustomError;
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
          // TODO: delete force unwrap folderId
          .getEntityFilesUrl(entityId: folderId!);
      url += '?entityType=task';
    } else {
      if (folderId != null) {
        url += '${folderId.toString()}?';
      } else {
        url += '@projects?';
      }
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

    if (sortBy != null && sortBy.isNotEmpty && sortOrder != null && sortOrder.isNotEmpty)
      url += '&sortBy=$sortBy&sortOrder=$sortOrder';

    final result = ApiDTO<FoldersResponse>();

    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        if (entityType != null && entityType == 'task') {
          final taskFiles = (responseJson['response'] as List)
              .map((i) => PortalFile.fromJson(i as Map<String, dynamic>))
              .toList();

          result.response = FoldersResponse();
          result.response!.files = taskFiles;
        } else {
          result.response =
              FoldersResponse.fromJson(responseJson['response'] as Map<String, dynamic>);
        }
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<Folder>> renameFolder({required String folderId, required String newTitle}) async {
    final url = await locator.get<CoreApi>().getFolderByIdUrl(folderId);
    final body = {'title': newTitle};

    final result = ApiDTO<Folder>();

    try {
      final response = await locator.get<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = Folder.fromJson(responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalFile>> renameFile({required String fileId, required String newTitle}) async {
    final url = await locator.get<CoreApi>().getFileByIdUrl(fileId);
    final body = {'title': newTitle};

    final result = ApiDTO<PortalFile>();

    try {
      final response = await locator.get<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = PortalFile.fromJson(responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<Operation>>> deleteFolder({required String folderId}) async {
    final url = await locator.get<CoreApi>().getFolderByIdUrl(folderId);
    final result = ApiDTO<List<Operation>>();

    try {
      final response = await locator.get<CoreApi>().deleteRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .cast<Map<String, dynamic>>()
            .map(Operation.fromJson)
            .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<Operation>>> deleteFile({required String fileId}) async {
    final url = await locator.get<CoreApi>().getFileByIdUrl(fileId);

    final result = ApiDTO<List<Operation>>();

    try {
      final response = await locator.get<CoreApi>().deleteRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .cast<Map<String, dynamic>>()
            .map(Operation.fromJson)
            .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<Operation>>> moveDocument({
    required String destFolderId,
    required ConflictResolveType type,
    List<String>? folderIds,
    List<String>? fileIds,
  }) async {
    final url = await locator.get<CoreApi>().getMoveOpsUrl();

    final body = <String, String>{};
    body.addAll({'destFolderId': destFolderId});
    if (folderIds?.isNotEmpty == true) body.addAll({'folderIds': folderIds!.join(',')});
    if (fileIds?.isNotEmpty == true) body.addAll({'fileIds': fileIds!.join(',')});
    body.addAll({'conflictResolveType': type.name});

    final result = ApiDTO<List<Operation>>();

    try {
      final response = await locator.get<CoreApi>().putFormDataRequest(url, body: body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .cast<Map<String, dynamic>>()
            .map(Operation.fromJson)
            .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<Operation>>> copyDocument({
    required String destFolderId,
    required ConflictResolveType type,
    List<String>? folderIds,
    List<String>? fileIds,
  }) async {
    final url = await locator.get<CoreApi>().getCopyOpsUrl();

    final body = <String, String>{};
    body.addAll({'destFolderId': destFolderId});
    if (folderIds?.isNotEmpty == true) body.addAll({'folderIds': folderIds!.join(',')});
    if (fileIds?.isNotEmpty == true) body.addAll({'fileIds': fileIds!.join(',')});
    body.addAll({'conflictResolveType': type.name});

    final result = ApiDTO<List<Operation>>();

    try {
      final response = await locator.get<CoreApi>().putFormDataRequest(url, body: body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .cast<Map<String, dynamic>>()
            .map(Operation.fromJson)
            .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<PortalFile>>> checkForConflicts({
    required String destFolderId,
    List<String>? folderIds,
    List<String>? fileIds,
  }) async {
    var url = await locator.get<CoreApi>().getMoveOpsUrl();

    final result = ApiDTO<List<PortalFile>>();

    url += '?destFolderId=$destFolderId';
    if (folderIds != null) url += '&folderIds=${folderIds.join(',')}';
    if (fileIds != null) url += '&fileIds=${fileIds.join(',')}';

    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .cast<Map<String, dynamic>>()
            .map(PortalFile.fromJson)
            .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<Operation>>> getActiveOperations() async {
    final url = await locator.get<CoreApi>().getFileOperationsUrl();

    final result = ApiDTO<List<Operation>>();

    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .cast<Map<String, dynamic>>()
            .map(Operation.fromJson)
            .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
