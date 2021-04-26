import 'dart:convert';

import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectCellController extends GetxController {
  final statuses = [].obs;

  RefreshController refreshController = RefreshController();

  ProjectCellController(ProjectDetailed project) {
    _project = project;
  }

  var _project;

  dynamic get projectData => _project;

  RxString statusImageString = ''.obs;

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }

  String get statusName {
    switch (_project.status) {
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
    switch (_project.status) {
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
