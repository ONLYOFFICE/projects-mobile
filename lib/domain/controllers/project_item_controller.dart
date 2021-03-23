import 'dart:convert';

import 'package:get/get.dart';
import 'package:projects/data/models/item.dart';
import 'package:projects/domain/controllers/statuses_controller.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectItemController extends GetxController {
  // List<Status> statuses.obs;

  final statuses = [].obs;

  ProjectItemController(Item project) {
    this.project = project;
    var statusesController = Get.find<StatusesController>();

    String status;
    statusesController.getStatuses().then(
          (value) => {
            status = (value.firstWhere(
                (element) => element.statusType == project.status)).image,
            statusImageString = decodeImageString(status).obs,
          },
        );
  }

  void handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) {
      update();
    }
  }

  var project;

  RxString statusImageString = ''.obs;

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }
}
