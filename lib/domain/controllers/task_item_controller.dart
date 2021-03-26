import 'dart:convert';

import 'package:get/get.dart';
import 'package:projects/data/api/tasks_api.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/controllers/statuses_controller.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TaskItemController extends GetxController {
  var task = PortalTask().obs;
  final statuses = [];
  var status = Status().obs;
  final _api = locator<TaskItemService>();
  var loaded = true.obs;

  var refreshController = RefreshController().obs;

  TaskItemController(PortalTask task) {
    this.task.value = task;
    var statusesController = Get.find<StatusesController>();

    statusesController.getStatuses().then(
          (value) => {
            status.value = (value
                .firstWhere((element) => element.statusType == task.status)),
            statusImageString.value = decodeImageString(status.value.image),
          },
        );
  }

  Future updateTask() async {
    loaded.value = false;
    var t = await _api.getTaskByID(id: task.value.id);
    task.value = t;
    loaded.value = true;
  }

  void handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) {
      update();
    }
  }

  RxString statusImageString = ''.obs;

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }
}

class TaskItemService {
  final TasksApi _api = locator<TasksApi>();

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
}
