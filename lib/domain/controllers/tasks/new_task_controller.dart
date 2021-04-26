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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/new_task_DTO.dart';
import 'package:projects/data/services/task_service.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';

class NewTaskController extends GetxController {
  final _api = locator<TaskService>();
  var _selectedProjectId;
  var _selectedMilestoneId;
  // for dateTime format
  DateTime _startDate;
  DateTime _dueDate;

  int get selectedProjectId => _selectedProjectId;
  int get selectedMilestoneId => _selectedMilestoneId;
  DateTime get startDate => _startDate;
  DateTime get dueDate => _dueDate;

  final _userController = Get.find<UserController>();
  final _usersDataSource = Get.find<UsersDataSource>();
  PortalUserItemController selfUserItem;

  RxString title = ''.obs;
  RxString slectedProjectTitle = ''.obs;
  RxString slectedMilestoneTitle = ''.obs;

  RxString descriptionText = ''.obs;
  var descriptionController = TextEditingController().obs;
  // for readable format
  RxString startDateText = ''.obs;
  RxString dueDateText = ''.obs;

  RxList responsibles = [].obs;
  // to track changes
  List _previusSelectedResponsibles = [];
  RxBool highPriority = false.obs;
  RxBool notifyResponsibles = false.obs;

  RxBool selectProjectError = false.obs;
  RxBool setTitleError = false.obs;

  void changeTitle(String newText) => title.value = newText;

  void changeProjectSelection({var id, String title}) {
    if (id != null && title != null) {
      slectedProjectTitle.value = title;
      _selectedProjectId = id;
      selectProjectError.value = false;
    } else {
      removeProjectSelection();
    }
    Get.back();
  }

  void removeProjectSelection() {
    _selectedProjectId = null;
    slectedProjectTitle.value = '';
  }

  void changeMilestoneSelection({var id, String title}) {
    if (id != null && title != null) {
      slectedMilestoneTitle.value = title;
      _selectedMilestoneId = id;
    } else {
      removeMilestoneSelection();
    }
    Get.back();
  }

  void removeMilestoneSelection() {
    _selectedMilestoneId = null;
    slectedMilestoneTitle.value = '';
  }

  void changePriority(bool value) => highPriority.value = value;

  void changeNotifyResponsiblesValue(bool value) {
    notifyResponsibles.value = value;
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
        titleText: 'Discard changes?',
        contentText: 'If you leave, all changes will be lost.',
        acceptText: 'DELETE',
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
        titleText: 'Discard changes?',
        contentText: 'If you leave, all changes will be lost.',
        acceptText: 'DELETE',
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

  void setupResponsiblesSelection() async {
    await _userController.getUserInfo();
    var selfUser = _userController.user;
    selfUserItem = PortalUserItemController(portalUser: selfUser);
    selfUserItem.multipleSelectionEnabled.value = true;
    _usersDataSource.applyUsersSelection = _getSelectedResponsibles;
    await _usersDataSource.getProfiles(needToClear: true);
  }

  Future<void> _getSelectedResponsibles() async {
    for (var element in _usersDataSource.usersList) {
      element.isSelected.value = false;
      element.multipleSelectionEnabled.value = true;
    }
    for (var selectedMember in responsibles) {
      for (var user in _usersDataSource.usersList) {
        if (selectedMember.portalUser.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      }
      if (selfUserItem.portalUser.id == selectedMember.portalUser.id) {
        selfUserItem.isSelected.value = selectedMember.isSelected.value;
      }
    }
  }

  void addResponsible(PortalUserItemController user) {
    if (user.isSelected.isTrue) {
      responsibles.add(user);
    } else {
      responsibles.removeWhere(
          (element) => user.portalUser.id == element.portalUser.id);
    }
    if (selfUserItem.portalUser.id == user.portalUser.id) {
      selfUserItem.isSelected.value = user.isSelected.value;
    }
  }

  void changeStartDate(DateTime newDate) {
    if (newDate != null) {
      _startDate = newDate;
      startDateText.value =
          formatedDate(now: DateTime.now(), stringDate: newDate.toString());
      Get.back();
    }
  }

  void changeDueDate(DateTime newDate) {
    if (newDate != null) {
      _dueDate = newDate;
      dueDateText.value =
          formatedDate(now: DateTime.now(), stringDate: newDate.toString());
      Get.back();
    }
  }

  void confirm(BuildContext context) async {
    if (_selectedProjectId == null) selectProjectError.value = true;
    if (title.isEmpty) setTitleError.value = true;
    if (_selectedProjectId != null && title.isNotEmpty) {
      String priority;
      // ignore: omit_local_variable_types
      List<String> responsibleIds = [];

      if (highPriority.isTrue) priority = 'High';
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
          milestoneid: _selectedMilestoneId);

      print(newTask.toJson());
      var createdTask = await _api.addTask(newTask: newTask);
      var tasksController = Get.find<TasksController>();
      // ignore: unawaited_futures
      tasksController.reloadTasks();
      Get.back();
      ScaffoldMessenger.of(context)
          .showSnackBar(_snackBar(context, createdTask));
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
        titleText: 'Discard task?',
        contentText: 'Your changes will not be saved.',
        acceptText: 'DISCARD',
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

// TODO: make it shared
SnackBar _snackBar(context, PortalTask createdTask) {
  return SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Task had been created'),
        GestureDetector(
          onTap: () {
            var itemController = Get.put(TaskItemController(createdTask),
                tag: createdTask.id.toString());
            return Get.toNamed('TaskDetailedView',
                arguments: {'controller': itemController});
          },
          child: SizedBox(
            height: 16,
            width: 65,
            child: Center(
              child: Text(
                'OPEN',
                style: TextStyleHelper.button(
                        color: Theme.of(context)
                            .customColors()
                            .primary
                            .withOpacity(0.5))
                    .copyWith(height: 1),
              ),
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Theme.of(context).customColors().snackBarColor,
    padding: const EdgeInsets.only(top: 2, bottom: 2, left: 16, right: 10),
    margin: const EdgeInsets.only(left: 8, right: 8, bottom: 9),
    behavior: SnackBarBehavior.floating,
  );
}
