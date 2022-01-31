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
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/services/task/subtasks_service.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_action_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class SubtaskEditingController extends GetxController implements SubtaskActionController {
  SubtaskEditingController(this.subtaskController);

  final subtaskController;
  final SubtasksService _api = locator<SubtasksService>();
  final _titleController = TextEditingController();
  Subtask? _subtask;
  late ProjectTeamController teamController;

  @override
  TextEditingController get titleController => _titleController;
  @override
  FocusNode? get titleFocus => null;
  RxList responsibles = [].obs;
  @override
  RxInt? status;
  @override
  RxBool? setTiltleError = false.obs;
  // title befor editing
  String? _previousTitle;
  // responsible id before editing
  String? _previousResponsibleId;
  List _previusSelectedResponsible = [];

  @override
  void init({Subtask? subtask, int? projectId}) {
    _subtask = subtask;
    _previousTitle = subtask!.title;
    _previousResponsibleId = subtask.responsible?.id;
    _titleController.text = subtask.title!;

    teamController = Get.find<ProjectTeamController>();

    status = subtask.status!.obs;
    if (_subtask!.responsible != null) {
      _previusSelectedResponsible.add(PortalUserItemController(portalUser: _subtask!.responsible!));
      responsibles.add(PortalUserItemController(portalUser: _subtask!.responsible!));
    }
    setupResponsibleSelection(projectId);
  }

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
    // ignore: avoid_function_literals_in_foreach_calls
    teamController.usersList.forEach((element) {
      if (element.portalUser.id != user.id) element.isSelected.value = false;
    });
    responsibles.clear();
    if (user.isSelected.value == true) {
      responsibles.add(user);
    } else {
      responsibles.removeWhere((element) => user.portalUser.id == element.portalUser.id);
    }
  }

  @override
  void confirmResponsiblesSelection() {
    // ignore: invalid_use_of_protected_member
    _previusSelectedResponsible = List.of(responsibles.value);
    Get.back();
  }

  @override
  void leaveResponsiblesSelectionView() {
    // ignore: invalid_use_of_protected_member
    if (listEquals(_previusSelectedResponsible, responsibles.value)) {
      Get.back();
    } else {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        onAcceptTap: () {
          responsibles.value = [_previusSelectedResponsible];
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  @override
  void deleteResponsible() => responsibles.clear();

  @override
  void leavePage() {
    var responsible;
    if (responsibles.isNotEmpty)
      responsible = responsibles[0]?.id;
    else
      responsible = null;

    if (responsible != _previousResponsibleId || _titleController.text != _previousTitle) {
      Get.dialog(Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: StyledAlertDialog(
          titleText: tr('discardChanges'),
          contentText: tr('lostOnLeaveWarning'),
          acceptText: tr('delete').toUpperCase(),
          onAcceptTap: () {
            Get.back();
            Get.back();
          },
          onCancelTap: Get.back,
        ),
      ));
    } else {
      Get.back();
    }
  }

  @override
  Future<void> confirm({required BuildContext context, int? taskId}) async {
    // TODO taskid not used
    titleController.text = titleController.text.trim();
    if (titleController.text.isEmpty)
      setTiltleError!.value = true;
    else {
      final responsible = responsibles.isEmpty ? null : responsibles[0]?.portalUser?.id;

      final data = {'responsible': responsible, 'title': _titleController.text};

      final editedSubtask = await _api.updateSubtask(
        taskId: _subtask!.taskId!,
        subtaskId: _subtask!.id!,
        data: data,
      );
      if (editedSubtask != null) {
        _subtask = editedSubtask;

        subtaskController.subtask.value = editedSubtask;

        locator<EventHub>().fire('needToRefreshParentTask', [editedSubtask.taskId]);

        Get.back();
      }
    }
  }
}
