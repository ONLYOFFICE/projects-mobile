import 'dart:convert';

import 'package:get/get.dart';
import 'package:projects/data/api/tasks_api.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TaskItemController extends GetxController {
  final _api = locator<TaskItemService>();

  var task = PortalTask().obs;
  var status = Status().obs;

  var loaded = true.obs;
  var refreshController = RefreshController().obs;

  RxString statusImageString = ''.obs;

  TaskItemController(PortalTask task) {
    this.task.value = task;
    var statusesController = Get.find<TaskStatusesController>();

    var statuss;

    if (task.customTaskStatus != null) {
      statuss = statusesController.statuses
          .firstWhere((element) => element.id == task.customTaskStatus);
    } else {
      statuss = statusesController.statuses
          .firstWhere((element) => element.statusType == task.status);
    }

    statusImageString.value = decodeImageString(statuss.image);
    status.value = statuss;
  }

  Future reloadTask() async {
    loaded.value = false;
    var t = await _api.getTaskByID(id: task.value.id);
    task.value = t;
    loaded.value = true;
  }

  Future updateTaskStatus(
      {int id, int newStatusId, String newStatusType}) async {
    loaded.value = false;
    var t = await _api.updateTaskStatus(
        taskId: id, newStatusId: newStatusId, newStatusType: newStatusType);
    // task.value.customTaskStatus = t;
    loaded.value = true;
  }

  void handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) {
      update();
    }
  }

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }
}

class TaskItemService {
  final TaskApi _api = locator<TaskApi>();

  var portalTask = PortalTask().obs;

  Future getTaskByID({int id}) async {
    var task = await _api.getTaskByID(id: id);

    var success = task.response != null;

    if (success) {
      return task.response;
    } else {
      ErrorDialog.show(task.error);
      return null;
    }
  }

  Future updateTaskStatus(
      {int taskId, int newStatusId, String newStatusType}) async {
    var task = await _api.updateTaskStatus(
        taskId: taskId, newStatusId: newStatusId, newStatusType: newStatusType);

    var success = task.response != null;

    if (success) {
      return task.response;
    } else {
      ErrorDialog.show(task.error);
      return null;
    }
  }
}
