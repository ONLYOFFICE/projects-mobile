import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/new_task_DTO.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class TaskApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO> addTask({NewTaskDTO newTask}) async {
    var url = await coreApi.addTaskUrl(projectId: newTask.projectId);
    var result = ApiDTO();

    try {
      var response =
          await coreApi.postRequest(url, jsonEncode(newTask.toJson()));
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 201) {
        result.response = PortalTask.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }
    return result;
  }

  Future<ApiDTO> getTaskByID({int id}) async {
    var url = await coreApi.taskByIdUrl(id);
    var result = ApiDTO();

    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = PortalTask.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }

    return result;
  }

  Future<ApiDTO<List<Status>>> getStatuses() async {
    var url = await coreApi.statusesUrl();

    var result = ApiDTO<List<Status>>();
    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => Status.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }

    return result;
  }

  Future<ApiDTO> updateTaskStatus(
      {int taskId, int newStatusId, int newStatusType}) async {
    var url = await coreApi.updateTaskStatusUrl(taskId: taskId);

    var result = ApiDTO();

    var body = {'status': newStatusType, 'statusId': newStatusId};
    Map responseJson;
    try {
      var response = await coreApi.putRequest(url, body: body);
      responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = responseJson['response'];
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }
    return result;
  }

  Future<ApiDTO> deleteTask({int taskId}) async {
    var url = await coreApi.deleteTask(taskId: taskId);

    var result = ApiDTO();

    Map responseJson;
    try {
      var response = await coreApi.deleteRequest(url);
      responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        result.response = responseJson['response'];
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }
    return result;
  }

  Future<ApiDTO> subscribeToTask({int taskId}) async {
    var url = await coreApi.subscribeTask(taskId: taskId);

    var result = ApiDTO();

    Map responseJson;
    try {
      var response = await coreApi.putRequest(url);
      responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        result.response = responseJson['response'];
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }
    return result;
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
    String projectId,
  }) async {
    var url = await coreApi.tasksByParamsrUrl();

    if (startIndex != null) {
      url += '&Count=25&StartIndex=$startIndex';
    }

    if (query != null) {
      url += '&FilterValue=$query';
    }

    if (sortBy != null &&
        sortBy.isNotEmpty &&
        sortOrder != null &&
        sortOrder.isNotEmpty) url += '&sortBy=$sortBy&sortOrder=$sortOrder';

    if (responsibleFilter != null) {
      url += responsibleFilter;
    }
    if (creatorFilter != null) {
      url += creatorFilter;
    }
    if (projectFilter != null) {
      url += projectFilter;
    }
    if (milestoneFilter != null) {
      url += milestoneFilter;
    }

    if (projectId != null) {
      url += '&projectId=$projectId';
    }

    var result = PageDTO<List<PortalTask>>();
    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.total = responseJson['total'];
        {
          result.response = (responseJson['response'] as List)
              .map((i) => PortalTask.fromJson(i))
              .toList();
        }
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }

    return result;
  }

  Future updateTask({@required NewTaskDTO newTask}) async {
    var url = await coreApi.updateTask(taskId: newTask.id);
    var result = ApiDTO();

    try {
      var response = await coreApi.putRequest(url, body: newTask.toJson());
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 201) {
        result.response = PortalTask.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }
    return result;
  }
}
