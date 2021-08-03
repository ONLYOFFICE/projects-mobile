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

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';

import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/detailed_project_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_team_datasource.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/project_detailed/tags_selection_view.dart';

class ProjectEditController extends BaseProjectEditorController {
  final _projectService = locator<ProjectService>();

  var loaded = true.obs;
  var isSearchResult = false.obs;
  var nothingFound = false.obs;

  var projectTitleText = ''.obs;

  var tags = [].obs;
  var statusText = ''.obs;

  var tagsText = ''.obs;

  var selectedTags;

  ProjectEditController(this.projectDetailed);

  ProjectDetailed projectDetailed;
  ProjectDetailed get projectData => projectDetailed;

  Future<void> setupEditor() async {
    loaded.value = false;
    statusText.value = tr('projectStatus',
        args: [ProjectStatus.toName(projectDetailed.status)]);

    projectTitleText.value = projectDetailed.title;
    descriptionText.value = projectDetailed.description;

    isPrivate.value = projectDetailed.isPrivate;

    var projectById =
        await _projectService.getProjectById(projectId: projectDetailed.id);
    tags.clear();
    if (projectById?.tags != null) {
      for (var value in projectById?.tags) {
        tags.add(value);
      }
    }

    tagsText.value = tags.join(', ');

    titleController.text = projectDetailed.title;
    descriptionController.text = projectDetailed.description ?? '';
    selectedProjectManager.value = projectDetailed.responsible;

    isPMSelected.value = true;
    managerName.value = selectedProjectManager.value.displayName;

    var projectTeamDataSource = Get.put(ProjectTeamDataSource());
    projectTeamDataSource.projectDetailed = projectDetailed;
    await projectTeamDataSource.getTeam();

    if (selectedTeamMembers.isNotEmpty) selectedTeamMembers.clear();
    for (var portalUser in projectTeamDataSource.usersList) {
      portalUser.selectionMode.value = UserSelectionMode.Multiple;
      portalUser.isSelected.value = true;
      selectedTeamMembers.add(portalUser);
    }
    loaded.value = true;
  }

  Future updateStatus({int newStatusId}) async {
    projectDetailed.status = newStatusId;
    statusText.value = tr('projectStatus',
        args: [ProjectStatus.toName(projectDetailed.status)]);
  }

  Future<void> confirmChanges() async {
    if (titleController.text.isEmpty) {
      needToFillTitle.value = true;
    }
    if (selectedProjectManager == null) {
      needToFillManager.value = true;
    }

    if (needToFillTitle.value == true || needToFillManager.value == true)
      return;

    var participants = <Participant>[];

    for (var element in selectedTeamMembers) {
      participants.add(
        Participant(
            iD: element.portalUser.id,
            canReadMessages: true,
            canReadFiles: true,
            canReadTasks: true,
            canReadContacts: true,
            canReadMilestones: true),
      );
    }

    var newProject = EditProjectDTO(
      title: titleController.text,
      description: descriptionController.text,
      responsibleId: selectedProjectManager.value.id,
      participants: participants,
      private: isPrivate.value,
      status: projectDetailed.status,
      tags: tagsText.value,
    );

    var success = await _projectService.editProject(
        project: newProject, projectId: projectDetailed.id);
    if (success) {
      await Get.find<ProjectDetailsController>().refreshData();

      Get.back();
    }
  }

  Future<void> showTags() async {
    await Get.to(() => const TagsSelectionView(),
        arguments: {'controller': this});
  }
}
