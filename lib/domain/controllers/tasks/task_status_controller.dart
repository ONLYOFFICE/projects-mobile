import 'dart:convert';

import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/services/task_service.dart';
import 'package:projects/internal/locator.dart';

class TaskStatusesController extends GetxController {
  final _api = locator<TaskService>();

  RxList statuses = <Status>[].obs;
  RxList statusImagesDecoded = <String>[].obs;
  RxBool loaded = false.obs;

  Future getStatuses() async {
    loaded.value = false;
    if (statuses.isEmpty) {
      statuses.value = await _api.getStatuses();
      statusImagesDecoded.clear();
      for (var element in statuses) {
        statusImagesDecoded.add(decodeImageString(element.image));
      }
    }
    loaded.value = true;
  }

  Status getTaskStatus(PortalTask task) {
    var status;

    if (task.customTaskStatus != null) {
      status = statuses.firstWhere(
        (element) => element.id == task.customTaskStatus,
        orElse: () => null,
      );
    } else {
      status = statuses.firstWhere(
        (element) => -element.id == task.status,
        orElse: () => null,
      );

      status ??= statuses.lastWhere(
        (element) => element.statusType == task.status,
        orElse: () => null,
      );
    }
    return status;
  }

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }
}
