import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/folder.dart';
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
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => PortalFile.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<List<PortalFile>>> getProjectFiles({String projectId}) async {
    var url = await coreApi.getProjectFilesUrl(projectId: projectId);

    var result = ApiDTO<List<PortalFile>>();

    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response']['files'] as List)
            .map((i) => PortalFile.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<FoldersResponse>> getFilesByParams(
      {int startIndex,
      String query,
      String sortBy,
      String sortOrder,
      int folderId,
      String typeFilter,
      String authorFilter}) async {
    var url = await coreApi.getFilesBaseUrl();

    if (folderId != null)
      url += '${folderId.toString()}?';
    else
      url += '@projects?';

    if (query != null) {
      url += 'filterBy=title&filterOp=contains&filterValue=$query';
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
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = FoldersResponse.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<Folder>> renameFolder(
      {String folderId, String newTitle}) async {
    var url = await coreApi.getFolderByIdUrl(folderId: folderId);
    var body = {'title': newTitle};

    var result = ApiDTO<Folder>();

    try {
      var response = await coreApi.putRequest(url, body: body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = Folder.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalFile>> renameFile(
      {String fileId, String newTitle}) async {
    //  PUT api/2.0/files/file/{fileId}
    var url = await coreApi.getFileByIdUrl(fileId: fileId);
    var body = {'title': newTitle};

    var result = ApiDTO<PortalFile>();

    try {
      var response = await coreApi.putRequest(url, body: body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = PortalFile.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
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
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = responseJson['response'];
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
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
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = responseJson['response'];
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
