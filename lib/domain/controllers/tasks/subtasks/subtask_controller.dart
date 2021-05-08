import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/services/subtasks_service.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/locator.dart';

class SubtaskController extends GetxController {
  final SubtasksService _api = locator<SubtasksService>();
  Rx<Subtask> subtask;

  SubtaskController({Subtask subtask}) {
    this.subtask = subtask.obs;
  }

  void deleteSubtask({@required int taskId, @required int subtaskId}) async {
    var result = await _api.deleteSubtask(taskId: taskId, subtaskId: subtaskId);
    if (result != null) {
      var taskItemController =
          Get.find<TaskItemController>(tag: taskId.toString());
      await taskItemController.reloadTask();
    }
  }
}
