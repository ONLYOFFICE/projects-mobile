import 'package:get/get.dart';
import 'package:projects/data/api/tasks_api.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class TaskItemService {
  final TaskApi _api = locator<TaskApi>();

  var portalTask = PortalTask().obs;

  Future getTaskByID({int id}) async {
    var task = await _api.getTaskByID(id: id);
    var success = task.response != null;

    if (success) {
      return task.response;
    } else {
      ErrorDialog.show(task.error);
      return null;
    }
  }

  Future updateTaskStatus(
      {int taskId, int newStatusId, int newStatusType}) async {
    var task = await _api.updateTaskStatus(
        taskId: taskId, newStatusId: newStatusId, newStatusType: newStatusType);

    var success = task.response != null;

    if (success) {
      return task.response;
    } else {
      ErrorDialog.show(task.error);
      return null;
    }
  }

  Future deleteTask({int taskId}) async {
    var task = await _api.deleteTask(taskId: taskId);
    var success = task.response != null;

    if (success) {
      return task.response;
    } else {
      ErrorDialog.show(task.error);
      return null;
    }
  }

  Future subscribeToTask({int taskId}) async {
    var task = await _api.subscribeToTask(taskId: taskId);
    var success = task.response != null;

    if (success) {
      return task.response;
    } else {
      ErrorDialog.show(task.error);
      return null;
    }
  }
}
