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

import 'package:darq/darq.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/portal_user.dart';

import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';

abstract class BaseProjectEditorController extends GetxController {
  final _userService = locator<UserService>();
  var usersDataSourse = Get.find<UsersDataSource>();
  var selectionMode = UserSelectionMode.Single;

  final _userController = Get.find<UserController>();
  var usersLoaded = false.obs;

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var descriptionText = ''.obs;

  var responsiblesNotificationEnabled = false;
  var responsible = '';

  var notificationEnabled = false.obs;
  var isPrivate = true.obs;
  var isFolowed = false.obs;

  var selectedTeamMembers = <PortalUserItemController>[].obs;

  Rx<PortalUser> selectedProjectManager = PortalUser().obs;
  var needToFillManager = false.obs;
  var needToFillTitle = false.obs;

  var isPMSelected = false.obs;
  var managerName = ''.obs;

  PortalUserItemController selfUserItem;

  final FocusNode titleFocus = FocusNode();

  @override
  void onInit() {
    _userController.getUserInfo().whenComplete(() => {
          selfUserItem =
              PortalUserItemController(portalUser: _userController.user),
        });

    super.onInit();
  }

  String get teamMembersTitle => selectedTeamMembers.length == 1
      ? selectedTeamMembers.first.displayName
      : plural('members', selectedTeamMembers.length);

  void confirmDescription(String newText) {
    descriptionText.value = descriptionController.text;
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
          descriptionController.text = descriptionText.value;
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
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

  void deleteDescription() {
    descriptionText.value = descriptionController.text = '';
    Get.back();
  }

  void changePMSelection(PortalUserItemController user) {
    if (user.isSelected.isTrue) {
      selectedProjectManager.value = user.portalUser;
      managerName.value = selectedProjectManager.value.displayName;
      isPMSelected.value = true;

      for (var element in usersDataSourse.usersList) {
        element.isSelected.value =
            element.portalUser.id == selectedProjectManager.value.id;
      }
      selfUserItem.isSelected.value =
          selfUserItem.portalUser.id == selectedProjectManager.value.id;

      selectedTeamMembers.removeWhere(
          (element) => user.portalUser.id == element.portalUser.id);

      Get.back();
    } else {
      removeManager();
    }
  }

  void removeManager() {
    managerName.value = '';
    selectedProjectManager.value = null;
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
      Get.toNamed('TeamMembersSelectionView', arguments: {'controller': this});
    }
  }

  Future<void> setupTeamMembers() async {
    for (var element in usersDataSourse.usersList) {
      element.isSelected.value = false;
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
          element.portalUser.id == selectedProjectManager?.value?.id;
      element.selectionMode.value = selectionMode;
    }

    if (selfUserItem?.portalUser?.id == selectedProjectManager?.value?.id) {
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
    selfUserItem.selectionMode.value = selectionMode;
    usersDataSourse.selectionMode = selectionMode;

    if (selectionMode == UserSelectionMode.Multiple) {
      usersDataSourse.selectionMode = UserSelectionMode.Multiple;
      usersDataSourse.applyUsersSelection = setupTeamMembers;
    } else {
      usersDataSourse.applyUsersSelection = setupPMSelection;
    }

    await usersDataSourse.getProfiles(needToClear: true);

    usersDataSourse.withoutSelf = true;
    usersDataSourse.selfUserItem = selfUserItem;

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

  Future<void> confirmGroupSelection() async {
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
