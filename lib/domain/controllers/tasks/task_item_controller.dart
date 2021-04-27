import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/services/task_item_service.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TaskItemController extends GetxController {
  final _api = locator<TaskItemService>();

  var task = PortalTask().obs;
  var status = Status().obs;

  var loaded = true.obs;
  var refreshController = RefreshController();

  RxString statusImageString = ''.obs;
  // to show overview screen without loading
  RxBool firstReload = true.obs;

  TaskItemController(PortalTask task) {
    this.task.value = task;
    initTaskStatus(task);
  }

  void initTaskStatus(PortalTask task) {
    var statusesController = Get.find<TaskStatusesController>();
    status.value = statusesController.getTaskStatus(task);
    statusImageString.value =
        statusesController.decodeImageString(status.value.image);
  }

  Future reloadTask() async {
    loaded.value = false;
    var t = await _api.getTaskByID(id: task.value.id);
    task.value = t;
    loaded.value = true;
  }

  Future updateTaskStatus({int id, int newStatusId, int newStatusType}) async {
    loaded.value = false;
    var t = await _api.updateTaskStatus(
        taskId: id, newStatusId: newStatusId, newStatusType: newStatusType);
    var newTask = PortalTask.fromJson(t);
    task.value = newTask;
    initTaskStatus(newTask);
    loaded.value = true;
  }

  Future deleteTask({@required int taskId}) async {
    var r = await _api.deleteTask(taskId: taskId);
    if (r != null) return 'ok';
  }

  Future subscribeToTask({@required int taskId}) async {
    var r = await _api.subscribeToTask(taskId: taskId);
    if (r != null) return 'ok';
  }

  void handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) {
      update();
    }
  }
}
