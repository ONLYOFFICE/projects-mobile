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

  Future<FoldersResponse> getFilesByParams({
    int startIndex,
    String query,
    String sortBy,
    String sortOrder,
    int folderId,
    String typeFilter,
    String authorFilter,
    String entityType,
  }) async {
    var files = await _api.getFilesByParams(
      startIndex: startIndex,
      query: query,
      sortBy: sortBy,
      sortOrder: sortOrder,
      folderId: folderId,
      typeFilter: typeFilter,
      authorFilter: authorFilter,
      entityType: entityType,
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

  Future moveDocument(
      {String movingFolder, String movingFile, String targetFolder}) async {
    var result = await _api.moveDocument(
        movingFolder: movingFolder,
        targetFolder: targetFolder,
        movingFile: movingFile);

    var success = result.response.error == null;

    if (success) {
      return result.response;
    } else {
      ErrorDialog.show(result.error);
      return null;
    }
  }

  Future copyDocument(
      {String copyingFolder, String copyingFile, String targetFolder}) async {
    var result = await _api.copyDocument(
      copyingFolder: copyingFolder,
      targetFolder: targetFolder,
      copyingFile: copyingFile,
    );

    var success = result.response.error == null;

    if (success) {
      return result.response;
    } else {
      ErrorDialog.show(result.error);
      return null;
    }
  }
}
