import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';

import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';

import 'package:projects/internal/locator.dart';

class NewProjectController extends BaseProjectEditorController {
  final _api = locator<ProjectService>();

  NewProjectController() {
    selectionMode = UserSelectionMode.Single;
    titleFocus.requestFocus();
    responsible = '';
  }

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
        responsibleId: selectedProjectManager.value.id,
        participants: participants,
        private: isPrivate.value,
        notify: notificationEnabled.value,
        notifyResponsibles: responsiblesNotificationEnabled);

    var success = await _api.createProject(project: newProject);
    if (success) Get.back();
  }
}
