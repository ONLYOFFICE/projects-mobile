import 'package:projects/data/api/files_api.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class FilesService {
  final FilesApi _api = locator<FilesApi>();

  Future getTaskFiles({int taskId}) async {
    var files = await _api.getTaskFiles(taskId: taskId);
    var success = files.response != null;

    if (success) {
      return files.response;
    } else {
      ErrorDialog.show(files.error);
      return null;
    }
  }

  Future<List<PortalFile>> getProjectFiles({String projectId}) async {
    var files = await _api.getProjectFiles(projectId: projectId);
    var success = files.response != null;

    if (success) {
      return files.response;
    } else {
      ErrorDialog.show(files.error);
      return null;
    }
  }

  Future<FoldersResponse> getFilesByParams({
    int startIndex,
    String query,
    String sortBy,
    String sortOrder,
    int folderId,
    String typeFilter,
    String authorFilter,
  }) async {
    var files = await _api.getFilesByParams(
      startIndex: startIndex,
      query: query,
      sortBy: sortBy,
      sortOrder: sortOrder,
      folderId: folderId,
      typeFilter: typeFilter,
      authorFilter: authorFilter,
    );
    var success = files.response != null;

    if (success) {
      return files.response;
    } else {
      ErrorDialog.show(files.error);
      return null;
    }
  }

  Future<Folder> renameFolder({String folderId, String newTitle}) async {
    var files = await _api.renameFolder(
      folderId: folderId,
      newTitle: newTitle,
    );
    var success = files.response != null;

    if (success) {
      return files.response;
    } else {
      ErrorDialog.show(files.error);
      return null;
    }
  }

  Future deleteFolder({String folderId}) async {
    var result = await _api.deleteFolder(
      folderId: folderId,
    );
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      ErrorDialog.show(result.error);
      return null;
    }
  }

  Future<PortalFile> renameFile({String fileId, String newTitle}) async {
    var files = await _api.renameFile(
      fileId: fileId,
      newTitle: newTitle,
    );
    var success = files.response != null;

    if (success) {
      return files.response;
    } else {
      ErrorDialog.show(files.error);
      return null;
    }
  }

  Future deleteFile({String fileId}) async {
    var result = await _api.deleteFile(
      fileId: fileId,
    );
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      ErrorDialog.show(result.error);
      return null;
    }
  }
}
