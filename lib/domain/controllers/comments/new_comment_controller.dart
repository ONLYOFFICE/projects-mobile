import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled_snackbar.dart';

class NewCommentController extends GetxController {
  final _api = locator<CommentsService>();
  final int taskId;
  final String parentId;

  NewCommentController({
    this.parentId,
    this.taskId,
  });

  RxBool setTitleError = false.obs;

  final TextEditingController _textController = TextEditingController();

  TextEditingController get textController => _textController;

  Future addTaskComment(context) async {
    if (_textController.text.isEmpty)
      setTitleError.value = true;
    else {
      setTitleError.value = false;
      PortalComment newComment = await _api.addTaskComment(
          content: _textController.text, taskId: taskId);
      if (newComment != null) {
        var taskController =
            Get.find<TaskItemController>(tag: taskId.toString());
        // ignore: unawaited_futures
        taskController.reloadTask(showLoading: true);
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
            context: context,
            text: 'Comment had been created',
            buttonText: ''));
      }
    }
  }

  Future addReplyComment(context) async {
    if (_textController.text.isEmpty)
      setTitleError.value = true;
    else {
      setTitleError.value = false;
      PortalComment newComment = await _api.addReplyComment(
        content: _textController.text,
        taskId: taskId,
        parentId: parentId,
      );
      if (newComment != null) {
        var taskController =
            Get.find<TaskItemController>(tag: taskId.toString());
        // ignore: unawaited_futures
        taskController.reloadTask(showLoading: true);
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
            context: context,
            text: 'Comment had been created',
            buttonText: ''));
      }
    }
  }
}
