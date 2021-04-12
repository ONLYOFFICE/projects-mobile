import 'package:projects/data/api/comments_api.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class CommentsService {
  final CommentsApi _api = locator<CommentsApi>();

  Future getTaskComments({int taskId}) async {
    var files = await _api.getTaskComments(taskId: taskId);
    var success = files.response != null;

    if (success) {
      return files.response;
    } else {
      ErrorDialog.show(files.error);
      return null;
    }
  }
}
