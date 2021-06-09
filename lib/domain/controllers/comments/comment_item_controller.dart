import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled_snackbar.dart';

class CommentItemController extends GetxController {
  final _api = locator<CommentsService>();

  final Rx<PortalComment> comment;
  final int taskId;
  CommentItemController({this.comment, this.taskId});

  Future<void> copyLink(context) async {
    var projectId = Get.find<TaskItemController>(tag: taskId.toString())
        .task
        .value
        .projectOwner
        .id;

    var link = await _api.getCommentLink(
      commentId: comment.value.commentId,
      taskId: taskId,
      projectId: projectId,
    );

    if (link != null) {
      await Clipboard.setData(ClipboardData(text: link));
      ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
          context: context, text: 'Link has been copied to the clipboard'));
    }
  }

  Future deleteComment(context) async {
    await Get.dialog(StyledAlertDialog(
      titleText: 'Delete comment',
      contentText: '''Are you sure you want to delete these comment?
Note: this action cannot be undone.''',
      acceptText: 'DELETE',
      onCancelTap: Get.back,
      onAcceptTap: () async {
        var response =
            await _api.deleteComment(commentId: comment.value.commentId);
        if (response != null) {
          Get.back();
          // ignore: unawaited_futures
          Get.find<TaskItemController>(tag: taskId.toString()).reloadTask();
          ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
              context: context,
              text: 'Comment has been deleted',
              buttonText: 'CONFIRM'));
        }
      },
    ));
  }
}