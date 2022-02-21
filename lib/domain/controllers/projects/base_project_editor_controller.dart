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
import 'package:projects/data/models/from_api/project_detailed.dart';

import 'package:projects/data/services/user_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_members_view.dart';

abstract class BaseProjectEditorController extends GetxController {
  final UserService _userService = locator<UserService>();
  UsersDataSource usersDataSourse = Get.find<UsersDataSource>();
  UserSelectionMode selectionMode = UserSelectionMode.Single;
  RxList tags = [].obs;
  RxString tagsText = ''.obs;

  final _userController = Get.find<UserController>();
  RxBool usersLoaded = false.obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  RxString descriptionText = ''.obs;

  bool responsiblesNotificationEnabled = false;
  String responsible = '';

  RxBool notificationEnabled = false.obs;
  RxBool isPrivate = true.obs;
  RxBool isFolowed = false.obs;

  ProjectDetailed? get projectData;

  RxString statusText = ''.obs;

  Future<bool> updateStatus({int? newStatusId});

  RxList<PortalUserItemController> selectedTeamMembers = <PortalUserItemController>[].obs;

  Rx<PortalUser?> selectedProjectManager = PortalUser().obs;
  RxBool needToFillManager = false.obs;
  RxBool needToFillTitle = false.obs;

  RxBool isPMSelected = false.obs;
  RxString managerName = ''.obs;

  PortalUserItemController? selfUserItem;

  final FocusNode titleFocus = FocusNode();

  var titleIsEmpty = true.obs;

  @override
  void onInit() {
    _userController.getUserInfo().then((value) => {
          selfUserItem = PortalUserItemController(portalUser: _userController.user.value!),
        });

    titleController.addListener(() => {titleIsEmpty.value = titleController.text.isEmpty});

    super.onInit();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  String? get teamMembersTitle => selectedTeamMembers.length == 1
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
        acceptColor: Get.theme.colors().colorError,
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
    if (user.isSelected.value == true) {
      selectedProjectManager.value = user.portalUser;
      managerName.value = selectedProjectManager.value!.displayName!;
      isPMSelected.value = true;

      selectedTeamMembers
          .removeWhere((element) => selectedProjectManager.value!.id == element.portalUser.id);

      for (final element in usersDataSourse.usersList) {
        element.isSelected.value = element.portalUser.id == selectedProjectManager.value!.id;
      }
      selfUserItem!.isSelected.value =
          selfUserItem!.portalUser.id == selectedProjectManager.value!.id;

      selectedTeamMembers.removeWhere((element) => user.portalUser.id == element.portalUser.id);

      Get.back();
    } else {
      selectedTeamMembers.removeWhere((element) => user.portalUser.id == element.portalUser.id);
      removeManager();
    }
  }

  void removeManager() {
    selectedTeamMembers
        .removeWhere((element) => selectedProjectManager.value!.id == element.portalUser.id);
    managerName.value = '';
    selectedProjectManager.value = PortalUser();
    isPMSelected.value = false;

    for (final element in usersDataSourse.usersList) {
      element.isSelected.value = false;
    }
    selfUserItem!.isSelected.value = false;
  }

  void selectTeamMember(PortalUserItemController user) {
    if (user.isSelected.value == true) {
      selectedTeamMembers.add(user);
    } else {
      selectedTeamMembers.removeWhere((element) => user.portalUser.id == element.portalUser.id);
    }
    if (selfUserItem!.portalUser.id == user.portalUser.id) {
      selfUserItem!.isSelected.value = user.isSelected.value;
    }
  }

  void editTeamMember() {
    if (selectedTeamMembers.length == 1) {
      selectedTeamMembers.clear();
    } else {
      Get.find<NavigationController>()
          .toScreen(const TeamMembersSelectionView(), arguments: {'controller': this});
    }
  }

  Future<void> setupTeamMembers() async {
    for (final element in usersDataSourse.usersList) {
      element.isSelected.value = false;
    }

    for (final selectedMember in selectedTeamMembers) {
      for (final user in usersDataSourse.usersList) {
        if (selectedMember.portalUser.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      }
      if (selfUserItem!.portalUser.id == selectedMember.portalUser.id) {
        selfUserItem!.isSelected.value = true;
      }
    }
  }

  Future<void> setupPMSelection() async {
    for (final element in usersDataSourse.usersList) {
      element.isSelected.value = element.portalUser.id == selectedProjectManager.value?.id;
      element.selectionMode.value = selectionMode;
    }

    if (selfUserItem?.portalUser.id == selectedProjectManager.value?.id) {
      selfUserItem!.isSelected.value = true;
    }
  }

  Future<void> setupUsersSelection() async {
    usersLoaded.value = false;

    await _userController.getUserInfo();

    selfUserItem = PortalUserItemController(portalUser: _userController.user.value!);
    selfUserItem!.selectionMode.value = selectionMode;
    usersDataSourse.selfUserItem = selfUserItem;
    usersDataSourse.selectionMode = selectionMode;

    if (selectionMode == UserSelectionMode.Multiple) {
      usersDataSourse.selectionMode = UserSelectionMode.Multiple;
      usersDataSourse.applyUsersSelection = setupTeamMembers;
    } else {
      usersDataSourse.applyUsersSelection = setupPMSelection;
    }

    await usersDataSourse.getProfiles(needToClear: true, withoutSelf: true);

    usersLoaded.value = true;
  }

  var selectedGroups = <PortalGroupItemController>[];
  void selectGroupMembers(PortalGroupItemController group) {
    if (group.isSelected.value == true) {
      selectedGroups.add(group);
    } else {
      selectedGroups.removeWhere((element) => group.portalGroup!.id == element.portalGroup!.id);
    }
  }

  void confirmTeamMembers() {
    Get.back();
  }

  Future<void> confirmGroupSelection() async {
    for (final group in selectedGroups) {
      final groupMembers =
          await _userService.getProfilesByExtendedFilter(groupId: group.portalGroup!.id);

      if (groupMembers != null) {
        if (groupMembers.response!.isNotEmpty) {
          for (final element in groupMembers.response!) {
            final user = PortalUserItemController(portalUser: element);
            user.isSelected.value = true;
            selectedTeamMembers.add(user);
          }
        }
      }
    }

    selectedTeamMembers.value = selectedTeamMembers.distinct((d) => d.portalUser.id!).toList();
    await setupTeamMembers();

    await usersDataSourse.updateUsers();

    Get.back();
  }
}
