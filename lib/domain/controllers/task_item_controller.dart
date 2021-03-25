import 'dart:convert';

import 'package:get/get.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/controllers/statuses_controller.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TaskItemController extends GetxController {

  PortalTask task;
  final statuses = [];
  var status = Status().obs;

  TaskItemController(PortalTask task) {
    this.task = task;
    var statusesController = Get.find<StatusesController>();
    
    statusesController.getStatuses().then(
      (value) => {
        status.value = (value.firstWhere(
            (element) => element.statusType == task.status)),
        statusImageString = decodeImageString(status.value.image).obs,
      },
    );
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
