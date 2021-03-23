import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/item.dart';
import 'package:projects/domain/controllers/statuses_controller.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectItemController extends GetxController {
  // List<Status> statuses.obs;

  final statuses = [].obs;

  ProjectItemController(Item project) {
    this.project = project;
    StatusesController statusesController = Get.find();

    String decoded;
    String status;
    statusesController.getStatuses().then(
          (value) => {
            status = (value.firstWhere(
                (element) => element.statusType == project.status)).image,
            decoded = decodeImageString(status),
            setS(decoded),
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

  setS(String o) {
    statusImageString = o.obs;
    statusImageString.update(
      (val) {
        val = o;
      },
    );
    update();
  }
}
