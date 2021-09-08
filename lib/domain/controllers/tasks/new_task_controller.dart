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
import 'package:projects/data/models/from_api/error.dart';
import 'package:projects/data/models/new_task_DTO.dart';
import 'package:projects/data/services/task/task_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/tasks/abstract_task_actions_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_snackbar.dart';
import 'package:projects/presentation/views/task_detailed/task_detailed_view.dart';

class NewTaskController extends GetxController
    implements TaskActionsController {
  final _api = locator<TaskService>();
  var teamController;

  var _selectedProjectId;
  var newMilestoneId;
  // for dateTime format
  DateTime _startDate;
  DateTime _dueDate;

  int get selectedProjectId => _selectedProjectId;
  int get selectedMilestoneId => newMilestoneId;
  DateTime get startDate => _startDate;
  DateTime get dueDate => _dueDate;

  @override
  RxString title = ''.obs;
  @override
  var selectedProjectTitle = ''.obs; //RxString
  @override
  RxString selectedMilestoneTitle = ''.obs;

  @override
  RxString descriptionText = ''.obs;
  var descriptionController = TextEditingController().obs;
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();

  @override
  TextEditingController get titleController => _titleController;
  @override
  FocusNode get titleFocus => _titleFocus;

  // for readable format
  @override
  RxString startDateText = ''.obs;
  @override
  RxString dueDateText = ''.obs;

  @override
  RxList responsibles = [].obs;
  // to track changes
  List _previusSelectedResponsibles = [];
  @override
  RxBool highPriority = false.obs;
  RxBool notifyResponsibles = false.obs;

  @override
  var needToSelectProject = false.obs; //RxBool
  @override
  RxBool setTitleError = false.obs;

  @override
  void init([projectDetailed]) {
    _titleFocus.requestFocus();

    teamController = Get.find<ProjectTeamController>();
    teamController.withoutVisitors = true;

    if (projectDetailed != null) {
      selectedProjectTitle.value = projectDetailed.title;
      _selectedProjectId = projectDetailed.id;
      needToSelectProject.value = false;
    }
  }

  @override
  void changeTitle(String newText) => title.value = newText;

  void changeProjectSelection({var id, String title}) {
    if (id != null && title != null) {
      selectedProjectTitle.value = title;
      _selectedProjectId = id;
      needToSelectProject.value = false;
    } else {
      removeProjectSelection();
    }
    Get.back();
  }

  void removeProjectSelection() {
    _selectedProjectId = null;
    selectedProjectTitle.value = '';
  }

  @override
  void changeMilestoneSelection({var id, String title}) {
    if (id != null && title != null) {
      selectedMilestoneTitle.value = title;
      newMilestoneId = id;
    } else {
      removeMilestoneSelection();
    }
    Get.back();
  }

  void removeMilestoneSelection() {
    newMilestoneId = null;
    selectedMilestoneTitle.value = '';
  }

  @override
  void changePriority(bool value) => highPriority.value = value;

  void changeNotifyResponsiblesValue(bool value) {
    notifyResponsibles.value = value;
  }

  @override
  void confirmDescription(String newText) {
    descriptionText.value = newText;
    Get.back();
  }

  @override
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
    // ignore: invalid_use_of_protected_member
    _previusSelectedResponsibles = List.of(responsibles.value);
    Get.back();
  }

  void leaveResponsiblesSelectionView() {
    // ignore: invalid_use_of_protected_member
    if (listEquals(_previusSelectedResponsibles, responsibles.value)) {
      Get.back();
    } else {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        onAcceptTap: () {
          notifyResponsibles.value = false;
          responsibles.value = List.of(_previusSelectedResponsibles);
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  void setupResponsibleSelection() async {
    if (teamController.usersList.isEmpty) {
      teamController.projectId = _selectedProjectId;

      await teamController
          .getTeam()
          .then((value) => _getSelectedResponsibles());
    } else {
      await _getSelectedResponsibles();
    }
  }

  Future<void> _getSelectedResponsibles() async {
    for (var element in teamController.usersList) {
      element.isSelected.value = false;
      element.selectionMode.value = UserSelectionMode.Multiple;
    }
    for (var selectedMember in responsibles) {
      for (var user in teamController.usersList) {
        if (selectedMember.portalUser.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      }
    }
  }

  void addResponsible(PortalUserItemController user) {
    if (user.isSelected.value == true) {
      responsibles.add(user);
    } else {
      responsibles.removeWhere(
          (element) => user.portalUser.id == element.portalUser.id);
    }
  }

  @override
  void changeStartDate(DateTime newDate) {
    if (newDate != null) {
      // ignore: omit_local_variable_types
      bool verificationResult = checkDate(newDate, _dueDate);
      if (verificationResult) {
        _startDate = newDate;
        startDateText.value = formatedDate(newDate);
        Get.back();
      }
    } else {
      _startDate = null;
      startDateText.value = '';
    }
  }

  @override
  void changeDueDate(DateTime newDate) {
    if (newDate != null) {
      // ignore: omit_local_variable_types
      bool verificationResult = checkDate(_startDate, newDate);
      if (verificationResult) {
        _dueDate = newDate;
        dueDateText.value = formatedDate(newDate);
        Get.back();
      }
    } else {
      _dueDate = null;
      dueDateText.value = '';
    }
  }

  @override
  bool checkDate(DateTime startDate, DateTime dueDate) {
    if (startDate == null || dueDate == null) return true;
    if (startDate.isAfter(dueDate)) {
      ErrorDialog.show(CustomError(message: tr('dateSelectionError')));
      return false;
    }
    return true;
  }

  void confirm(BuildContext context) async {
    if (_selectedProjectId == null) needToSelectProject.value = true;
    if (title.isEmpty) setTitleError.value = true;
    if (_selectedProjectId == null || title.isEmpty) return;

    String priority;
    // ignore: omit_local_variable_types
    List<String> responsibleIds = [];

    if (highPriority.value == true) priority = 'high';
    for (var item in responsibles) responsibleIds.add(item.id);

    var newTask = NewTaskDTO(
        projectId: _selectedProjectId,
        responsibles: responsibleIds,
        startDate: _startDate,
        deadline: _dueDate,
        priority: priority,
        notify: notifyResponsibles.value,
        description: descriptionText.value,
        title: title.value,
        milestoneid: newMilestoneId);

    var createdTask = await _api.addTask(newTask: newTask);
    if (createdTask != null) {
      var tasksController = Get.find<TasksController>();
      // ignore: unawaited_futures
      tasksController.loadTasks();
      Get.back();
      // ignore: unawaited_futures
      tasksController.raiseFAB();
      ScaffoldMessenger.of(context).showSnackBar(styledSnackBar(
          context: context,
          text: tr('taskCreated'),
          buttonText: tr('open').toUpperCase(),
          buttonOnTap: () {
            var itemController = Get.put(TaskItemController(createdTask),
                tag: createdTask.id.toString());
            return Get.find<NavigationController>().to(TaskDetailedView(),
                arguments: {'controller': itemController});
          }));

      locator<EventHub>().fire('needToRefreshProjects');
    }
  }

  void discardTask() {
    if (_selectedProjectId != null ||
        title.isNotEmpty ||
        responsibles.isNotEmpty ||
        descriptionText.isNotEmpty ||
        _startDate != null ||
        _dueDate != null) {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardTask'),
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
}
