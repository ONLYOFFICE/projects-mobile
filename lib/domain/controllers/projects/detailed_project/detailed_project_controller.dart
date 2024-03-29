/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_data_source.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_discussions_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_tasks_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/project_status_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_members_view.dart';

class ProjectDetailsController extends BaseProjectEditorController {
  final _projectService = locator<ProjectService>();

  ProjectTasksController? projectTasksController;
  MilestonesDataSource? projectMilestonesController;
  ProjectDiscussionsController? projectDiscussionsController;
  DocumentsController? projectDocumentsController;
  ProjectTeamController? projectTeamDataSource;

  final loaded = false.obs;

  final projectTitleText = ''.obs;
  final managerText = ''.obs;
  final creationDateText = ''.obs;

  final taskCount = 0.obs;
  final milestoneCount = 0.obs;
  final discussionCount = 0.obs;

  @override
  ProjectDetailed get projectData => _projectDetailed.value!;
  final _projectDetailed = Rxn<ProjectDetailed>();

  StreamSubscription? _refreshProjectsSubscription;
  StreamSubscription? _taskCountSubscription;

  final _userController = Get.find<UserController>();

  ProjectDetailsController() {
    _projectDetailed.listen((details) {
      if (details == null) return;

      fillProjectInfo(details);

      taskCount.value = details.taskCount ?? 0;
      milestoneCount.value = details.milestoneCount ?? 0;
      discussionCount.value = details.discussionCount ?? 0;
    });
  }

  @override
  void onClose() {
    _refreshProjectsSubscription?.cancel();
    _taskCountSubscription?.cancel();
    super.onClose();
  }

  bool setup({ProjectDetailed? projectDetailed}) {
    if (projectDetailed != null) _projectDetailed.value = projectDetailed;

    projectTasksController = Get.find<ProjectTasksController>();
    projectMilestonesController = Get.find<MilestonesDataSource>();
    projectDiscussionsController = Get.find<ProjectDiscussionsController>();
    projectDocumentsController = Get.find<DocumentsController>();
    projectTeamDataSource = Get.find<ProjectTeamController>();

    _refreshProjectsSubscription?.cancel();
    _refreshProjectsSubscription = locator<EventHub>().on('needToRefreshProjects', (dynamic data) {
      if (data['all'] == true) {
        refreshData();
        return;
      }

      if (data['projectDetails'].id == _projectDetailed.value!.id)
        _projectDetailed.value = data['projectDetails'] as ProjectDetailed;
    });

    _userController.getUserInfo().then((res) {
      selfUserItem = PortalUserItemController(portalUser: _userController.user.value!);
    });

    refreshData(hidden: true);

    return true;
  }

  void fillProjectInfo(ProjectDetailed projectDetailed) {
    _projectDetailed.value = projectDetailed;

    statusText.value =
        tr('projectStatus', args: [ProjectStatus.toName(_projectDetailed.value!.status)]);

    projectTitleText.value = _projectDetailed.value!.title!;
    descriptionText.value = _projectDetailed.value!.description!;
    managerText.value = _projectDetailed.value!.responsible!.displayName!;

    final formatter = DateFormat.yMMMMd(Get.locale!.languageCode);
    creationDateText.value = formatter.format(DateTime.parse(_projectDetailed.value!.created!));

    if (_projectDetailed.value!.tags != null) {
      tags.addAll(_projectDetailed.value!.tags!);
      tagsText.value = _projectDetailed.value!.tags!.join(', ');
    }

    setPrivate(projectDetailed.isPrivate ?? false);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      loaded.value = true;
    });
  }

  Future<void> refreshData({bool hidden = false}) async {
    if (!hidden) loaded.value = false;

    final response = await _projectService.getProjectById(
        projectId: _projectDetailed.value!.id!); // TODO move to new method
    if (response != null) _projectDetailed.value = response;

    fillProjectInfo(_projectDetailed.value!);

    projectTasksController?.setup(_projectDetailed.value!);
    projectMilestonesController?.setup(projectDetailed: _projectDetailed.value);
    projectDiscussionsController?.setup(_projectDetailed.value!);
    unawaited(projectDocumentsController?.setupFolder(
      folderName: _projectDetailed.value!.title!,
      folderId: _projectDetailed.value!.projectFolder,
    ));
    projectTeamDataSource?.setup(projectDetailed: _projectDetailed.value);
    unawaited(projectTeamDataSource?.getTeam());

    loaded.value = true;
  }

  Future manageTeamMembers() async {
    selectedProjectManager.value = _projectDetailed.value!.responsible;

    selectedTeamMembers.clear();

    for (final user in projectTeamDataSource!.usersList) {
      selectedTeamMembers.add(user);
    }
    await Get.find<NavigationController>().toScreen(
      const TeamMembersSelectionView(),
      arguments: {'controller': this},
      page: '/TeamMembersSelectionView',
    );
  }

  Future<void> copyLink() async {}

  Future<bool> deleteProject() async {
    final responce = await _projectService.deleteProject(projectId: _projectDetailed.value!.id!);
    if (responce) await _refreshProjectsSubscription?.cancel();

    return responce;
  }

  @override
  Future<bool> updateStatus({int? newStatusId}) async {
    await refreshData(hidden: true);

    return await Get.find<ProjectStatusesController>()
        .updateStatus(newStatusId: newStatusId, projectData: _projectDetailed.value!);
  }

  @override
  Future<void> confirmTeamMembers() async {
    final users = <String>[];
    for (final user in selectedTeamMembers) {
      users.add(user.id!);
    }

    await _projectService.addToProjectTeam(_projectDetailed.value!.id!, users);
    unawaited(projectTeamDataSource!.getTeam());

    Get.back();
  }

  @override
  Future<void> showTags() {
    // TODO: implement showTags
    throw UnimplementedError();
  }
}
