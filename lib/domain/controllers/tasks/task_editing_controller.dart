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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/new_task_DTO.dart';
import 'package:projects/data/services/task/task_service.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/tasks/abstract_task_actions_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class TaskEditingController extends TaskActionsController {
  PortalTask task;
  final TaskService _api = locator<TaskService>();

  TaskEditingController({required this.task});

  final TextEditingController _titleController = TextEditingController();

  late TaskItemController _taskItemController;

  @override
  int? get selectedProjectId => task.projectOwner!.id;

  DateTime? _newStartDate;
  DateTime? _newDueDate;

  List? _previusSelectedResponsibles;

  Status? initialStatus;
  late Rx<Status?> newStatus;

  @override
  TextEditingController get titleController => _titleController;
  @override
  FocusNode? get titleFocus => null;

  @override
  DateTime? get dueDate => _newDueDate;
  @override
  DateTime? get startDate => _newStartDate;

  @override
  void onInit() async {
    title.value = task.title!;
    _titleController.text = task.title!;
    _taskItemController = Get.find<TaskItemController>(tag: task.id.toString());

    teamController = Get.find<ProjectTeamController>();

    initialStatus = _taskItemController.status.value;
    newStatus = initialStatus.obs;
    descriptionText.value = task.description!;
    descriptionController.value.text = task.description!;
    selectedMilestoneTitle.value = task.milestone?.title ?? tr('none');
    newMilestoneId = task.milestoneId;
    _initDates();
    highPriority.value = task.priority == 1;
    for (final user in task.responsibles!) {
      responsibles.add(PortalUserItemController(portalUser: user!));
    }
    // ignore: invalid_use_of_protected_member
    _previusSelectedResponsibles = List.from(responsibles.value);

    titleController.addListener(() => {titleIsEmpty.value = titleController.text.isEmpty});
    super.onInit();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void _initDates() {
    final now = DateTime.now();
    _newStartDate = task.startDate != null ? DateTime.parse(task.startDate!) : null;
    _newDueDate = task.deadline != null ? DateTime.parse(task.deadline!) : null;

    startDateText.value =
        task.startDate != null ? formatedDateFromString(now: now, stringDate: task.startDate!) : '';
    dueDateText.value =
        task.deadline != null ? formatedDateFromString(now: now, stringDate: task.deadline!) : '';
  }

  @override
  void changeTitle(String newText) => title.value = newText;

  Future<void> changeStatus(Status newStatus) async {
    if (newStatus.id == this.newStatus.value!.id) return;

    if (newStatus.statusType == 2 &&
        initialStatus!.statusType != newStatus.statusType &&
        task.hasOpenSubtasks) {
      await Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('closingTask'),
        contentText: tr('closingTaskWithActiveSubtasks'),
        acceptText: tr('closeTask').toUpperCase(),
        onAcceptTap: () async {
          this.newStatus.value = newStatus;
          Get.back();
        },
      ));
    } else {
      this.newStatus.value = newStatus;
    }
  }

  @override
  void confirmDescription(String typedText) {
    descriptionController.value.text = typedText;
    descriptionText.value = typedText;
    Get.find<NavigationController>().back();
  }

  @override
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
          descriptionController.value.text = task.description!;
          Get.back();
          Get.find<NavigationController>().back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  @override
  void changeMilestoneSelection({int? id, String? title}) {
    if (id != null && title != null) {
      selectedMilestoneTitle.value = title;
      newMilestoneId = id;
    } else {
      removeMilestoneSelection();
    }
    Get.find<NavigationController>().back();
  }

  void removeMilestoneSelection() {
    newMilestoneId = null;
    selectedMilestoneTitle.value = tr('none');
  }

  @override
  void changeStartDate(DateTime? newDate) {
    if (newDate != null) {
      final verificationResult = checkDate(newDate, _newDueDate);
      if (verificationResult) {
        startDateText.value = formatedDate(newDate);
        _newStartDate = newDate;
        Get.find<NavigationController>().back();
      }
    } else {
      startDateText.value = '';
      _newStartDate = null;
    }
  }

  @override
  void changeDueDate(DateTime? newDate) {
    if (newDate != null) {
      final verificationResult = checkDate(_newStartDate, newDate);
      if (verificationResult) {
        dueDateText.value = formatedDate(newDate);
        _newDueDate = newDate;
        Get.find<NavigationController>().back();
      }
    } else {
      dueDateText.value = '';
      _newDueDate = null;
    }
  }

  @override
  bool checkDate(DateTime? startDate, DateTime? dueDate) {
    if (startDate == null || dueDate == null) return true;
    if (startDate.isAfter(dueDate)) {
      Get.find<ErrorDialog>().show(tr('dateSelectionError'));
      return false;
    }
    return true;
  }

  @override
  void changePriority(bool value) => highPriority.value = value;

  @override
  void confirmResponsiblesSelection() {
    // ignore: invalid_use_of_protected_member
    _previusSelectedResponsibles = List.of(responsibles.value);
    Get.find<NavigationController>().back();
  }

  @override
  void leaveResponsiblesSelectionView() {
    // ignore: invalid_use_of_protected_member
    if (listEquals(_previusSelectedResponsibles, responsibles.value)) {
      Get.back();
    } else {
      Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        acceptColor: Theme.of(Get.context!).colors().colorError,
        onAcceptTap: () {
          responsibles.value = List.of(_previusSelectedResponsibles!);
          Get.back();
          Get.find<NavigationController>().back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  @override
  void setupResponsibleSelection() async {
    if (teamController.usersList.isEmpty) {
      teamController.setup(
          projectId: task.projectOwner!.id, withoutVisitors: true, withoutBlocked: true);

      await teamController.getTeam().then((value) => _getSelectedResponsibles());
    } else {
      await _getSelectedResponsibles();
    }
  }

  Future<void> _getSelectedResponsibles() async {
    for (final element in teamController.usersList) {
      element.isSelected.value = false;
      element.selectionMode.value = UserSelectionMode.Multiple;
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
    if (user.isSelected.value == true) {
      responsibles.add(user);
    } else {
      responsibles.removeWhere((element) => user.portalUser.id == element.portalUser.id);
    }
  }

  void discardChanges() {
    bool taskEdited;
    // checking all fields for changes
    taskEdited = title.value != task.title ||
        descriptionText.value != task.description ||
        newMilestoneId != task.milestoneId ||
        initialStatus!.id != newStatus.value!.id ||
        task.responsibles!.length != responsibles.length;

    var i = 0;
    while (!taskEdited && responsibles.length > i) {
      if (responsibles[i].portalUser.id != task.responsibles![i]!.id) {
        taskEdited = true;
      }
      i++;
    }

    // warn the user if there have been changes
    if (taskEdited) {
      Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
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
      //leave
      Get.back();
    }
  }

  Future<void> confirm() async {
    title.value = title.string.trim();
    _titleController.text = title.value;

    if (title.isEmpty || task.title == null) setTitleError.value = true;

    if (setTitleError.value) {
      unawaited(900.milliseconds.delay().then((value) {
        setTitleError.value = false;
      }));
      return;
    }

    // update the task status if it has been changed
    if (initialStatus!.id != newStatus.value!.id) {
      await _taskItemController.tryChangingStatus(
          id: task.id!,
          newStatusId: newStatus.value!.id!,
          newStatusType: newStatus.value!.statusType!);
    }

    final responsibleIds = <String?>[];
    for (final item in responsibles) responsibleIds.add(item.id as String?);
    final newTask = NewTaskDTO(
      description: descriptionText.value,
      deadline: _newDueDate,
      id: task.id,
      startDate: _newStartDate,
      priority: highPriority.value == true ? 'high' : 'normal',
      title: title.value,
      milestoneid: newMilestoneId,
      projectId: task.projectOwner!.id!,
      responsibles: responsibleIds,
    );

    final updatedTask = await _api.updateTask(newTask: newTask);

    if (updatedTask != null) {
      unawaited(_taskItemController.reloadTask(showLoading: true));
      Get.find<NavigationController>().back();
    } else
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
  }

  Future<void> acceptTask() async {
    final newTask = NewTaskDTO(
      description: descriptionText.value,
      deadline: _newDueDate,
      id: task.id,
      startDate: _newStartDate,
      priority: highPriority.value == true ? 'high' : 'normal',
      title: title.value,
      milestoneid: newMilestoneId,
      projectId: task.projectOwner!.id!,
      responsibles: [Get.find<UserController>().user.value!.id],
    );
    final updatedTask = await _api.updateTask(newTask: newTask);

    if (updatedTask != null) {
      _taskItemController.reloadTask(showLoading: true);
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('taskAccepted'));
    }
  }

  @override
  void changeProjectSelection(ProjectDetailed? _details) {
    // TODO: implement changeProjectSelection
  }
}
