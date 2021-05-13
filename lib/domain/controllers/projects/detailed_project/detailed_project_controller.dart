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
  var loaded = true.obs;

  final statuses = [].obs;

  var projectTitleText = ''.obs;
  var descriptionText = ''.obs;
  var managerText = ''.obs;
  var teamMembers = [].obs;
  var teamMembersCount = 0.obs;

  var creationDateText = ''.obs;
  var tags = [].obs;
  var statusText = ''.obs;
  var tasksCount = ''.obs;
  var docsCount = (-1).obs;
  var tagsText = ''.obs;

  var currentTab = -1.obs;

  ProjectDetailsController(this.projectDetailed);

  ProjectDetailed projectDetailed;

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }

  Future<void> setup() async {
    // loaded.value = false;
    // var project = await _api.getProjectById(projectId: projectDetailed.id);

    // if (project != null) projectDetailed = project;
    // if (project.tags != null) {
    //   tags.addAll(project.tags);
    //   tagsText.value = projectDetailed.tags.join(', ');
    // }

    // docsCount.value = docs.length;

    // await _docApi
    //     .getProjectFiles(projectId: projectDetailed.id.toString())
    //     .then((value) => {
    //           docsCount.value = value.length,
    //         });

    // if (teamMembers.isEmpty) {
    //   var team = await _api.getProjectTeam(projectDetailed.id.toString());
    //   teamMembers.addAll(team);
    // }

    teamMembersCount.value = projectDetailed.participantCount;
    statusText.value =
        'Project ${ProjectStatus.toName(projectDetailed.status)}';

    projectTitleText.value = projectDetailed.title;
    descriptionText.value = projectDetailed.description;
    managerText.value = projectDetailed.responsible.displayName;

    final formatter = DateFormat('dd MMM yyyy');
    creationDateText.value =
        formatter.format(DateTime.parse(projectDetailed.created));

    await _api.getProjectById(projectId: projectDetailed.id).then((value) => {
          if (value.tags != null)
            {
              tags.addAll(value.tags),
              tagsText.value = value.tags.join(', '),
            }
        });

    tasksCount.value = projectDetailed.taskCount.toString();

    await _docApi
        .getProjectFiles(projectId: projectDetailed.id.toString())
        .then((value) => docsCount.value = value.length);
  }

  void createNewMilestone() {
    Get.toNamed('NewMilestoneView');
  }

  void createTask() {
    Get.toNamed('NewTaskView');
  }
}
