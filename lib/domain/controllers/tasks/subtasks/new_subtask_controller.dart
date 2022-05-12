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
import 'package:event_hub/event_hub.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/services/task/subtasks_service.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_action_controller.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtask_detailed_view.dart';

class NewSubtaskController extends GetxController implements SubtaskActionController {
  Subtask? subtask;

  final SubtasksService _api = locator<SubtasksService>();

  @override
  late ProjectTeamController teamController;

  final _titleController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();

  @override
  TextEditingController get titleController => _titleController;
  @override
  FocusNode get titleFocus => _titleFocus;
  @override
  final responsibles = [].obs;
  @override
  RxInt? status = 1.obs;
  @override
  RxBool? setTiltleError = false.obs;

  List _previusSelectedResponsible = [];

  @override
  void init({Subtask? subtask, int? projectId}) {
    teamController = Get.find<ProjectTeamController>();

    _titleFocus.requestFocus();
    setupResponsibleSelection(projectId);
  }

  @override
  void setupResponsibleSelection([int? projectId]) async {
    if (teamController.usersList.isEmpty) {
      teamController.setup(projectId: projectId, withoutVisitors: true, withoutBlocked: true);

      await teamController.getTeam().then((value) => _getSelectedResponsibles());
    } else {
      await _getSelectedResponsibles();
    }
  }

  Future<void> _getSelectedResponsibles() async {
    for (final element in teamController.usersList) {
      element.isSelected.value = false;
      element.selectionMode.value = UserSelectionMode.Single;
    }
    for (final selectedMember in responsibles) {
      for (final user in teamController.usersList) {
        if (selectedMember.portalUser.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      }
    }
  }

  @override
  void addResponsible(PortalUserItemController user) {
    for (final element in teamController.usersList) {
      if (element.portalUser.id != user.id) element.isSelected.value = false;
    }
    responsibles.clear();
    if (user.isSelected.value == true) {
      responsibles.add(user);
      Get.find<NavigationController>().back();
    } else {
      responsibles.removeWhere((element) => user.portalUser.id == element.portalUser.id);
    }
  }

  @override
  void confirmResponsiblesSelection() {
    _previusSelectedResponsible = List.of(responsibles);
    Get.find<NavigationController>().back();
  }

  @override
  void leaveResponsiblesSelectionView() {
    if (listEquals(_previusSelectedResponsible, responsibles)) {
      Get.back();
    } else {
      Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        acceptColor: Theme.of(Get.context!).colors().colorError,
        onAcceptTap: () {
          responsibles.value = List.of(_previusSelectedResponsible);
          Get.back();
          Get.find<NavigationController>().back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  @override
  void deleteResponsible() {
    responsibles.clear();
    _previusSelectedResponsible.clear();
  }

  @override
  void leavePage() {
    if (responsibles.isNotEmpty || _titleController.text.isNotEmpty) {
      Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        acceptColor: Theme.of(Get.context!).colors().colorError,
        onAcceptTap: () {
          Get.back();
          Get.find<NavigationController>().back();
        },
        onCancelTap: Get.back,
      ));
    } else {
      Get.back();
    }
  }

  @override
  Future<void> confirm({required dynamic context, required int taskId}) async {
    titleController.text = titleController.text.trim();
    if (titleController.text.isEmpty)
      setTiltleError!.value = true;
    else {
      final responsible = responsibles.isEmpty ? null : responsibles[0]?.portalUser?.id;

      final data = {'responsible': responsible, 'title': _titleController.text};
      final newSubtask = await _api.createSubtask(taskId: taskId, data: data);
      if (newSubtask != null) {
        final taskController = Get.find<TaskItemController>(tag: taskId.toString());

        Get.find<NavigationController>().back();
        locator<EventHub>().fire('needToRefreshParentTask', [taskId, true]);

        MessagesHandler.showSnackBar(
            context: Get.context!,
            text: tr('subtaskCreated'),
            buttonText: tr('open').toUpperCase(),
            buttonOnTap: () {
              final controller = Get.put(
                  SubtaskController(subtask: newSubtask, parentTask: taskController.task.value),
                  tag: newSubtask.hashCode.toString());
              return Get.find<NavigationController>()
                  .to(const SubtaskDetailedView(), arguments: {'controller': controller});
            });
      }
    }
  }

  @override
  set responsibles(RxList _responsibles) {
    // TODO: implement responsibles
  }
}
