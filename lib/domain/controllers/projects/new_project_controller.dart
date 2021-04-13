import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/services/project_service.dart';

import 'package:projects/domain/controllers/projects/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/users_data_source.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class NewProjectController extends GetxController {
  final _api = locator<ProjectService>();
  // final _userService = locator<UserService>();
  var usersSearchController = Get.find<UsersDataSource>();
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

      usersSearchController.usersList.forEach((element) {
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

    usersSearchController.usersList.forEach((element) {
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
    usersSearchController.usersList.forEach((element) {
      element.isSelected.value = false;
      element.multipleSelectionEnabled.value = multipleSelectionEnabled;
    });

    selectedTeamMembers.forEach((selectedMember) {
      usersSearchController.usersList.forEach((user) {
        if (selectedMember.portalUser.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      });
      if (selfUserItem.portalUser.id == selectedMember.portalUser.id) {
        selfUserItem.isSelected.value = selectedMember.isSelected.value;
      }
    });
  }

  Future<void> setupPMSelection() async {
    usersSearchController.usersList.forEach((element) {
      element.isSelected.value =
          element.portalUser.id == selectedProjectManager?.id;
      element.multipleSelectionEnabled.value = multipleSelectionEnabled;
    });
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
      usersSearchController.presets = setupTeamMembers;
    } else {
      usersSearchController.presets = setupPMSelection;
    }

    await usersSearchController.getProfiles(needToClear: true);

    usersLoaded.value = true;
  }
}
