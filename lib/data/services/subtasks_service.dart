import 'package:projects/data/api/subtasks_api.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class SubtasksService {
  final SubtasksApi _api = locator<SubtasksApi>();

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
    var response = await _api.createSubTask(taskId: taskId, data: data);
    var success = response.response != null;

    if (success) {
      return response.response;
    } else {
      ErrorDialog.show(response.error);
      return null;
    }
  }
}
