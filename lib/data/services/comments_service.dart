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
      await ErrorDialog.show(files.error);
      return null;
    }
  }

  Future addReplyComment({int taskId, String parentId, String content}) async {
    var result = await _api.addReplyComment(
      taskId: taskId,
      content: content,
      parentId: parentId,
    );
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }

  Future addTaskComment({int taskId, String content}) async {
    var result = await _api.addTaskComment(taskId: taskId, content: content);
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }

  Future addMessageComment({int messageId, String content}) async {
    var result =
        await _api.addMessageComment(messageId: messageId, content: content);
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      ErrorDialog.show(result.error);
      return null;
    }
  }

  Future deleteComment({String commentId}) async {
    var task = await _api.deleteComment(commentId: commentId);
    var success = task.response != null;

    if (success) {
      return task.response;
    } else {
      await ErrorDialog.show(task.error);
      return null;
    }
  }

  Future<String> getCommentLink({taskId, projectId, commentId}) async {
    return await _api.getCommentLink(
      taskId: taskId,
      projectId: projectId,
      commentId: commentId,
    );
  }

  Future updateComment({String commentId, String content}) async {
    var result =
        await _api.updateComment(commentId: commentId, content: content);
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await ErrorDialog.show(result.error);
      return null;
    }
  }
}
