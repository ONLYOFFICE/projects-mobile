import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';

import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/detailed_project_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_team_datasource.dart';
import 'package:projects/internal/locator.dart';

class ProjectEditController extends BaseProjectEditorController {
  final _projectService = locator<ProjectService>();

  var loaded = true.obs;

  var projectTitleText = ''.obs;

  var tags = [].obs;
  var statusText = ''.obs;

  var tagsText = ''.obs;

  ProjectEditController(this.projectDetailed);

  ProjectDetailed projectDetailed;
  ProjectDetailed get projectData => projectDetailed;

  Future<void> setupEditor() async {
    statusText.value = tr('projectStatus',
        args: [ProjectStatus.toName(projectDetailed.status)]);

    projectTitleText.value = projectDetailed.title;
    descriptionText.value = projectDetailed.description;

    isPrivate.value = projectDetailed.isPrivate;
    await _projectService
        .getProjectById(projectId: projectDetailed.id)
        .then((value) => {
              if (value?.tags != null)
                {
                  tags.addAll(value.tags),
                  tagsText.value = value.tags.join(', '),
                }
            });

    titleController.text = projectDetailed.title;
    descriptionController.text = projectDetailed.description ?? '';
    selectedProjectManager = projectDetailed.responsible;

    isPMSelected.value = true;
    managerName.value = selectedProjectManager.displayName;

    var projectTeamDataSource = Get.put(ProjectTeamDataSource());
    projectTeamDataSource.projectDetailed = projectDetailed;
    await projectTeamDataSource.getTeam();

    if (selectedTeamMembers.isNotEmpty) selectedTeamMembers.clear();
    for (var portalUser in projectTeamDataSource.usersList) {
      portalUser.selectionMode.value = UserSelectionMode.Multiple;
      portalUser.isSelected.value = true;
      selectedTeamMembers.add(portalUser);
    }
  }

  Future updateStatus({int newStatusId}) async {
    projectDetailed.status = newStatusId;
    statusText.value = tr('projectStatus',
        args: [ProjectStatus.toName(projectDetailed.status)]);
  }

  Future<void> confirmChanges() async {
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

    var newProject = EditProjectDTO(
      title: titleController.text,
      description: descriptionController.text,
      responsibleId: selectedProjectManager.id,
      participants: participants,
      private: isPrivate.value,
      status: projectDetailed.status,
    );

    var success = await _projectService.editProject(
        project: newProject, projectId: projectDetailed.id);
    if (success) {
      await Get.find<ProjectDetailsController>().reloadInfo();

      Get.back();
    }
  }
}
