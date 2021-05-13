import 'package:projects/data/api/subtasks_api.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class SubtasksService {
  final SubtasksApi _api = locator<SubtasksApi>();

  Future acceptSubtask({int taskId, int subtaskId, Map data}) async {
    var response = await _api.acceptSubtask(
        data: data, taskId: taskId, subtaskId: subtaskId);
    var success = response.response != null;

    if (success) {
      return response.response;
    } else {
      ErrorDialog.show(response.error);
      return null;
    }
  }

  Future deleteSubtask({int taskId, int subtaskId}) async {
    var response =
        await _api.deleteSubTask(taskId: taskId, subtaskId: subtaskId);
    var success = response.response != null;

    if (success) {
      return response.response;
    } else {
      ErrorDialog.show(response.error);
      return null;
    }
  }

  Future createSubtask({int taskId, Map data}) async {
    var response = await _api.createSubtask(taskId: taskId, data: data);
    var success = response.response != null;

    if (success) {
      return response.response;
    } else {
      ErrorDialog.show(response.error);
      return null;
    }
  }

  Future copySubtask({int taskId, int subtaskId}) async {
    var response = await _api.copySubtask(taskId: taskId, subtaskId: subtaskId);
    var success = response.response != null;

    if (success) {
      return response.response;
    } else {
      ErrorDialog.show(response.error);
      return null;
    }
  }

  Future updateSubtaskStatus({int taskId, int subtaskId, Map data}) async {
    var response = await _api.updateSubtaskStatus(
        taskId: taskId, subtaskId: subtaskId, data: data);
    var success = response.response != null;

    if (success) {
      return response.response;
    } else {
      ErrorDialog.show(response.error);
      return null;
    }
  }

  Future updateSubtask({int taskId, int subtaskId, Map data}) async {
    var response = await _api.updateSubtask(
      taskId: taskId,
      subtaskId: subtaskId,
      data: data,
    );

    var success = response.response != null;

    if (success) {
      return response.response;
    } else {
      ErrorDialog.show(response.error);
      return null;
    }
  }
}
