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

  Future<FoldersResponse> getFiles(
      {int startIndex,
      String query,
      String sortBy,
      String sortOrder,
      String folderId}) async {
    var files = await _api.getFiles(
        startIndex: startIndex,
        query: query,
        sortBy: sortBy,
        sortOrder: sortOrder,
        folderId: folderId);
    var success = files.response != null;

    if (success) {
      return files.response;
    } else {
      ErrorDialog.show(files.error);
      return null;
    }
  }
}
