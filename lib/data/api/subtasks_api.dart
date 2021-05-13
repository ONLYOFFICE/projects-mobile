import 'dart:convert';

import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/error.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/internal/locator.dart';

class SubtasksApi {
  final CoreApi _coreApi = locator<CoreApi>();

  Future<ApiDTO> acceptSubtask({int taskId, int subtaskId, Map data}) async {
    var url =
        await _coreApi.updateSubtask(taskId: taskId, subtaskId: subtaskId);
    var result = ApiDTO();

    try {
      var response = await _coreApi.putRequest(url, body: data);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = Subtask.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }
    return result;
  }

  Future<ApiDTO> deleteSubTask({int taskId, int subtaskId}) async {
    var url =
        await _coreApi.deleteSubtask(taskId: taskId, subtaskId: subtaskId);
    var result = ApiDTO();

    try {
      var response = await _coreApi.deleteRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = Subtask.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }
    return result;
  }

  Future<ApiDTO> copySubtask({int taskId, int subtaskId}) async {
    var url = await _coreApi.copySubtask(taskId: taskId, subtaskId: subtaskId);
    var result = ApiDTO();

    try {
      var response = await _coreApi.postRequest(url, {}.toString());
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = Subtask.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }
    return result;
  }

  Future<ApiDTO> createSubtask({int taskId, Map data}) async {
    var url = await _coreApi.createSubtaskUrl(taskId: taskId);
    var result = ApiDTO();

    try {
      var response = await _coreApi.postRequest(url, jsonEncode(data));
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = Subtask.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }
    return result;
  }

  Future<ApiDTO> updateSubtaskStatus({
    int taskId,
    int subtaskId,
    Map data,
  }) async {
    var url = await _coreApi.updateSubtaskStatus(
        taskId: taskId, subtaskId: subtaskId);

    var result = ApiDTO();
    try {
      var response = await _coreApi.putRequest(url, body: data);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = Subtask.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }
    return result;
  }

  Future<ApiDTO> updateSubtask({
    int taskId,
    int subtaskId,
    Map data,
  }) async {
    var url = await _coreApi.updateSubtask(
      taskId: taskId,
      subtaskId: subtaskId,
    );

    var result = ApiDTO();
    try {
      var response = await _coreApi.putRequest(url, body: data);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = Subtask.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }
    return result;
  }
}
