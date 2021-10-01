import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/services/task/subtasks_service.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_action_controller.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtask_detailed_view.dart';

class NewSubtaskController extends GetxController
    implements SubtaskActionController {
  Subtask subtask;

  final _api = locator<SubtasksService>();

  ProjectTeamController teamController;

  final _titleController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();

  @override
  TextEditingController get titleController => _titleController;
  @override
  FocusNode get titleFocus => _titleFocus;
  RxList responsibles = [].obs;
  @override
  RxInt status = 1.obs;
  @override
  RxBool setTiltleError = false.obs;

  List _previusSelectedResponsible = [];

  @override
  void init({Subtask subtask, int projectId}) {
    teamController = Get.find<ProjectTeamController>();

    _titleFocus.requestFocus();
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
    if (user.isSelected == true) {
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
    if (responsibles.isNotEmpty || _titleController.text.isNotEmpty) {
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
  Future<void> confirm({context, @required int taskId}) async {
    if (titleController.text.isEmpty)
      setTiltleError.value = true;
    else {
      var responsible =
          responsibles.isEmpty ? null : responsibles[0]?.portalUser?.id;

      var data = {'responsible': responsible, 'title': _titleController.text};
      var newSubtask = await _api.createSubtask(taskId: taskId, data: data);
      if (newSubtask != null) {
        var taskController =
            Get.find<TaskItemController>(tag: taskId.toString());

        Get.back();
        await taskController.reloadTask(showLoading: true);
        MessagesHandler.showSnackBar(
            context: Get.context,
            text: tr('subtaskCreated'),
            buttonText: tr('open').toUpperCase(),
            buttonOnTap: () {
              var controller = Get.put(
                  SubtaskController(
                      subtask: newSubtask,
                      parentTask: taskController.task.value),
                  tag: newSubtask.hashCode.toString());
              return Get.find<NavigationController>().to(
                  const SubtaskDetailedView(),
                  arguments: {'controller': controller});
            });
      }
    }
  }
}
