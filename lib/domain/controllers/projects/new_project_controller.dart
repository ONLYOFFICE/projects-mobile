import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/from_api/self_user_profile.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/projects/portal_user_item_controller.dart';
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
  PortalUserItemController selfUserItem;

  var allUsers = <PortalUserItemController>[];
  var selectedTeamMembers = <PortalUserItemController>[].obs;

  var needToFillTitle = false.obs;
  var needToFillManager = false.obs;

  var searchInputController = TextEditingController();

  var searchResult = <PortalUserItemController>[].obs;

  var nothingFound = false.obs;

  Future<void> getUsersInfo() async {
    usersLoaded.value = false;
    await _usersController.getAllProfiles();
    await _userController.getUserInfo();

    selfUser = _userController.user;

    allUsers.clear();
    _usersController.users.forEach((element) {
      allUsers.add(PortalUserItemController(portalUser: element));
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

  void changePMSelection(PortalUserItemController user) {
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

      Get.back();
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

  void selectTeamMember(PortalUserItemController user) {
    if (user.isSelected.isTrue) {
      selectedTeamMembers.add(user);
    } else {
      selectedTeamMembers.removeWhere(
          (element) => user.portalUser.id == element.portalUser.id);
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
    await getUsersInfo();
    allUsers.forEach((element) {
      element.isSelected.value = false;
      element.multipleSelectionEnabled.value = true;
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
      element.multipleSelectionEnabled.value = false;
    });
  }

  void newSearch(String value) {}

  void clearSearch() {
    searchResult.clear();
    searchInputController.clear();
    nothingFound.value = false;
  }

  void performSearch(String querry) async {
    nothingFound.value = false;
    searchResult.clear();

    allUsers.forEach((element) => {
          if (element.displayName.toLowerCase().contains(querry.toLowerCase()))
            {searchResult.add(element)}
        });
    nothingFound.value = searchResult.isEmpty;
  }

  void confirmTeamMembers() {
    Get.back();
  }
}
