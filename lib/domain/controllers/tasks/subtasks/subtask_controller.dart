import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/services/task/subtasks_service.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class SubtaskController extends GetxController {
  final SubtasksService _api = locator<SubtasksService>();
  Rx<Subtask> subtask;
  PortalTask parentTask;
  final _userController = Get.find<UserController>();

  SubtaskController({Subtask subtask, this.parentTask}) {
    this.subtask = subtask.obs;
  }

  bool get canEdit => subtask.value.canEdit && parentTask.status != 2;
  bool get canCreateSubtask =>
      parentTask.canCreateSubtask && parentTask.status != 2;

  void acceptSubtask(
    context, {
    @required int taskId,
    @required int subtaskId,
  }) async {
    await _userController.getUserInfo();
    var selfUser = _userController.user;
    var data = {'responsible': selfUser.id, 'title': subtask.value.title};

    var result = await _api.acceptSubtask(
        data: data, taskId: taskId, subtaskId: subtaskId);

    if (result != null) {
      subtask.value = result;
      MessagesHandler.showSnackBar(
        context: context,
        text: tr('subtaskAccepted'),
        buttonText: tr('ok'),
        buttonOnTap: ScaffoldMessenger.maybeOf(context).hideCurrentSnackBar,
      );
    }
  }

  void copySubtask(
    context, {
    @required int taskId,
    @required int subtaskId,
  }) async {
    var result = await _api.copySubtask(taskId: taskId, subtaskId: subtaskId);
    if (result != null) {
      var taskItemController =
          Get.find<TaskItemController>(tag: taskId.toString());
      MessagesHandler.showSnackBar(context: context, text: tr('subtaskCopied'));
      await taskItemController.reloadTask();
    }
  }

  void deleteSubtask({
    @required BuildContext context,
    @required int taskId,
    @required int subtaskId,
    bool closePage = false,
  }) async {
    var result = await _api.deleteSubtask(taskId: taskId, subtaskId: subtaskId);
    if (result != null) {
      var taskItemController =
          Get.find<TaskItemController>(tag: taskId.toString());
      await taskItemController.reloadTask();
      MessagesHandler.showSnackBar(context: context, text: 'Subtask deleted');
      if (closePage) Get.back();
    }
  }

  void updateSubtaskStatus({
    @required context,
    @required int taskId,
    @required int subtaskId,
  }) async {
    if (subtask.value.canEdit) {
      var newStatus;

      if (subtask.value.status == 1)
        newStatus = 'closed';
      else
        newStatus = 'open';

      var data = {'status': newStatus};

      var result = await _api.updateSubtaskStatus(
          data: data, taskId: taskId, subtaskId: subtaskId);

      if (result != null) subtask.value = result;
    } else {
      MessagesHandler.showSnackBar(
          context: context, text: tr('cantEditSubtask'));
    }
  }

  void deleteSubtaskResponsible({
    @required int taskId,
    @required int subtaskId,
  }) async {
    if (subtask.value.canEdit) {
      var data = {'title': subtask.value.title, 'responsible': null};

      var result = await _api.updateSubtask(
        data: data,
        taskId: taskId,
        subtaskId: subtaskId,
      );

      if (result != null) subtask.value = result;
    }
  }
}
