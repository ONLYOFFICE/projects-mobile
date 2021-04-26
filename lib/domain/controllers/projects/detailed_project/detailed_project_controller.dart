import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectDetailsController extends GetxController {
  final _api = locator<ProjectService>();
  final statuses = [].obs;

  var projectTitleText = ''.obs;
  var descriptionText = ''.obs;
  var managerText = ''.obs;
  var teamMembers = [].obs;
  var creationDateText = ''.obs;
  var tags = [].obs;

  var statusText = ''.obs;
  var tasksCount = ''.obs;

  RefreshController refreshController = RefreshController();

  var loaded = false.obs;

  var tagsText = ''.obs;

  var currentTab = ''.obs;

  var tabController;

  ProjectDetailsController(ProjectDetailed project) {
    _project = project;
  }

  ProjectDetailed _project;

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }

  Future<void> setup() async {
    loaded.value = false;

    tasksCount.value = _project.taskCount.toString();

    if (teamMembers.isEmpty) {
      var team = await _api.getProjectTeam(_project.id.toString());
      teamMembers.addAll(team);
    }
    var tag = await _api.getProjectTags();
    tags.addAll(tag);

    statusText.value = 'Project ${ProjectStatus.toName(_project.status)}';

    projectTitleText.value = _project.title;
    descriptionText.value = _project.description;
    managerText.value = _project.responsible.displayName;

    final formatter = DateFormat('dd MMM yyyy');
    creationDateText.value = formatter.format(DateTime.parse(_project.created));

    loaded.value = true;
  }
}
