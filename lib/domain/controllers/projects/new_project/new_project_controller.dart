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

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:darq/darq.dart';

import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';

import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class NewProjectController extends GetxController {
  final _api = locator<ProjectService>();
  final _userService = locator<UserService>();
  var usersDataSourse = Get.find<UsersDataSource>();
  var multipleSelectionEnabled = false;

  final _userController = Get.find<UserController>();
  var usersLoaded = false.obs;

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  var responsiblesNotificationEnabled = false;
  var responsible = '';

  var notificationEnabled = false.obs;
  var isPrivate = true.obs;
  var isFolowed = false.obs;
  var descriptionText = ''.obs;
  var selectedTeamMembers = <PortalUserItemController>[].obs;

  PortalUser selectedProjectManager;
  var needToFillManager = false.obs;
  var needToFillTitle = false.obs;

  var isPMSelected = false.obs;
  var managerName = ''.obs;

  PortalUserItemController selfUserItem;

  NewProjectController() {
    multipleSelectionEnabled = false;
    responsible = '';
  }

  String get teamMembersTitle => selectedTeamMembers.length == 1
      ? selectedTeamMembers.first.displayName
      : '${selectedTeamMembers.length} members';

  Future<void> confirm() async {
    if (titleController.text.isEmpty) {
      needToFillTitle.value = true;
    }
    if (selectedProjectManager == null) {
      needToFillManager.value = true;
    }

    if (needToFillTitle.isTrue || needToFillManager.isTrue) return;

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

    var newProject = NewProjectDTO(
        title: titleController.text,
        description: descriptionController.text,
        responsibleId: selectedProjectManager.id,
        participants: participants,
        private: isPrivate.value,
        notify: notificationEnabled.value,
        notifyResponsibles: responsiblesNotificationEnabled);

    var success = await _api.createProject(project: newProject);
    if (success) Get.back();
  }

  void confirmDescription() {
    descriptionText.value = descriptionController.text;
    Get.back();
  }

  void folow(bool value) {
    isFolowed.value = value;
  }

  void setPrivate(bool value) {
    isPrivate.value = value;
  }

  void enableNotification(bool value) {
    notificationEnabled.value = value;
  }

  bool canPopBack() {
    // if (descriptionText.value == descriptionController.text) {
    return true;
    // } else {
    // ConfirmDialog.show(
    //   title: 'Discard description?',
    //   message: 'Your changes will not be saved.',
    //   textCancel: 'CANCEL',
    //   textConfirm: 'DELETE',
    //   confirmFunction: () => Get.back(),
    //   cancelFunction: deleteDescription,
    // );
    //   return false;
    // }
  }

  void deleteDescription() {
    descriptionText.value = descriptionController.text = '';
    Get.back();
  }

  void changePMSelection(PortalUserItemController user) {
    if (user.isSelected.isTrue) {
      selectedProjectManager = user.portalUser;
      managerName.value = selectedProjectManager.displayName;
      isPMSelected.value = true;

      for (var element in usersDataSourse.usersList) {
        element.isSelected.value =
            element.portalUser.id == selectedProjectManager.id;
      }
      selfUserItem.isSelected.value =
          selfUserItem.portalUser.id == selectedProjectManager.id;

      Get.back();
    } else {
      removeManager();
    }
  }

  void removeManager() {
    managerName.value = '';
    selectedProjectManager = null;
    isPMSelected.value = false;

    for (var element in usersDataSourse.usersList) {
      element.isSelected.value = false;
    }
    selfUserItem.isSelected.value = false;
  }

  void selectTeamMember(PortalUserItemController user) {
    if (user.isSelected.isTrue) {
      selectedTeamMembers.add(user);
    } else {
      selectedTeamMembers.removeWhere(
          (element) => user.portalUser.id == element.portalUser.id);
    }
    if (selfUserItem.portalUser.id == user.portalUser.id) {
      selfUserItem.isSelected.value = user.isSelected.value;
    }
  }

  void editTeamMember() {
    if (selectedTeamMembers.length == 1) {
      selectedTeamMembers.clear();
    } else {
      Get.toNamed('TeamMembersSelectionView');
    }
  }

  Future<void> setupTeamMembers() async {
    for (var element in usersDataSourse.usersList) {
      element.isSelected.value = false;
      element.multipleSelectionEnabled.value = multipleSelectionEnabled;
    }

    for (var selectedMember in selectedTeamMembers) {
      for (var user in usersDataSourse.usersList) {
        if (selectedMember.portalUser.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      }
      if (selfUserItem.portalUser.id == selectedMember.portalUser.id) {
        selfUserItem.isSelected.value = selectedMember.isSelected.value;
      }
    }
  }

  Future<void> setupPMSelection() async {
    for (var element in usersDataSourse.usersList) {
      element.isSelected.value =
          element.portalUser.id == selectedProjectManager?.id;
      element.multipleSelectionEnabled.value = multipleSelectionEnabled;
    }

    if (selfUserItem?.portalUser?.id == selectedProjectManager?.id) {
      selfUserItem.isSelected.value = true;
    }
  }

  void confirmTeamMembers() {
    Get.back();
  }

  Future<void> setupUsersSelection() async {
    usersLoaded.value = false;

    await _userController.getUserInfo();
    var selfUser = _userController.user;
    selfUserItem = PortalUserItemController(portalUser: selfUser);
    selfUserItem.multipleSelectionEnabled.value = multipleSelectionEnabled;

    if (multipleSelectionEnabled) {
      usersDataSourse.applyUsersSelection = setupTeamMembers;
    } else {
      usersDataSourse.applyUsersSelection = setupPMSelection;
    }

    await usersDataSourse.getProfiles(needToClear: true);

    usersLoaded.value = true;
  }

  var selectedGroups = <PortalGroupItemController>[];
  void selectGroupMembers(PortalGroupItemController group) {
    if (group.isSelected.isTrue) {
      selectedGroups.add(group);
    } else {
      selectedGroups.removeWhere(
          (element) => group.portalGroup.id == element.portalGroup.id);
    }
  }

  void confirmGroupSelection() async {
    for (var group in selectedGroups) {
      var groupMembers = await _userService.getProfilesByExtendedFilter(
          groupId: group.portalGroup.id);

      if (groupMembers.response.isNotEmpty) {
        for (var element in groupMembers.response) {
          var user = PortalUserItemController(portalUser: element);
          user.isSelected.value = true;
          selectedTeamMembers.add(user);
        }
      }
    }

    selectedTeamMembers.value =
        selectedTeamMembers.distinct((d) => d.portalUser.id).toList();
    await setupTeamMembers();

    await usersDataSourse.updateUsers();

    Get.back();
  }
}
