import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';

import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/models/project_status.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/project_detailed/tags_selection_view.dart';

class ProjectEditController extends BaseProjectEditorController {
  final _projectService = locator<ProjectService>();

  var loaded = true.obs;
  var isSearchResult = false.obs;
  var nothingFound = false.obs;
  var projectTitleText = ''.obs;
  var statusText = ''.obs;
  var selectedTags;

  EditProjectDTO oldProjectDTO;

  ProjectDetailed _projectDetailed;
  ProjectDetailed get projectData => _projectDetailed;

  Future<void> setupEditor(projectDetailed) async {
    _projectDetailed = projectDetailed;
    loaded.value = false;

    oldProjectDTO = null;
    statusText.value = tr('projectStatus',
        args: [ProjectStatus.toName(_projectDetailed.status)]);

    projectTitleText.value = _projectDetailed.title;
    descriptionText.value = _projectDetailed.description;

    isPrivate.value = _projectDetailed.isPrivate;

    var projectById =
        await _projectService.getProjectById(projectId: _projectDetailed.id);
    tags.clear();
    if (projectById?.tags != null) {
      for (var value in projectById?.tags) {
        tags.add(value);
      }
    }

    tagsText.value = tags.join(', ');

    titleController.text = _projectDetailed.title;
    descriptionController.text = _projectDetailed.description ?? '';
    selectedProjectManager.value = _projectDetailed.responsible;

    isPMSelected.value = true;
    managerName.value = selectedProjectManager.value.displayName;

    var projectTeamDataSource = Get.put(ProjectTeamController());
    projectTeamDataSource.projectId = projectDetailed.id;
    await projectTeamDataSource.getTeam();

    if (selectedTeamMembers.isNotEmpty) selectedTeamMembers.clear();
    for (var portalUser in projectTeamDataSource.usersList) {
      portalUser.selectionMode.value = UserSelectionMode.Multiple;
      portalUser.isSelected.value = true;
      selectedTeamMembers.add(portalUser);
    }
    selectedTeamMembers.removeWhere(
        (element) => element.portalUser.id == selectedProjectManager.value.id);

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

    oldProjectDTO = EditProjectDTO(
      title: titleController.text,
      description: descriptionController.text,
      responsibleId: selectedProjectManager.value.id,
      participants: participants,
      private: isPrivate.value,
      status: _projectDetailed.status,
      tags: tagsText.value,
    );

    loaded.value = true;
  }

  Future updateStatus({int newStatusId}) async {
    _projectDetailed.status = newStatusId;
    statusText.value = tr('projectStatus',
        args: [ProjectStatus.toName(_projectDetailed.status)]);
  }

  Future<void> confirmChanges() async {
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

    var newProject = EditProjectDTO(
      title: titleController.text,
      description: descriptionController.text,
      responsibleId: selectedProjectManager.value.id,
      participants: participants,
      private: isPrivate.value,
      status: _projectDetailed.status,
      tags: tagsText.value,
      notify: notificationEnabled.value,
    );

    var success = await _projectService.editProject(
        project: newProject, projectId: _projectDetailed.id);
    if (success) {
      {
        locator<EventHub>().fire('needToRefreshProjects');
      }

      Get.back();
    }
  }

  void discardChanges() {
    bool edited;
    // checking all fields for changes
    edited = oldProjectDTO.title != titleController.text ||
        oldProjectDTO.description != descriptionController.text ||
        oldProjectDTO.responsibleId != selectedProjectManager.value?.id ||
        oldProjectDTO.private != isPrivate.value ||
        oldProjectDTO.status != _projectDetailed.status ||
        tagsText.value != tagsText.value;

    var i = 0;
    while (!edited && oldProjectDTO.participants.length > i) {
      if (oldProjectDTO.participants[i].iD !=
          selectedTeamMembers[i].portalUser.id) {
        edited = true;
      }
      i++;
    }

    // warn the user if there have been changes
    if (edited) {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('changesWillBeLost'),
        acceptText: tr('discard'),
        onAcceptTap: () {
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    } else {
      //leave
      Get.back();
    }
  }

  Future<void> showTags() async {
    await Get.find<NavigationController>()
        .toScreen(const TagsSelectionView(), arguments: {'controller': this});
  }
}
