import 'package:get/get.dart';
import 'package:projects/data/api/tasks_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/new_task_DTO.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class TaskService {
  final TaskApi _api = locator<TaskApi>();

  var portalTask = PortalTask().obs;

  Future addTask({NewTaskDTO newTask}) async {
    var task = await _api.addTask(newTask: newTask);

    var success = task.response != null;

    if (success) {
      return task.response;
    } else {
      ErrorDialog.show(task.error);
      return null;
    }
  }

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

  Future<PageDTO<List<PortalTask>>> getTasksByParams({
    int startIndex,
    String query,
    String sortBy,
    String sortOrder,
    String responsibleFilter,
    String creatorFilter,
    String projectFilter,
    String milestoneFilter,
  }) async {
    var projects = await _api.getTasksByParams(
      startIndex: startIndex,
      query: query,
      sortBy: sortBy,
      sortOrder: sortOrder,
      responsibleFilter: responsibleFilter,
      creatorFilter: creatorFilter,
      projectFilter: projectFilter,
      milestoneFilter: milestoneFilter,
    );

    var success = projects.response != null;

    if (success) {
      return projects;
    } else {
      ErrorDialog.show(projects.error);
      return null;
    }
  }
}
