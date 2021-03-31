import 'package:get/get.dart';
import 'package:projects/data/api/tasks_api.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class TasksService {
  final TasksApi _api = locator<TasksApi>();

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

  Future getTasks({filter = ''}) async {
    var tasks = await _api.getTasks(filter: filter);

    var success = tasks.response != null;

    if (success) {
      return tasks.response;
    } else {
      ErrorDialog.show(tasks.error);
      return null;
    }
  }

  Future getStatuses() async {
    var statuses = await _api.getStatuses();

    var success = statuses.response != null;

    if (success) {
      return statuses.response;
    } else {
      ErrorDialog.show(statuses.error);
      return null;
    }
  }
}
