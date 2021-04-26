import 'dart:convert';

import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/project_status.dart';
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

  String get statusImage => ProjectStatus.toImageString(_project.status);

  String get statusName => ProjectStatus.toName(_project.status);

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }
}
