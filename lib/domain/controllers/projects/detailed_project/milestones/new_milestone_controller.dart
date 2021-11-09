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
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/new_milestone_DTO.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/new_task/select/select_date_view.dart';

class NewMilestoneController extends GetxController {
  final _api = locator<MilestoneService>();
  var _selectedProjectId;
  DateTime _dueDate;

  var remindBeforeDueDate = false.obs;
  var keyMilestone = false.obs;

  var notificationEnabled = false.obs;
  int get selectedProjectId => _selectedProjectId;
  DateTime get dueDate => _dueDate;

  var teamController;

  RxString slectedProjectTitle = ''.obs;
  RxString slectedMilestoneTitle = ''.obs;

  RxString descriptionText = ''.obs;
  var descriptionController = TextEditingController().obs;

  RxString dueDateText = ''.obs;
  RxBool needToSelectProject = false.obs;
  RxBool needToSetTitle = false.obs;
  RxBool needToSelectResponsible = false.obs;
  RxBool needToSetDueDate = false.obs;

  var titleController = TextEditingController();

  PortalUserItemController _previusSelectedResponsible;
  Rx<PortalUserItemController> responsible;
  var teamMembers = <PortalUserItemController>[].obs;

  Future<void> setup(ProjectDetailed projectDetailed) async {
    if (projectDetailed != null) {
      slectedProjectTitle.value = projectDetailed.title;
      _selectedProjectId = projectDetailed.id;
      needToSelectProject.value = false;

      teamController = Get.find<ProjectTeamController>()
        ..setup(
            projectDetailed: projectDetailed,
            withoutVisitors: true,
            withoutBlocked: true);

      await teamController.getTeam();

      for (var user in teamController.usersList) {
        teamMembers.add(user);
      }
    }
  }

  void changeProjectSelection({var id, String title}) {
    if (id != null && title != null) {
      slectedProjectTitle.value = title;
      _selectedProjectId = id;
      needToSelectProject.value = false;
    } else {
      removeProjectSelection();
    }
    Get.back();
  }

  void removeProjectSelection() {
    _selectedProjectId = null;
    slectedProjectTitle.value = '';
  }

  void confirmDescription(String newText) {
    descriptionText.value = newText;
    Get.back();
  }

  void leaveDescriptionView(String typedText) {
    if (typedText == descriptionText.value) {
      Get.back();
    } else {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        onAcceptTap: () {
          descriptionController.value.text = descriptionText.value;
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  void confirmResponsiblesSelection() {
    _previusSelectedResponsible = responsible.value;
    Get.back();
  }

  void leaveResponsiblesSelectionView() {
    if (_previusSelectedResponsible == null ||
        _previusSelectedResponsible == responsible.value) {
      Get.back();
    } else {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        onAcceptTap: () {
          responsible.value = _previusSelectedResponsible;
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  Future setupResponsibleSelection() async {
    await teamController.getTeam().then((value) => _applyUsersSelection());
  }

  Future<void> _applyUsersSelection() async {
    for (var element in teamController.usersList) {
      element.isSelected.value = false;
      element.selectionMode.value = UserSelectionMode.Single;
    }

    if (responsible != null) {
      for (var user in teamController.usersList) {
        if (responsible.value.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      }
    }
  }

  void addResponsible(PortalUserItemController user) {
    responsible = user.obs;
    needToSelectResponsible.value = false;
    Get.back();
  }

  void changeDueDate(DateTime newDate) {
    if (newDate != null) {
      _dueDate = newDate;
      dueDateText.value = formatedDateFromString(
          now: DateTime.now(), stringDate: newDate.toString());
      Get.back();
    } else {
      _dueDate = null;
      dueDateText.value = '';
    }

    needToSetDueDate.value = false;
  }

  void confirm(BuildContext context) async {
    needToSelectProject.value = _selectedProjectId == null;
    needToSetTitle.value = titleController.text.isEmpty;
    needToSelectResponsible.value = responsible?.value == null;
    needToSetDueDate.value = dueDate == null;

    if (needToSelectProject.value ||
        needToSetTitle.value ||
        needToSelectResponsible.value ||
        needToSetDueDate.value) return;

    var milestone = NewMilestoneDTO(
      title: titleController.text,
      description: descriptionController.value.text,
      deadline: dueDate,
      isKey: keyMilestone.value,
      responsible: responsible.value.id,
      isNotify: remindBeforeDueDate.value,
      notifyResponsible: notificationEnabled.value,
    );

    var success = await _api.createMilestone(
        projectId: _selectedProjectId, milestone: milestone);
    if (success) {
      MessagesHandler.showSnackBar(
          context: context, text: tr('milestoneCreated'));
      locator<EventHub>().fire('needToRefreshProjects');
      Get.back();
    }
  }

  void discard() {
    if (_selectedProjectId != null ||
        titleController.text.isNotEmpty ||
        responsible != null ||
        descriptionText.isNotEmpty ||
        _dueDate != null) {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardMilestone'),
        contentText: tr('changesWillBeLost'),
        acceptText: tr('discard'),
        onAcceptTap: () {
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    } else {
      Get.back();
    }
  }

  void setKeyMilestone(value) => keyMilestone.value = value;
  void enableRemindBeforeDueDate(value) => remindBeforeDueDate.value = value;

  void onDueDateTilePressed() {
    Get.find<NavigationController>().toScreen(const SelectDateView(),
        arguments: {
          'controller': this,
          'startDate': false,
          'initialDate': _dueDate
        });
  }

  void enableNotification(bool value) {
    notificationEnabled.value = value;
  }
}
