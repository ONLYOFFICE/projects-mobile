import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/move_folder_response.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class FilesApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<List<PortalFile>>> getTaskFiles({int taskId}) async {
    var url = await coreApi.getTaskFiles(taskId: taskId);

    var result = ApiDTO<List<PortalFile>>();

    try {
      var response = await coreApi.getRequest(url);

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => PortalFile.fromJson(i))
            .toList();
      } else {
        result.error = CustomError(message: response.reasonPhrase);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<FoldersResponse>> getFilesByParams({
    int startIndex,
    String query,
    String sortBy,
    String sortOrder,
    int folderId,
    String typeFilter,
    String authorFilter,
    String entityType,
  }) async {
    var url = await coreApi.getFilesBaseUrl();

    if (entityType != null && entityType == 'task') {
      url = await coreApi.getEntityFilesUrl(entityId: folderId.toString());
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
      var response = await coreApi.getRequest(url);

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        if (entityType != null && entityType == 'task') {
          var taskFiles = (responseJson['response'] as List)
              .map((i) => PortalFile.fromJson(i))
              .toList();

          result.response = FoldersResponse();
          result.response.files = taskFiles;
        } else
          result.response = FoldersResponse.fromJson(responseJson['response']);
      } else {
        result.error = CustomError(message: response.reasonPhrase);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  //  Future<ApiDTO<FoldersResponse>> getMessageFiles({
  //   int startIndex,
  //   String query,
  //   String sortBy,
  //   String sortOrder,
  //   int folderId,
  //   String typeFilter,
  //   String authorFilter,
  //   String entityType,
  // }) async {
  //    // project/message/1234/files
  //   var url = await coreApi.getFilesBaseUrl();

  //   if (entityType != null && entityType == 'task') {
  //     url = await coreApi.getEntityFilesUrl(entityId: folderId.toString());
  //     url += '?entityType=task';
  //   } else {
  //     if (folderId != null)
  //       url += '${folderId.toString()}?';
  //     else
  //       url += '@projects?';
  //   }

  //   if (query != null) {
  //     url += '&filterBy=title&filterOp=contains&filterValue=$query';
  //   }

  //   if (startIndex != null) {
  //     url += '&Count=25&StartIndex=$startIndex';
  //   }

  //   if (typeFilter != null) {
  //     url += typeFilter;
  //   }
  //   if (authorFilter != null) {
  //     url += authorFilter;
  //   }

  //   if (sortBy != null &&
  //       sortBy.isNotEmpty &&
  //       sortOrder != null &&
  //       sortOrder.isNotEmpty) url += '&sortBy=$sortBy&sortOrder=$sortOrder';

  //   var result = ApiDTO<FoldersResponse>();

  //   try {
  //     var response = await coreApi.getRequest(url);
  //     final Map responseJson = json.decode(response.body);

  //     if (response.statusCode == 200) {
  //       if (entityType != null && entityType == 'task') {
  //         var taskFiles = (responseJson['response'] as List)
  //             .map((i) => PortalFile.fromJson(i))
  //             .toList();

  //         result.response = FoldersResponse();
  //         result.response.files = taskFiles;
  //       } else
  //         result.response = FoldersResponse.fromJson(responseJson['response']);
  //     } else {
  //       result.error = CustomError(message: response.reasonPhrase);
  //     }
  //   } catch (e) {
  //     result.error = CustomError(message: e.toString());
  //   }

  //   return result;
  // }

  Future<ApiDTO<Folder>> renameFolder(
      {String folderId, String newTitle}) async {
    var url = await coreApi.getFolderByIdUrl(folderId: folderId);
    var body = {'title': newTitle};

    var result = ApiDTO<Folder>();

    try {
      var response = await coreApi.putRequest(url, body: body);

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        result.response = Folder.fromJson(responseJson['response']);
      } else {
        result.error = CustomError(message: response.reasonPhrase);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalFile>> renameFile(
      {String fileId, String newTitle}) async {
    var url = await coreApi.getFileByIdUrl(fileId: fileId);
    var body = {'title': newTitle};

    var result = ApiDTO<PortalFile>();

    try {
      var response = await coreApi.putRequest(url, body: body);

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        result.response = PortalFile.fromJson(responseJson['response']);
      } else {
        result.error = CustomError(message: response.reasonPhrase);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> deleteFolder({String folderId}) async {
    var url = await coreApi.getFolderByIdUrl(folderId: folderId);
    var result = ApiDTO();

    try {
      var response = await coreApi.deleteRequest(url);

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        result.response = responseJson['response'];
      } else {
        result.error = CustomError(message: response.reasonPhrase);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> deleteFile({String fileId}) async {
    var url = await coreApi.getFileByIdUrl(fileId: fileId);
    var result = ApiDTO();

    try {
      var response = await coreApi.deleteRequest(url);

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        result.response = responseJson['response'];
      } else {
        result.error = CustomError(message: response.reasonPhrase);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<MoveFolderResponse>> moveDocument({
    String movingFolder,
    String targetFolder,
    String movingFile,
  }) async {
    var url = await coreApi.getMoveOpsUrl();

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
      var response = await coreApi.putRequest(url, body: body);

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        result.response =
            MoveFolderResponse.fromJson(responseJson['response'][0]);
      } else {
        result.error = CustomError(message: response.reasonPhrase);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<MoveFolderResponse>> copyDocument({
    String copyingFolder,
    String targetFolder,
    String copyingFile,
  }) async {
    var url = await coreApi.getCopyOpsUrl();

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
      var response = await coreApi.putRequest(url, body: body);

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        result.response =
            MoveFolderResponse.fromJson(responseJson['response'][0]);
      } else {
        result.error = CustomError(message: response.reasonPhrase);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
