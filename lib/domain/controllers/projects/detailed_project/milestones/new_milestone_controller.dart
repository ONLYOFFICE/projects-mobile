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
import 'package:projects/data/models/new_milestone_DTO.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/new_task/select/select_date_view.dart';

class NewMilestoneController extends GetxController {
  final _api = locator<MilestoneService>();

  int? _selectedProjectId;
  int? get selectedProjectId => _selectedProjectId;

  DateTime? _dueDate;
  DateTime? get dueDate => _dueDate;

  final remindBeforeDueDate = false.obs;
  final keyMilestone = false.obs;

  final notificationEnabled = false.obs;

  final titleIsEmpty = true.obs;
  final titleFocus = FocusNode();

  late ProjectTeamController teamController;

  final selectedProjectTitle = ''.obs;
  final slectedMilestoneTitle = ''.obs;

  final descriptionText = ''.obs;
  final descriptionController = TextEditingController().obs;

  final dueDateText = ''.obs;
  final needToSelectProject = false.obs;
  final needToSetTitle = false.obs;
  final needToSelectResponsible = false.obs;
  final needToSetDueDate = false.obs;

  final titleController = TextEditingController();

  PortalUserItemController? _previusSelectedResponsible;
  final responsible = Rxn<PortalUserItemController>();
  final teamMembers = <PortalUserItemController>[].obs;

  late PortalUserItemController selfUserItem;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    final _userController = Get.find<UserController>();

    if (_userController.user.value != null)
      selfUserItem = PortalUserItemController(portalUser: _userController.user.value!);
    else
      _userController.updateData();

    _userController.user.listen((user) {
      if (user == null) return;
      selfUserItem = PortalUserItemController(portalUser: _userController.user.value!);
    });

    super.onInit();
  }

  Future<void> setup(ProjectDetailed projectDetailed) async {
    selectedProjectTitle.value = projectDetailed.title!;
    _selectedProjectId = projectDetailed.id;
    needToSelectProject.value = false;

    responsible.value = PortalUserItemController(portalUser: projectDetailed.responsible!);
    needToSelectResponsible.value = false;

    teamController = Get.find<ProjectTeamController>()
      ..setup(projectDetailed: projectDetailed, withoutVisitors: true, withoutBlocked: true);

    await teamController.getTeam();

    for (final user in teamController.usersList) {
      teamMembers.add(user);
    }

    titleController.addListener(() {
      titleIsEmpty.value = titleController.text.isEmpty;
    });
  }

  void changeProjectSelection(ProjectDetailed? _details) {
    if (_details != null) {
      selectedProjectTitle.value = _details.title!;
      _selectedProjectId = _details.id;
      needToSelectProject.value = false;

      responsible.value = PortalUserItemController(portalUser: _details.responsible!);
      checkNeedNotification();
      needToSelectResponsible.value = false;
      _previusSelectedResponsible = responsible.value;

      teamController.setup(projectDetailed: _details, withoutVisitors: true, withoutBlocked: true);
      teamMembers.clear();
      teamController.getTeam().then((value) {
        for (final user in teamController.usersList) {
          teamMembers.add(user);
        }
      });
    } else {
      removeProjectSelection();
    }
    Get.find<NavigationController>().back();
  }

  void removeProjectSelection() {
    _selectedProjectId = null;
    selectedProjectTitle.value = '';
  }

  void confirmDescription(String newText) {
    descriptionText.value = newText;
    Get.find<NavigationController>().back();
  }

  void leaveDescriptionView(String typedText) {
    if (typedText == descriptionText.value) {
      Get.find<NavigationController>().back();
    } else {
      Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        acceptColor: Theme.of(Get.context!).colors().colorError,
        onAcceptTap: () {
          descriptionController.value.text = descriptionText.value;
          Get.back();
          Get.find<NavigationController>().back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  void confirmResponsiblesSelection() {
    _previusSelectedResponsible = responsible.value;
    Get.find<NavigationController>().back();
  }

  void leaveResponsiblesSelectionView() {
    if (_previusSelectedResponsible == null || _previusSelectedResponsible == responsible.value) {
      Get.find<NavigationController>().back();
    } else {
      Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        acceptColor: Theme.of(Get.context!).colors().colorError,
        onAcceptTap: () {
          responsible.value = _previusSelectedResponsible;
          Get.back();
          Get.find<NavigationController>().back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  Future setupResponsibleSelection() async {
    await teamController.getTeam().then((value) => _applyUsersSelection());
  }

  Future<void> _applyUsersSelection() async {
    for (final element in teamController.usersList) {
      element.isSelected.value = false;
      element.selectionMode.value = UserSelectionMode.Single;
    }

    if (responsible.value != null) {
      for (final user in teamController.usersList) {
        if (responsible.value!.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      }
    }
  }

  void addResponsible(PortalUserItemController user) {
    responsible.value = user;

    checkNeedNotification();

    needToSelectResponsible.value = false;
    _previusSelectedResponsible = responsible.value;

    Get.back();
  }

  void changeDueDate(DateTime? newDate) {
    if (newDate != null) {
      _dueDate = newDate;
      dueDateText.value =
          formatedDateFromString(now: DateTime.now(), stringDate: newDate.toString());
      Get.find<NavigationController>().back();
    } else {
      _dueDate = null;
      dueDateText.value = '';
    }

    needToSetDueDate.value = false;
  }

  void confirm() async {
    needToSelectProject.value = _selectedProjectId == null;

    titleController.text = titleController.text.trim();
    needToSetTitle.value = titleController.text.isEmpty;

    needToSelectResponsible.value = responsible.value == null;
    needToSetDueDate.value = dueDate == null;

    if (needToSelectProject.value ||
        needToSetTitle.value ||
        needToSelectResponsible.value ||
        needToSetDueDate.value) {
      unawaited(900.milliseconds.delay().then((value) {
        needToSelectProject.value = false;
        needToSetTitle.value = false;
        needToSelectResponsible.value = false;
        needToSetDueDate.value = false;
      }));
      return;
    }

    Get.find<NavigationController>().back();

    final milestone = NewMilestoneDTO(
      title: titleController.text,
      description: descriptionController.value.text,
      deadline: dueDate,
      isKey: keyMilestone.value,
      responsible: responsible.value!.id,
      isNotify: remindBeforeDueDate.value,
      notifyResponsible: notificationEnabled.value,
    );

    final success =
        await _api.createMilestone(projectId: _selectedProjectId!, milestone: milestone);
    if (success) {
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('milestoneCreated'));
      locator<EventHub>().fire('needToRefreshMilestones');
    } else
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
  }

  void discard() {
    if (_selectedProjectId != null ||
        titleController.text.isNotEmpty ||
        responsible.value != null ||
        descriptionText.isNotEmpty ||
        _dueDate != null) {
      Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('discardMilestone'),
        contentText: tr('changesWillBeLost'),
        acceptText: tr('discard'),
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

  void setKeyMilestone(bool value) => keyMilestone.value = value;
  void enableRemindBeforeDueDate(bool value) => remindBeforeDueDate.value = value;

  void onDueDateTilePressed() {
    Get.find<NavigationController>().toScreen(
      const SelectDateView(),
      arguments: {'controller': this, 'startDate': false, 'initialDate': _dueDate},
      transition: Transition.rightToLeft,
      page: '/SelectDateView',
    );
  }

  void enableNotification(bool value) {
    notificationEnabled.value = value;
  }

  void checkNeedNotification() {
    if (responsible.value?.id == selfUserItem.id!)
      notificationEnabled.value = false;
    else
      notificationEnabled.value = true;
  }
}
