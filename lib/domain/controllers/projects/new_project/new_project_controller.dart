import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';

import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/project_detailed/tags_selection_view.dart';

class NewProjectController extends BaseProjectEditorController {
  final _api = locator<ProjectService>();

  NewProjectController() {
    selectionMode = UserSelectionMode.Single;
    titleFocus.requestFocus();
    responsible = '';
  }

  Future<void> confirm() async {
    needToFillTitle.value = titleController.text.isEmpty;

    needToFillManager.value = (selectedProjectManager.value == null ||
        selectedProjectManager.value.id == null);

    if (needToFillTitle.value == true || needToFillManager.value == true)
      return;

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
    if (success) {
      // ignore: unawaited_futures
      Get.find<ProjectsController>(tag: 'ProjectsView').loadProjects();
      Get.back();
    }
  }

  Future<void> showTags() async {
    Get.find<NavigationController>()
        .toScreen(const TagsSelectionView(), arguments: {'controller': this});
  }
}
