import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/services/task/subtasks_service.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_action_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class SubtaskEditingController extends GetxController
    implements SubtaskActionController {
  SubtaskEditingController(this.subtaskController);

  final subtaskController;
  final _api = locator<SubtasksService>();
  final _titleController = TextEditingController();
  Subtask _subtask;
  ProjectTeamController teamController;

  @override
  TextEditingController get titleController => _titleController;
  @override
  FocusNode get titleFocus => null;
  RxList responsibles = [].obs;
  @override
  RxInt status;
  @override
  RxBool setTiltleError = false.obs;
  // title befor editing
  String _previousTitle;
  // responsible id before editing
  String _previousResponsibleId;
  List _previusSelectedResponsible = [];

  @override
  void init({Subtask subtask, int projectId}) {
    _subtask = subtask;
    _previousTitle = subtask.title;
    _previousResponsibleId = subtask.responsible?.id;
    _titleController.text = subtask.title;

    teamController = Get.find<ProjectTeamController>();

    status = subtask.status.obs;
    if (_subtask.responsible != null) {
      _previusSelectedResponsible
          .add(PortalUserItemController(portalUser: _subtask.responsible));
      responsibles
          .add(PortalUserItemController(portalUser: _subtask.responsible));
    }
    setupResponsibleSelection(projectId);
  }

  void setupResponsibleSelection([int projectId]) async {
    if (teamController.usersList.isEmpty) {
      teamController.setup(projectId: projectId, withoutVisitors: true);

      await teamController
          .getTeam()
          .then((value) => _getSelectedResponsibles());
    } else {
      await _getSelectedResponsibles();
    }
  }

  Future<void> _getSelectedResponsibles() async {
    for (var element in teamController.usersList) {
      element.isSelected.value = false;
      element.selectionMode.value = UserSelectionMode.Single;
    }
    for (var selectedMember in responsibles) {
      for (var user in teamController.usersList) {
        if (selectedMember.portalUser.id == user.portalUser.id) {
          user.isSelected.value = true;
        }
      }
    }
  }

  @override
  void addResponsible(PortalUserItemController user) {
    // ignore: avoid_function_literals_in_foreach_calls
    teamController.usersList.forEach((element) {
      if (element.portalUser.id != user.id) element.isSelected.value = false;
    });
    responsibles.clear();
    if (user.isSelected.value == true) {
      responsibles.add(user);
    } else {
      responsibles.removeWhere(
          (element) => user.portalUser.id == element.portalUser.id);
    }
  }

  @override
  void confirmResponsiblesSelection() {
    // ignore: invalid_use_of_protected_member
    _previusSelectedResponsible = List.of(responsibles.value);
    Get.back();
  }

  @override
  void leaveResponsiblesSelectionView() {
    // ignore: invalid_use_of_protected_member
    if (listEquals(_previusSelectedResponsible, responsibles.value)) {
      Get.back();
    } else {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        onAcceptTap: () {
          responsibles.value = [_previusSelectedResponsible];
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    }
  }

  @override
  void deleteResponsible() => responsibles.clear();

  @override
  void leavePage() {
    var responsible;
    if (responsibles.isNotEmpty)
      responsible = responsibles[0]?.id;
    else
      responsible = null;

    if (responsible != _previousResponsibleId ||
        _titleController.text != _previousTitle) {
      Get.dialog(StyledAlertDialog(
        titleText: tr('discardChanges'),
        contentText: tr('lostOnLeaveWarning'),
        acceptText: tr('delete').toUpperCase(),
        onAcceptTap: () {
          Get.back();
          Get.back();
        },
        onCancelTap: Get.back,
      ));
    } else {
      Get.back();
    }
  }

  @override
  Future<void> confirm({context, int taskId}) async {
    if (titleController.text.isEmpty)
      setTiltleError.value = true;
    else {
      var responsible =
          responsibles.isEmpty ? null : responsibles[0]?.portalUser?.id;

      var data = {'responsible': responsible, 'title': _titleController.text};

      var editedSubtask = await _api.updateSubtask(
        taskId: _subtask.taskId,
        subtaskId: _subtask.id,
        data: data,
      );
      if (editedSubtask != null) {
        _subtask = editedSubtask;

        subtaskController.subtask.value = editedSubtask;
        // ignore: unawaited_futures
        Get.find<TaskItemController>(tag: editedSubtask.taskId.toString())
            .reloadTask();

        Get.back();
      }
    }
  }
}
