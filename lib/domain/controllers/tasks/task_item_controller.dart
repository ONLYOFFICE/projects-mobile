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
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/new_task_DTO.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/data/services/task/task_item_service.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
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
import 'package:synchronized/synchronized.dart';

class TaskItemController extends GetxController {
  final _api = locator<TaskItemService>();

  final task = PortalTask().obs;
  final status = Status().obs;

  final loaded = false.obs;
  final isStatusLoaded = false.obs;

  final documentsController = Get.find<DocumentsController>();

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

  final _statusHandler = TaskStatusHandler();

  bool get canEdit => task.value.canEdit! && task.value.status != 2;

  Color get getStatusBGColor =>
      _statusHandler.getBackgroundColor(status.value, task.value.canEdit!);

  Color get getStatusTextColor => _statusHandler.getTextColor(status.value, task.value.canEdit!);

  String? get displayName {
    if (task.value.responsibles!.isEmpty) return tr('noResponsible');
    if (task.value.responsibles!.length > 1) {
      return plural('responsibles', task.value.responsibles!.length);
    }
    return NameFormatter.formateName(task.value.responsibles![0]!);
  }

  // to show overview screen without loading
  final firstReload = true.obs;

  final commentsListController = ScrollController();

  final _ss = <StreamSubscription>[];
  final _toProjectOverviewLock = Lock();

  TaskItemController(PortalTask portalTask) {
    task.value = portalTask;

    setupTeam();

    documentsController.entityType = 'task';
    documentsController.setupFolder(folderId: task.value.id, folderName: task.value.title!);

    _ss.add(locator<EventHub>().on('needToRefreshParentTask', (dynamic data) async {
      if ((data as List).isNotEmpty && data[0] == task.value.id) {
        final showLoading = data.length > 1 ? data[1] as bool : false;
        await reloadTask(showLoading: showLoading);
      }
    }));

    _ss.add(locator<EventHub>().on('scrollToLastComment', (dynamic data) async {
      if ((data as List).isNotEmpty && data[0] == task.value.id) {
        scrollToLastComment();
      }
    }));
  }

  void setup(PortalTask portalTask) {
    task.value = portalTask;

    setupTeam();
  }

  @override
  void onClose() {
    for (final element in _ss) {
      element.cancel();
    }
    super.onClose();
  }

  void scrollToLastComment() {
    if (commentsListController.hasClients) {
      commentsListController.jumpTo(commentsListController.position.maxScrollExtent);
    }
  }

  int get getActualCommentCount {
    if (task.value.comments == null) {
      return 0;
    } else {
      return countCommentsAndReplies(task.value.comments!);
    }
  }

  int countCommentsAndReplies(List<PortalComment> comments) {
    var count = 0;
    if (comments.isNotEmpty)
      for (final comment in comments) {
        count += countCommentsAndReplies(comment.commentList!);
        if (!comment.inactive!) count++;
      }

    return count;
  }

  Future<void> copyLink({required int taskId, required int projectId}) async {
    final link = await _api.getTaskLink(taskId: taskId, projectId: projectId);

    if (link.isURL) {
      await Clipboard.setData(ClipboardData(text: link));
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('linkCopied'));
    } else
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
  }

  Future accept() async {
    final controller = Get.put(TaskEditingController(task: task.value));
    controller.addResponsible(
      PortalUserItemController(
        isSelected: true,
        portalUser: Get.find<UserController>().user.value!,
      ),
    );
    await controller.acceptTask();
  }

  Future copyTask({PortalTask? portalTask}) async {
    final responsibleIds = <String?>[];

    final taskFrom = portalTask ?? task.value;

    for (final item in taskFrom.responsibles!) {
      responsibleIds.add(item!.id);
    }

    final newTask = NewTaskDTO(
      deadline: taskFrom.deadline != null ? DateTime.parse(taskFrom.deadline!) : null,
      startDate: taskFrom.startDate != null ? DateTime.parse(taskFrom.startDate!) : null,
      description: taskFrom.description,
      milestoneid: taskFrom.milestoneId,
      priority: taskFrom.priority == 1 ? 'high' : 'normal',
      projectId: taskFrom.projectOwner!.id!,
      responsibles: responsibleIds,
      title: taskFrom.title,
      copyFiles: true,
      copySubtasks: true,
    );

    final copiedTask = await _api.copyTask(copyFrom: task.value.id!, newTask: newTask);

    if (copiedTask != null) {
      locator<EventHub>().fire('needToRefreshTasks', {'all': true});

      final newTaskController =
          Get.put(TaskItemController(copiedTask), tag: copiedTask.id.toString());

      await Get.find<NavigationController>()
          .to(const TaskDetailedView(), arguments: {'controller': newTaskController});
    }
  }

  Future<void> initTaskStatus(PortalTask? portalTask) async {
    isStatusLoaded.value = false;
    final statusesController = Get.find<TaskStatusesController>();
    await statusesController.getStatuses();
    final receivedStatus = await statusesController.getTaskStatus(portalTask);
    if (receivedStatus != null && !receivedStatus.isNull) {
      status.value = receivedStatus;
      isStatusLoaded.value = true;
    }
  }

  Future reloadTask({bool showLoading = false}) async {
    if (showLoading) loaded.value = false;
    final t = await _api.getTaskByID(id: task.value.id!);
    if (t != null) {
      task.value = t;

      unawaited(initTaskStatus(task.value));
      unawaited(documentsController.refreshContent());

      locator<EventHub>().fire('needToRefreshTasks', {'task': t});
    }

    await setupTeam();

    if (showLoading) loaded.value = true;
  }

  Future setupTeam() async {
    final team = Get.find<ProjectTeamController>()..setup(projectId: task.value.projectOwner!.id);

    await team.getTeam();
    final responsibles = team.usersList
        .where((user) => task.value.responsibles!.any((element) => user.id == element!.id))
        .toList();
    task.value.responsibles!.clear();
    for (final user in responsibles) {
      task.value.responsibles!.add(user.portalUser);
    }
  }

  void openStatuses(BuildContext context) {
    if (task.value.canEdit! && isStatusLoaded.isTrue) {
      if (Get.find<PlatformController>().isMobile)
        showsStatusesBS(context: context, taskItemController: this);
      else
        showsStatusesPM(context: context, taskItemController: this);
    }
  }

  Future<void> tryChangingStatus({
    required int id,
    required int newStatusId,
    required int newStatusType,
  }) async {
    if (newStatusId == status.value.id) return;

    if (newStatusType == 2) {
      await reloadTask();

      if (task.value.status != newStatusType) {
        if (task.value.hasOpenSubtasks) {
          await Get.find<NavigationController>().showPlatformDialog(StyledAlertDialog(
            titleText: tr('closingTask'),
            contentText: tr('closingTaskWithActiveSubtasks'),
            acceptText: tr('closeTask').toUpperCase(),
            onAcceptTap: () async {
              await _changeTaskStatus(
                  id: id, newStatusId: newStatusId, newStatusType: newStatusType);
              Get.back();
            },
          ));
        } else
          await _changeTaskStatus(id: id, newStatusId: newStatusId, newStatusType: newStatusType);
      }
    } else
      await _changeTaskStatus(id: id, newStatusId: newStatusId, newStatusType: newStatusType);
  }

  Future _changeTaskStatus(
      {required int id, required int newStatusId, required int newStatusType}) async {
    final t = await _api.updateTaskStatus(
        taskId: id, newStatusId: newStatusId, newStatusType: newStatusType);

    if (t != null) {
      final newTask = PortalTask.fromJson(t as Map<String, dynamic>);
      unawaited(initTaskStatus(newTask));

      locator<EventHub>().fire('needToRefreshTasks', {'task': newTask});
    } else
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
  }

  Future<bool> deleteTask({required int taskId}) async {
    final r = await _api.deleteTask(taskId: taskId);
    return r != null;
  }

  Future<bool> subscribeToTask({required int taskId}) async {
    final r = await _api.subscribeToTask(taskId: taskId);
    return r != null;
  }

  void handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) {
      update();
    }
  }

  Future<void> toProjectOverview() async {
    if (_toProjectOverviewLock.locked) return;

    unawaited(_toProjectOverviewLock.synchronized(() async {
      final projectService = locator<ProjectService>();
      final project = await projectService.getProjectById(
        projectId: task.value.projectOwner!.id!,
      );
      if (project != null) {
        unawaited(Get.find<NavigationController>().to(
          ProjectDetailedView(),
          arguments: {
            'projectDetailed': project,
            'previousPage': task.value.title,
          },
        ));
      }
    }));
  }
}
