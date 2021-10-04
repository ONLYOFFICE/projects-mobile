import 'dart:async';

import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/services/task/task_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/internal/utils/debug_print.dart';
import 'package:projects/internal/utils/image_decoder.dart';

class TaskStatusesController extends GetxController {
  final _api = locator<TaskService>();

  RxList statuses = <Status>[].obs;
  RxList statusImagesDecoded = <String>[].obs;
  RxBool loaded = false.obs;

  Future getStatuses() async {
    if (statuses.isNotEmpty) return;
    await _updateStatuses(forceReload: true);
  }

  Future _updateStatuses({bool forceReload = false}) async {
    if (forceReload || loaded.value != false) {
      loaded.value = false;
      statuses.value = await _api.getStatuses();
      statusImagesDecoded.clear();
      for (var element in statuses) {
        statusImagesDecoded.add(decodeImageString(element.image));
      }
      loaded.value = true;
    }
  }

  Future getTaskStatus(PortalTask task) async {
    if (!loaded.isFalse) {
      var status;
      status = await _findStatus(task);
      if (status == null && !loaded.isFalse) {
        printWarning('TASK ID ${task.id} STATUS DIDNT FIND');
        await _updateStatuses();
        await _findStatus(task);
      }
      return status;
    }
  }

  Future _findStatus(PortalTask task) async {
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
}
