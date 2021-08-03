import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';
import 'package:projects/presentation/views/project_detailed/milestones/new_milestone.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectDetailsController extends GetxController {
  final _projectService = locator<ProjectService>();
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
  var milestoneCount = (-1).obs;
  var currentTab = -1.obs;

  ProjectDetailsController(this.projectDetailed);

  ProjectDetailed projectDetailed;
  ProjectDetailed get projectData => projectDetailed;

  PortalUserItemController selfUserItem;
  final _userController = Get.find<UserController>();

  @override
  void onInit() {
    _userController.getUserInfo().whenComplete(() => {
          selfUserItem =
              PortalUserItemController(portalUser: _userController.user),
        });

    super.onInit();
  }

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }

  Future<void> setup() async {
    setupDetailedParams();

    final formatter = DateFormat.yMMMd(Get.locale.languageCode);

    creationDateText.value =
        formatter.format(DateTime.parse(projectDetailed.created));

    await _projectService
        .getProjectById(projectId: projectDetailed.id)
        .then((value) => {
              projectDetailed = value,
              setupDetailedParams(),
              if (value?.tags != null)
                {
                  tags.addAll(value.tags),
                  tagsText.value = value.tags.join(', '),
                }
            });

    tasksCount.value = projectDetailed.taskCount.toString();

    await _docApi
        .getFilesByParams(folderId: projectDetailed.projectFolder)
        .then((value) => docsCount.value = value.files.length);

    await locator<MilestoneService>()
        .milestonesByFilter(
          projectId: projectDetailed.id.toString(),
        )
        .then((value) => {
              if (value != null) {milestoneCount.value = value.length}
            });
  }

  void setupDetailedParams() {
    teamMembersCount.value = projectDetailed.participantCount;
    statusText.value = tr('projectStatus',
        args: [ProjectStatus.toName(projectDetailed.status)]);

    projectTitleText.value = projectDetailed.title;
    descriptionText.value = projectDetailed.description;
    managerText.value = projectDetailed.responsible.displayName;

    milestoneCount.value = projectDetailed.milestoneCount;
  }

  Future<void> refreshData() async {
    loaded.value = false;
    projectDetailed =
        await _projectService.getProjectById(projectId: projectDetailed.id);
    loaded.value = true;

    await setup();
  }

  void createNewMilestone() {
    Get.find<NavigationController>().navigateToFullscreen(
        const NewMilestoneView(),
        arguments: {'projectDetailed': projectDetailed});

    // Get.find<NavigationController>().navigateToFullscreen(const NewMilestoneView',
    //     arguments: {'projectDetailed': projectDetailed});
  }

  void createTask() {
    Get.find<NavigationController>().navigateToFullscreen(const NewTaskView(),
        arguments: {'projectDetailed': projectDetailed});
  }

  Future<void> copyLink() async {}

  Future deleteProject() async {
    return await _projectService.deleteProject(projectId: projectDetailed.id);
  }

  Future updateStatus({int newStatusId}) async {
    var t = await _projectService.updateProjectStatus(
        projectId: projectDetailed.id,
        newStatus: ProjectStatus.toLiteral(newStatusId));

    if (t != null) {
      projectDetailed.status = t.status;
    }
  }

  Future followProject() async {
    await _projectService.followProject(projectId: projectDetailed.id);
    await refreshData();
  }
}
