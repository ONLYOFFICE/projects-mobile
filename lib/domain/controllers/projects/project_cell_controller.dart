import 'dart:convert';

import 'package:get/get.dart';
import 'package:projects/data/models/item.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectCellController extends GetxController {
  final statuses = [].obs;

  ProjectCellController(Item project) {
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

  String get statusImage {
    switch (project.status) {
      case 0:
        return SvgIcons.open;
        break;
      case 1:
        return SvgIcons.closed;
        break;
      case 2:
        return SvgIcons.paused;
        break;
      default:
        return 'n/a';
    }
  }
}
