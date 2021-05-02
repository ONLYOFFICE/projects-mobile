import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectDetailsController extends GetxController {
  final _api = locator<ProjectService>();
  final _docApi = locator<FilesService>();

  RefreshController refreshController = RefreshController();
  var loaded = false.obs;

  final statuses = [].obs;

  var projectTitleText = ''.obs;
  var descriptionText = ''.obs;
  var managerText = ''.obs;
  var teamMembers = [].obs;
  var creationDateText = ''.obs;
  var tags = [].obs;
  var statusText = ''.obs;
  var tasksCount = ''.obs;
  var docsCount = (-1).obs;
  var tagsText = ''.obs;

  ProjectDetailsController(this.projectDetailed);

  ProjectDetailed projectDetailed;

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }

  Future<void> setup() async {
    loaded.value = false;

    tasksCount.value = projectDetailed.taskCount.toString();

    var docs =
        await _docApi.getProjectFiles(projectId: projectDetailed.id.toString());
    docsCount.value = docs.length;

    if (teamMembers.isEmpty) {
      var team = await _api.getProjectTeam(projectDetailed.id.toString());
      teamMembers.addAll(team);
    }
    var tag = await _api.getProjectTags();
    tags.addAll(tag);

    statusText.value =
        'Project ${ProjectStatus.toName(projectDetailed.status)}';

    projectTitleText.value = projectDetailed.title;
    descriptionText.value = projectDetailed.description;
    managerText.value = projectDetailed.responsible.displayName;

    final formatter = DateFormat('dd MMM yyyy');
    creationDateText.value =
        formatter.format(DateTime.parse(projectDetailed.created));

    loaded.value = true;
  }
}
