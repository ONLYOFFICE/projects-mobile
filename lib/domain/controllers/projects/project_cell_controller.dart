import 'dart:convert';

import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectCellController extends GetxController {
  final _projectService = locator<ProjectService>();

  RefreshController refreshController = RefreshController();

  ProjectCellController(ProjectDetailed project) {
    _project = project;
    isPrivate.value = project.isPrivate;
    status.value = project.status;
    canEdit.value = project.canEdit;
  }

  var _project;

  ProjectDetailed get projectData => _project;

  var isPrivate = false.obs;
  var canEdit = false.obs;
  var status = (-1).obs;

  RxString statusImageString = ''.obs;

  String get statusImage => ProjectStatus.toImageString(_project.status);

  String get statusName => ProjectStatus.toName(_project.status);

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }

  Future updateStatus({int newStatusId}) async {
    var t = await _projectService.updateProjectStatus(
        projectId: projectData.id,
        newStatus: ProjectStatus.toName(newStatusId));

    if (t != null) {
      _project.status = t.status;
    }
  }
}
