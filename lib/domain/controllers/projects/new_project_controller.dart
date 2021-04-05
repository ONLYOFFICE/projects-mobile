import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_owner.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/internal/locator.dart';

class NewProjectController extends GetxController {
  final _api = locator<ProjectService>();

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  var responsiblesNotificationEnabled = false;

  var participants = [];
  var responsible = '';

  var notificationEnabled = false.obs;
  var isPrivate = true.obs;
  var isFolowed = false.obs;
  var descriptionText = ''.obs;

  var projectManager = ProjectOwner(id: 1).obs;

  var managerName = 'Sergey Petrov'.obs;
  var teamMembers = ['Esther Howard', 'Esther Howard'].obs;

  String get teamMembersTitle => teamMembers.length == 1
      ? teamMembers.first
      : '${teamMembers.length} members';

  void confirm() {
    var newProject = NewProjectDTO(
        title: titleController.text,
        description: titleController.text,
        responsibleId: responsible,
        participants: participants,
        private: isPrivate.value,
        notify: notificationEnabled.value,
        notifyResponsibles: responsiblesNotificationEnabled);

    _api.createProject(project: newProject);
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

  void removeManager() {
    projectManager.value = null;
  }

  void editTeamMember() {
    if (teamMembers.length == 1) {
      teamMembers.clear();
    } else {
      Get.toNamed('TeamMembersSelectionView');
    }
  }
}
