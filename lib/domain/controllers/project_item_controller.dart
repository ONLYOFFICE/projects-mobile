import 'dart:convert';

import 'package:get/get.dart';
import 'package:projects/data/models/item.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectItemController extends GetxController {
  final statuses = [].obs;

  ProjectItemController(Item project) {
    this.project = project;
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

  String get statusName {
    switch (project.status) {
      case 0:
        return 'Open';
        break;
      case 1:
        return 'Closed';
        break;
      case 2:
        return 'Paused';
        break;
      default:
        return 'n/a';
    }
  }
}
