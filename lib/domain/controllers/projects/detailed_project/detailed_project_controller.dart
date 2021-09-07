import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_members_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectDetailsController extends BaseProjectEditorController {
  final _projectService = locator<ProjectService>();
  final _docApi = locator<FilesService>();

  RefreshController refreshController = RefreshController();
  var loaded = true.obs;

  final statuses = [].obs;

  var projectTitleText = ''.obs;

  var managerText = ''.obs;
  var teamMembers = [].obs;
  var teamMembersCount = 0.obs;

  var creationDateText = ''.obs;

  var statusText = ''.obs;
  var tasksCount = 0.obs;
  var docsCount = (-1).obs;

  var milestoneCount = (-1).obs;
  var currentTab = -1.obs;

  ProjectDetailsController(this.projectDetailed);

  ProjectDetailed projectDetailed;
  ProjectDetailed get projectData => projectDetailed;

  // PortalUserItemController selfUserItem;
  final _userController = Get.find<UserController>();

  @override
  void onInit() {
    _userController.getUserInfo().whenComplete(() => {
          selfUserItem =
              PortalUserItemController(portalUser: _userController.user),
        });

    locator<EventHub>().on('needToRefreshProjects', (dynamic data) {
      refreshData();
    });
    super.onInit();
  }

  String decodeImageString(String image) {
    return utf8.decode(base64.decode(image));
  }

  Future<void> setup() async {
    await setupDetailedParams();

    final formatter = DateFormat.yMMMMd(Get.locale.languageCode);

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

    tasksCount.value = projectDetailed.taskCountTotal;

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

  Future<void> setupDetailedParams() async {
    teamMembersCount.value = projectDetailed.participantCount;

    var tream = Get.find<ProjectTeamController>();

    tream.projectId = projectDetailed.id;
    var usersList = await tream.getTeam().then((value) => tream.usersList);

    teamMembers.clear();
    teamMembers.addAll(usersList);
    teamMembers.removeWhere(
        (element) => element.portalUser.id == projectDetailed.responsible.id);

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

  Future manageTeamMembers() async {
    selectedProjectManager.value = projectData.responsible;

    selectedTeamMembers.clear();

    for (var user in teamMembers) {
      selectedTeamMembers.add(user);
    }
    Get.find<NavigationController>()
        .to(const TeamMembersSelectionView(), arguments: {'controller': this});
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

  @override
  Future<void> confirmTeamMembers() async {
    Get.find<UsersDataSource>().loaded.value = false;
    var users = <String>[];

    for (var user in selectedTeamMembers) {
      users.add(user.id);
    }

    await _projectService.addToProjectTeam(projectData.id.toString(), users);
    await refreshData();
    Get.find<UsersDataSource>().loaded.value = true;

    Get.back();
  }
}
