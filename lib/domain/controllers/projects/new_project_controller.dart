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
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/self_user_profile.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/domain/controllers/users/users_controller.dart';
import 'package:projects/internal/locator.dart';

class NewProjectController extends GetxController {
  final _api = locator<ProjectService>();

  final _usersController = Get.find<UsersController>();
  final _userController = Get.find<UserController>();
  var usersLoaded = false.obs;

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  var responsiblesNotificationEnabled = false;

  var participants = [];
  var responsible = '';

  var notificationEnabled = false.obs;
  var isPrivate = true.obs;
  var isFolowed = false.obs;
  var descriptionText = ''.obs;

  PortalUser selectedProjectManager;
  var isPMSelected = false.obs;
  var managerName = ''.obs;

  SelfUserProfile selfUser;
  PortalUserItem selfUserItem;

  var allUsers = <PortalUserItem>[];
  var selectedTeamMembers = <PortalUserItem>[].obs;

  var needToFillTitle = false.obs;
  var needToFillManager = false.obs;

  Future<void> getUsersInfo() async {
    usersLoaded.value = false;
    await _usersController.getAllProfiles();
    await _userController.getUserInfo();

    selfUser = _userController.user;

    _usersController.users.forEach((element) {
      allUsers.add(PortalUserItem(portalUser: element));
    });

    selfUserItem =
        allUsers.firstWhere((element) => element.portalUser.id == selfUser.id);

    usersLoaded.value = true;
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

    selectedTeamMembers.forEach((element) {
      participants.add(
        Participant(
            iD: element.portalUser.id,
            canReadMessages: true,
            canReadFiles: true,
            canReadTasks: true,
            canReadContacts: true,
            canReadMilestones: true),
      );
    });

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

  void changePMSelection(PortalUserItem user) {
    if (user.isSelected.isTrue) {
      selectedProjectManager = user.portalUser;
      managerName.value = selectedProjectManager.displayName;
      isPMSelected.value = true;

      allUsers.forEach((element) {
        element.isSelected.value =
            element.portalUser.id == selectedProjectManager.id;
      });
      selfUserItem.isSelected.value =
          selfUserItem.portalUser.id == selectedProjectManager.id;
    } else {
      removeManager();
    }
  }

  void removeManager() {
    managerName.value = '';
    selectedProjectManager = null;
    isPMSelected.value = false;

    allUsers.forEach((element) {
      element.isSelected.value = false;
    });
    selfUserItem.isSelected.value = false;
  }

  void selectTeamMember(PortalUserItem user) {
    user.isSelected.isTrue
        ? selectedTeamMembers.add(user)
        : selectedTeamMembers.remove(user);
  }

  void editTeamMember() {
    if (selectedTeamMembers.length == 1) {
      selectedTeamMembers.clear();
    } else {
      Get.toNamed('TeamMembersSelectionView');
    }
  }

  Future<void> setupTeamMembers() async {
    await getUsersInfo();
    allUsers.forEach((element) {
      element.isSelected.value = false;
    });

    selectedTeamMembers.forEach((selectedMember) {
      allUsers.forEach((user) {
        if (selectedMember.portalUser.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      });
    });
  }

  Future<void> setupPMSelection() async {
    await getUsersInfo();
    allUsers.forEach((element) {
      element.isSelected.value =
          element.portalUser.id == selectedProjectManager?.id;
    });
  }
}

class PortalUserItem {
  PortalUserItem({
    this.portalUser,
  });
  final PortalUser portalUser;
  var isSelected = false.obs;

  String get displayName => portalUser.displayName;
}
