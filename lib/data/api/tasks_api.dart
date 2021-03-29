import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/from_api/task.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class TasksApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO> getTaskByID({int id}) async {
    var url = await coreApi.taskByIdUrl(id);
    var result = ApiDTO();

    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

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

  Future<ApiDTO<List<PortalTask>>> getTasks() async {
    var url = await coreApi.tasksByFilterUrl('');

    var result = ApiDTO<List<PortalTask>>();
    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => PortalTask.fromJson(i))
            .toList();
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
      final responseJson = json.decode(response.body);

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
      {int taskId, int newStatusId, String newStatusType}) async {
    var url = await coreApi.updateTaskStatusUrl(taskId: taskId);

    var result = ApiDTO();

    var body = {'status': 'open', 'statusId': newStatusId};
    var responseJson;
    try {
      var response = await coreApi.putRequest(url, body);
      // final responseJson = json.decode(response.body);
      responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }
    return result;
  }
}
