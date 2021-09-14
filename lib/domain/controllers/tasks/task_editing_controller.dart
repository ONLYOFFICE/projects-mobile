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
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/error.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/new_task_DTO.dart';
import 'package:projects/data/services/task/task_service.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/tasks/abstract_task_actions_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class TaskEditingController extends GetxController
    implements TaskActionsController {
  PortalTask task;
  final _api = locator<TaskService>();

  var teamController;

  TaskEditingController({@required this.task});

  @override
  RxBool setTitleError = false.obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;

  final TextEditingController _titleController = TextEditingController();

  TaskItemController _taskItemController;

  int get selectedProjectId => task.projectOwner.id;

  @override
  RxString title;
  @override
  RxString descriptionText;
  var newMilestoneId;
  @override
  RxString selectedMilestoneTitle;
  @override
  var selectedProjectTitle; //Unused
  @override
  var needToSelectProject = false;
  // to track changes.
  DateTime _newStartDate;
  @override
  RxString startDateText;
  DateTime _newDueDate;
  @override
  RxString dueDateText;
  @override
  RxBool highPriority;

  @override
  RxList responsibles;
  // to track changes
  List _previusSelectedResponsibles;

  Status initialStatus;
  Rx<Status> newStatus;

  @override
  TextEditingController get titleController => _titleController;
  @override
  FocusNode get titleFocus => null;

  @override
  void init() {
    title = task.title.obs;
    _titleController.text = task.title;
    _taskItemController = Get.find<TaskItemController>(tag: task.id.toString());

    teamController = Get.find<ProjectTeamController>();
    teamController.withoutVisitors = true;

    initialStatus = _taskItemController.status.value;
    newStatus = initialStatus.obs;
    descriptionText = task.description.obs;
    descriptionController.value.text = task.description;
    selectedMilestoneTitle = task.milestone?.title?.obs ?? tr('none').obs;
    newMilestoneId = task.milestoneId;
    _initDates();
    highPriority = task.priority == 1 ? true.obs : false.obs;
    responsibles = [].obs;
    for (var user in task.responsibles) {
      responsibles.add(PortalUserItemController(portalUser: user));
    }
    // ignore: invalid_use_of_protected_member
    _previusSelectedResponsibles = List.from(responsibles.value);
  }

  void _initDates() {
    var now = DateTime.now();
    _newStartDate =
        task.startDate != null ? DateTime.parse(task.startDate) : null;
    _newDueDate = task.deadline != null ? DateTime.parse(task.deadline) : null;

    startDateText = task.startDate != null
        ? formatedDateFromString(now: now, stringDate: task.startDate).obs
        : ''.obs;
    dueDateText = task.deadline != null
        ? formatedDateFromString(now: now, stringDate: task.deadline).obs
        : ''.obs;
  }

  @override
  void changeTitle(String newText) => title.value = newText;
  void changeStatus(Status status) => newStatus.value = status;

  @override
  void confirmDescription(String newText) {
    descriptionController.value.text = newText;
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
          descriptionController.value.text = task.description;
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
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
    selectedMilestoneTitle.value = tr('none');
  }

  @override
  void changeStartDate(DateTime newDate) {
    if (newDate != null) {
      // ignore: omit_local_variable_types
      bool verificationResult = checkDate(newDate, _newDueDate);
      if (verificationResult) {
        startDateText.value = formatedDate(newDate);
        _newStartDate = newDate;
        Get.back();
      }
    } else {
      startDateText.value = '';
      _newStartDate = null;
    }
  }

  @override
  void changeDueDate(DateTime newDate) {
    if (newDate != null) {
      // ignore: omit_local_variable_types
      bool verificationResult = checkDate(_newStartDate, newDate);
      if (verificationResult) {
        dueDateText.value = formatedDate(newDate);
        _newDueDate = newDate;
        Get.back();
      }
    } else {
      dueDateText.value = '';
      _newDueDate = null;
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

  @override
  void changePriority(bool value) => highPriority.value = value;

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
      teamController.projectId = task.projectOwner.id;

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

  void discardChanges() {
    bool taskEdited;
    // checking all fields for changes
    taskEdited = title.value != task.title ||
        descriptionText.value != task.description ||
        newMilestoneId != task.milestoneId ||
        initialStatus.id != newStatus.value.id ||
        task.responsibles.length != responsibles.length;

    var i = 0;
    while (!taskEdited && responsibles.length > i) {
      if (responsibles[i].portalUser.id != task.responsibles[i].id) {
        taskEdited = true;
      }
      i++;
    }

    // warn the user if there have been changes
    if (taskEdited) {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('changesWillBeLost'),
        acceptText: tr('discard'),
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

  void confirm() async {
    if (title.isEmpty || task.title == null) {
      setTitleError.value = true;
    } else {
      // update the task status if it has been changed
      if (initialStatus.id != newStatus.value.id) {
        await _taskItemController.tryChangingStatus(
            id: task.id,
            newStatusId: newStatus.value.id,
            newStatusType: newStatus.value.statusType);
      }
      // ignore: omit_local_variable_types
      List<String> responsibleIds = [];

      for (var item in responsibles) responsibleIds.add(item.id);
      var newTask = NewTaskDTO(
        description: descriptionText.value,
        deadline: _newDueDate,
        id: task.id,
        startDate: _newStartDate,
        priority: highPriority.value == true ? 'high' : 'normal',
        title: title.value,
        milestoneid: newMilestoneId,
        projectId: task.projectOwner.id,
        responsibles: responsibleIds,
      );

      var updatedTask = await _api.updateTask(newTask: newTask);

      if (updatedTask != null) {
        // ignore: unawaited_futures
        _taskItemController.reloadTask(showLoading: true);
        Get.back();
      }
    }
  }
}
