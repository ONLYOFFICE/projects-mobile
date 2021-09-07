import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/new_task_DTO.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/data/services/task/task_item_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/widgets/task_status_bottom_sheet.dart';
import 'package:projects/presentation/views/project_detailed/project_detailed_view.dart';
import 'package:projects/presentation/views/task_detailed/task_detailed_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TaskItemController extends GetxController {
  final _api = locator<TaskItemService>();

  var task = PortalTask().obs;
  var status = Status().obs;

  var loaded = true.obs;
  var refreshController = RefreshController();

  // ignore: unnecessary_cast
  var statusImage = (const SizedBox(
    width: 16,
    height: 16,
    child: Center(child: CircularProgressIndicator()),
  ) as Widget)
      .obs;

  // to show overview screen without loading
  RxBool firstReload = true.obs;

  var commentsListController = ScrollController();

  void scrollToLastComment() {
    commentsListController
        .jumpTo(commentsListController.position.maxScrollExtent);
  }

  // ignore: always_declare_return_types
  get getActualCommentCount {
    if (task?.value?.comments == null) return null;
    var count = 0;
    for (var item in task?.value?.comments) {
      if (!item.inactive) count++;
    }
    return count;
  }

  TaskItemController(PortalTask task) {
    this.task.value = task;
    initTaskStatus(task);
  }

  void copyLink({@required taskId, @required projectId}) async {
    // ignore: omit_local_variable_types
    String link = await _api.getTaskLink(taskId: taskId, projectId: projectId);
    print(link);
    await Clipboard.setData(ClipboardData(text: link));
  }

  Future copyTask({PortalTask taskk}) async {
    // ignore: omit_local_variable_types
    List<String> responsibleIds = [];

    // ignore: omit_local_variable_types
    PortalTask taskFrom = taskk ?? task.value;

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

    // ignore: unawaited_futures
    Get.find<TasksController>().loadTasks();

    var newTaskController =
        Get.put(TaskItemController(copiedTask), tag: copiedTask.id.toString());

    Get.find<NavigationController>()
        .to(TaskDetailedView(), arguments: {'controller': newTaskController});
    // return copiedTask;
  }

  void initTaskStatus(PortalTask task) {
    var statusesController = Get.find<TaskStatusesController>();
    status.value = statusesController.getTaskStatus(task);
    if (status.value == null) return;

    // ignore: unnecessary_cast
    statusImage.value = (SVG.createSizedFromString(
        statusesController.decodeImageString(status.value?.image),
        16,
        16,
        status.value.color) as Widget);
  }

  Future reloadTask({bool showLoading = false}) async {
    if (showLoading) loaded.value = false;
    var t = await _api.getTaskByID(id: task.value.id);
    if (t != null) task.value = t;
    if (showLoading) loaded.value = true;
  }

  void tryChangingStatus(context) {
    if (task.value.canEdit) {
      showsStatusesBS(context: context, taskItemController: this);
    }
  }

  Future updateTaskStatus({int id, int newStatusId, int newStatusType}) async {
    loaded.value = false;
    var t = await _api.updateTaskStatus(
        taskId: id, newStatusId: newStatusId, newStatusType: newStatusType);
    if (t != null) {
      var newTask = PortalTask.fromJson(t);
      task.value = newTask;
      initTaskStatus(newTask);
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
