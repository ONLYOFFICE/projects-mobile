import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/domain/controllers/comments/new_comment/abstract_new_comment.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled_snackbar.dart';

class NewTaskCommentController extends GetxController
    implements NewCommentController {
  final _api = locator<CommentsService>();

  @override
  final int idFrom;
  final String parentId;

  NewTaskCommentController({
    this.parentId,
    this.idFrom,
  });

  @override
  RxBool setTitleError = false.obs;

  final TextEditingController _textController = TextEditingController();

  @override
  TextEditingController get textController => _textController;

  @override
  Future addComment(context) async {
    if (_textController.text.isEmpty)
      setTitleError.value = true;
    else {
      setTitleError.value = false;
      PortalComment newComment = await _api.addTaskComment(
          content: _textController.text, taskId: idFrom);
      if (newComment != null) {
        _textController.clear();
        var taskController =
            Get.find<TaskItemController>(tag: idFrom.toString());
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

  @override
  Future addReplyComment(context) async {
    if (_textController.text.isEmpty)
      setTitleError.value = true;
    else {
      setTitleError.value = false;
      PortalComment newComment = await _api.addTaskReplyComment(
        content: _textController.text,
        taskId: idFrom,
        parentId: parentId,
      );
      if (newComment != null) {
        _textController.clear();
        var taskController =
            Get.find<TaskItemController>(tag: idFrom.toString());
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

  @override
  void leavePage() {
    if (_textController.text.isNotEmpty) {
      Get.dialog(StyledAlertDialog(
        titleText: 'Discard changes?',
        contentText: 'If you leave, all changes will be lost.',
        acceptText: 'DELETE',
        onAcceptTap: () {
          _textController.clear();
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    } else {
      Get.back();
    }
  }
}
