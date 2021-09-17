import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';

import 'package:projects/data/models/new_project_DTO.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/project_detailed/project_detailed_view.dart';
import 'package:projects/presentation/views/project_detailed/tags_selection_view.dart';

class NewProjectController extends BaseProjectEditorController {
  final _api = locator<ProjectService>();

  NewProjectController() {
    selectionMode = UserSelectionMode.Single;
    titleFocus.requestFocus();
    responsible = '';
  }

  void discardChanges() {
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
  }

  Future<void> confirm(context) async {
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

    var result = await _api.createProject(project: newProject);
    if (result != null) {
      locator<EventHub>().fire('needToRefreshProjects');

      MessagesHandler.showSnackBar(
        context: context,
        text: tr('projectCreated'),
        buttonOnTap: () => Get.find<NavigationController>()
            .to(ProjectDetailedView(), arguments: {'projectDetailed': result}),
        buttonText: tr('open').toUpperCase(),
      );
      Get.back();
    }
  }

  Future<void> showTags() async {
    // ignore: unawaited_futures
    Get.find<NavigationController>()
        .toScreen(const TagsSelectionView(), arguments: {'controller': this});
  }
}
