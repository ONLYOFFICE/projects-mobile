import 'package:get/get.dart';
import 'package:projects/data/api/comments_api.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class CommentsService {
  final CommentsApi _api = locator<CommentsApi>();
  final SecureStorage _secureStorage = locator<SecureStorage>();

  Future getTaskComments({int taskId}) async {
    var files = await _api.getTaskComments(taskId: taskId);
    var success = files.response != null;

    if (success) {
      return files.response;
    } else {
      await Get.find<ErrorDialog>().show(files.error.message);
      return null;
    }
  }

  Future addTaskReplyComment({
    int taskId,
    String content,
    String parentId,
  }) async {
    var result = await _api.addTaskReplyComment(
      taskId: taskId,
      content: content,
      parentId: parentId,
    );
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error.message);
      return null;
    }
  }

  Future addMessageReplyComment({
    int messageId,
    String content,
    String parentId,
  }) async {
    var result = await _api.addMessageReplyComment(
      content: content,
      messageId: messageId,
      parentId: parentId,
    );
    var success = result.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.createEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.reply
      });
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error.message);
      return null;
    }
  }

  Future addTaskComment({int taskId, String content}) async {
    var result = await _api.addTaskComment(taskId: taskId, content: content);
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error.message);
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
      await Get.find<ErrorDialog>().show(result.error.message);
      return null;
    }
  }

  Future deleteComment({String commentId}) async {
    var task = await _api.deleteComment(commentId: commentId);
    var success = task.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.deleteEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.reply
      });
      return task.response;
    } else {
      await Get.find<ErrorDialog>().show(task.error.message);
      return null;
    }
  }

  Future<String> getDiscussionCommentLink({
    discussionId,
    projectId,
    commentId,
  }) async {
    return await _api.getDiscussionCommentLink(
      discussionId: discussionId,
      projectId: projectId,
      commentId: commentId,
    );
  }

  Future<String> getTaskCommentLink({taskId, projectId, commentId}) async {
    return await _api.getTaskCommentLink(
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
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.reply
      });
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error.message);
      return null;
    }
  }
}
