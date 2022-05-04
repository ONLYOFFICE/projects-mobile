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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/projects/project_status_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/project_detailed/tags_selection_view.dart';

class ProjectEditController extends BaseProjectEditorController {
  final ProjectService _projectService = locator<ProjectService>();

  RxBool loaded = true.obs;
  RxBool isSearchResult = false.obs;
  RxBool nothingFound = false.obs;
  RxString projectTitleText = ''.obs;

  var selectedTags;

  EditProjectDTO? oldProjectDTO;

  ProjectDetailed? _projectDetailed;

  @override
  ProjectDetailed? get projectData => _projectDetailed;

  Future<void> setupEditor(ProjectDetailed? projectDetailed) async {
    _projectDetailed = projectDetailed;
    loaded.value = false;

    oldProjectDTO = null;
    statusText.value = tr('projectStatus', args: [ProjectStatus.toName(_projectDetailed!.status)]);

    projectTitleText.value = _projectDetailed!.title!;
    descriptionText.value = _projectDetailed!.description!;

    isPrivate.value = _projectDetailed!.isPrivate!;

    final projectById = await _projectService.getProjectById(projectId: _projectDetailed!.id!);
    if (projectById != null) {
      tags.clear();
      if (projectById.tags != null) {
        for (final value in projectById.tags!) {
          tags.add(value);
        }
      }
    }

    tagsText.value = tags.join(', ');

    titleController.text = _projectDetailed!.title!;
    descriptionController.text = _projectDetailed!.description ?? '';
    selectedProjectManager.value = _projectDetailed!.responsible;

    isPMSelected.value = true;
    managerName.value = selectedProjectManager.value!.displayName!;

    final projectTeamDataSource = Get.put(ProjectTeamController())
      ..setup(projectDetailed: projectDetailed);

    await projectTeamDataSource.getTeam();

    if (selectedTeamMembers.isNotEmpty) selectedTeamMembers.clear();
    for (final portalUser in projectTeamDataSource.usersList) {
      portalUser.selectionMode.value = UserSelectionMode.Multiple;
      portalUser.isSelected.value = true;
      selectedTeamMembers.add(portalUser);
    }
    selectedTeamMembers
        .removeWhere((element) => element.portalUser.id == selectedProjectManager.value!.id);

    final participants = <Participant>[];

    for (final element in selectedTeamMembers) {
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

    oldProjectDTO = EditProjectDTO(
      title: titleController.text,
      description: descriptionController.text,
      responsibleId: selectedProjectManager.value!.id,
      participants: participants,
      private: isPrivate.value,
      status: _projectDetailed!.status,
      tags: tagsText.value,
    );

    loaded.value = true;
  }

  @override
  Future<bool> updateStatus({int? newStatusId}) async => Get.find<ProjectStatusesController>()
      .updateStatus(newStatusId: newStatusId, projectData: _projectDetailed!);

  Future<void> confirmChanges() async {
    titleController.text = titleController.text.trim();
    needToFillTitle.value = titleController.text.isEmpty;

    needToFillManager.value = selectedProjectManager.value?.id == null;

    if (needToFillTitle.value || needToFillManager.value) {
      unawaited(900.milliseconds.delay().then((value) {
        needToFillTitle.value = false;
        needToFillManager.value = false;
      }));
      return;
    }

    final participants = <Participant>[];

    for (final element in selectedTeamMembers) {
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

    final newProject = EditProjectDTO(
      title: titleController.text,
      description: descriptionController.text,
      responsibleId: selectedProjectManager.value!.id,
      participants: participants,
      private: isPrivate.value,
      status: _projectDetailed!.status,
      tags: tagsText.value,
      notify: notificationEnabled.value,
    );

    final success = await _projectService.editProject(
      project: newProject,
      projectId: _projectDetailed!.id!,
    );
    if (success) {
      Get.back();

      locator<EventHub>().fire('needToRefreshProjects', {'all': true});
    } else
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
  }

  void discardChanges() {
    bool edited;
    // checking all fields for changes
    edited = oldProjectDTO!.title != titleController.text ||
        oldProjectDTO!.description != descriptionController.text ||
        oldProjectDTO!.responsibleId != selectedProjectManager.value?.id ||
        oldProjectDTO!.private != isPrivate.value ||
        oldProjectDTO!.status != _projectDetailed!.status ||
        tagsText.value != tagsText.value;

    var i = 0;
    while (!edited && oldProjectDTO!.participants!.length > i) {
      if (oldProjectDTO!.participants![i].iD != selectedTeamMembers[i].portalUser.id) {
        edited = true;
      }
      i++;
    }

    // warn the user if there have been changes
    if (edited) {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('changesWillBeLost'),
        acceptText: tr('discard'),
        acceptColor: Theme.of(Get.context!).colors().colorError,
        onAcceptTap: () {
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    } else {
      //leave
      Get.back();
    }
  }

  @override
  Future<void> showTags() async {
    await Get.find<NavigationController>().toScreen(
      const TagsSelectionView(),
      arguments: {'controller': this},
      transition: Transition.rightToLeft,
      page: '/TagsSelectionView',
    );
  }
}
