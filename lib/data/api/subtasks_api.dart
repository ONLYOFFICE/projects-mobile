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

import 'dart:convert';
import 'package:http/http.dart' as http;

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

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = Subtask.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }
    return result;
  }

  Future<ApiDTO> deleteSubTask({int taskId, int subtaskId}) async {
    var url =
        await _coreApi.deleteSubtaskUrl(taskId: taskId, subtaskId: subtaskId);
    var result = ApiDTO();

    try {
      var response = await _coreApi.deleteRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = Subtask.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }
    return result;
  }

  Future<ApiDTO> copySubtask({int taskId, int subtaskId}) async {
    var url =
        await _coreApi.copySubtaskUrl(taskId: taskId, subtaskId: subtaskId);
    var result = ApiDTO();

    try {
      var response = await _coreApi.postRequest(url, {});

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = Subtask.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }
    return result;
  }

  Future<ApiDTO> createSubtask({int taskId, Map data}) async {
    var url = await _coreApi.createSubtaskUrl(taskId: taskId);
    var result = ApiDTO();

    try {
      var response = await _coreApi.postRequest(url, data);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = Subtask.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
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

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = Subtask.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
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

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = Subtask.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }
    return result;
  }
}
