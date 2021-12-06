/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/new_task_DTO.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/data/services/task/task_item_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/project_team_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/tasks/task_editing_controller.dart';
import 'package:projects/domain/controllers/tasks/task_status_handler.dart';
import 'package:projects/domain/controllers/tasks/task_statuses_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/internal/utils/name_formatter.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/task_status_bottom_sheet.dart';
import 'package:projects/presentation/views/project_detailed/project_detailed_view.dart';
import 'package:projects/presentation/views/task_detailed/task_detailed_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TaskItemController extends GetxController {
  final _api = locator<TaskItemService>();

  var task = PortalTask().obs;
  var status = Status().obs;

  var loaded = false.obs;
  var isStatusLoaded = false.obs;

  RefreshController get refreshController {
    return RefreshController();
  }

  RefreshController get subtaskRefreshController {
    return RefreshController();
  }

  RefreshController get commentsRefreshController {
    return RefreshController();
  }

  set setLoaded(bool value) => loaded.value = value;

  final TaskStatusHandler _statusHandler = TaskStatusHandler();

  bool get canEdit => task.value.canEdit && task.value.status != 2;

  Color get getStatusBGColor =>
      _statusHandler.getBackgroundColor(status.value, task.value.canEdit);

  Color get getStatusTextColor =>
      _statusHandler.getTextColor(status.value, task.value.canEdit);

  String get displayName {
    if (task.value.responsibles.isEmpty) return tr('noResponsible');
    if (task.value.responsibles.length > 1)
      return plural('responsibles', task.value.responsibles.length);
    return NameFormatter.formateName(task.value.responsibles[0]);
  }

  // to show overview screen without loading
  RxBool firstReload = true.obs;

  var commentsListController = ScrollController();

  StreamSubscription _refreshParentTaskSubscription;
  StreamSubscription _scrollToLastCommentSubscription;

  TaskItemController(PortalTask portalTask) {
    task.value = portalTask;

    _refreshParentTaskSubscription =
        locator<EventHub>().on('needToRefreshParentTask', (dynamic data) async {
      if ((data as List).isNotEmpty && data[0] == task.value.id) {
        var showLoading = (data as List).length > 1 ? data[1] : false;
        await reloadTask(showLoading: showLoading);
      }
    });

    _scrollToLastCommentSubscription =
        locator<EventHub>().on('scrollToLastComment', (dynamic data) async {
      if ((data as List).isNotEmpty && data[0] == task.value.id) {
        scrollToLastComment();
      }
    });
  }

  @override
  void onClose() {
    _refreshParentTaskSubscription.cancel();
    _scrollToLastCommentSubscription.cancel();
    super.onClose();
  }

  void scrollToLastComment() {
    if (commentsListController.hasClients)
      commentsListController
          .jumpTo(commentsListController.position.maxScrollExtent);
  }

  dynamic get getActualCommentCount {
    if (task?.value?.comments == null) return null;
    return countCommentsAndReplies(task?.value?.comments);
  }

  int countCommentsAndReplies(List<PortalComment> comments) {
    var count = 0;
    if (comments.isNotEmpty)
      for (var comment in comments) {
        count += countCommentsAndReplies(comment.commentList);
        if (!comment.inactive) count++;
      }

    return count;
  }

  void copyLink({@required taskId, @required projectId}) async {
    var link = await _api.getTaskLink(taskId: taskId, projectId: projectId);
    await Clipboard.setData(ClipboardData(text: link));
  }

  Future accept(context) async {
    var controller = Get.put(TaskEditingController(task: task.value));
    controller.addResponsible(
      PortalUserItemController(
        isSelected: true.obs,
        portalUser: Get.find<UserController>().user,
      ),
    );
    await controller.acceptTask(context);
  }

  Future copyTask({PortalTask portalTask}) async {
    var responsibleIds = <String>[];

    var taskFrom = portalTask ?? task.value;

    for (var item in taskFrom.responsibles) responsibleIds.add(item.id);

    var newTask = NewTaskDTO(
      deadline:
          taskFrom.deadline != null ? DateTime.parse(taskFrom.deadline) : null,
      startDate: taskFrom.startDate != null
          ? DateTime.parse(taskFrom.startDate)
          : null,
      description: taskFrom.description,
      milestoneid: taskFrom.milestoneId,
      priority: taskFrom.priority == 1 ? 'high' : 'normal',
      projectId: taskFrom.projectOwner.id,
      responsibles: responsibleIds,
      title: taskFrom.title,
      copyFiles: true,
      copySubtasks: true,
    );

    var copiedTask =
        await _api.copyTask(copyFrom: task.value.id, newTask: newTask);

    locator<EventHub>().fire('needToRefreshTasks');

    var newTaskController =
        Get.put(TaskItemController(copiedTask), tag: copiedTask.id.toString());

    Get.find<NavigationController>()
        .to(TaskDetailedView(), arguments: {'controller': newTaskController});
  }

  Future<void> initTaskStatus(PortalTask portalTask) async {
    isStatusLoaded.value = false;
    var statusesController = Get.find<TaskStatusesController>();
    Status receivedStatus = await statusesController.getTaskStatus(portalTask);
    if (receivedStatus != null && !receivedStatus.isNull) {
      status.value = receivedStatus;
      isStatusLoaded.value = true;
    }
  }

  Future reloadTask({bool showLoading = false}) async {
    if (showLoading) loaded.value = false;
    var t = await _api.getTaskByID(id: task.value.id);
    if (t != null) {
      task.value = t;
      await initTaskStatus(task.value);
    }

    var team = Get.find<ProjectTeamController>()
      ..setup(projectId: task.value.projectOwner.id);

    await team.getTeam();
    var responsibles = team.usersList
        .where((user) =>
            task.value.responsibles.any((element) => user.id == element.id))
        .toList();
    task.value.responsibles.clear();
    for (var user in responsibles) {
      task.value.responsibles.add(user.portalUser);
    }

    if (showLoading) loaded.value = true;
  }

  void openStatuses(context) {
    if (task.value.canEdit && isStatusLoaded.isTrue)
      showsStatusesBS(context: context, taskItemController: this);
  }

  Future<void> tryChangingStatus({
    int id,
    int newStatusId,
    int newStatusType,
  }) async {
    if (newStatusId == status?.value?.id) return;

    if (newStatusType == 2 &&
        task.value.status != newStatusType &&
        task.value.hasOpenSubtasks) {
      await Get.dialog(StyledAlertDialog(
        titleText: tr('closingTask'),
        contentText: tr('closingTaskWithActiveSubtasks'),
        acceptText: tr('closeTask').toUpperCase(),
        onAcceptTap: () async {
          await _changeTaskStatus(
              id: id, newStatusId: newStatusId, newStatusType: newStatusType);
          Get.back();
        },
      ));
    } else {
      await _changeTaskStatus(
          id: id, newStatusId: newStatusId, newStatusType: newStatusType);
    }
  }

  Future _changeTaskStatus({int id, int newStatusId, int newStatusType}) async {
    loaded.value = false;
    var t = await _api.updateTaskStatus(
        taskId: id, newStatusId: newStatusId, newStatusType: newStatusType);

    if (t != null) {
      var newTask = PortalTask.fromJson(t);
      task.value = newTask;
      await initTaskStatus(newTask);

      locator<EventHub>().fire('needToRefreshTasks');
    }
    loaded.value = true;
  }

  Future deleteTask({@required int taskId}) async {
    var r = await _api.deleteTask(taskId: taskId);
    return r != null;
  }

  Future subscribeToTask({@required int taskId}) async {
    var r = await _api.subscribeToTask(taskId: taskId);
    return r != null;
  }

  void handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) {
      update();
    }
  }

  void toProjectOverview() async {
    var projectService = locator<ProjectService>();
    var project = await projectService.getProjectById(
      projectId: task.value.projectOwner.id,
    );
    if (project != null)
      Get.find<NavigationController>().to(
        ProjectDetailedView(),
        arguments: {'projectDetailed': project},
      );
  }
}
