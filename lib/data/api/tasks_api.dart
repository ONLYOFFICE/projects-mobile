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
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/new_task_DTO.dart';
import 'package:projects/internal/locator.dart';

class TaskApi {
  Future<ApiDTO<PortalTask>> addTask({required NewTaskDTO newTask}) async {
    final url =
        await locator.get<CoreApi>().addTaskUrl(projectId: newTask.projectId);
    final result = ApiDTO<PortalTask>();

    try {
      final response =
          await locator.get<CoreApi>().postRequest(url, newTask.toJson());

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = PortalTask.fromJson(
            responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }
    return result;
  }

  Future<ApiDTO<PortalTask>> copyTask(
      {required int copyFrom, required NewTaskDTO task}) async {
    final url = await locator.get<CoreApi>().copyTaskUrl(copyFrom: copyFrom);
    final result = ApiDTO<PortalTask>();

    try {
      final response =
          await locator.get<CoreApi>().postRequest(url, task.toJson());

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = PortalTask.fromJson(
            responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }
    return result;
  }

  Future<ApiDTO<PortalTask>> getTaskByID({required int id}) async {
    final url = await locator.get<CoreApi>().taskByIdUrl(id);
    final result = ApiDTO<PortalTask>();

    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = PortalTask.fromJson(
            responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<String> getTaskLink(
      {required int taskId, required int projectId}) async {
    return locator
        .get<CoreApi>()
        .getTaskLinkUrl(taskId: taskId, projectId: projectId);
  }

  Future<ApiDTO<List<Status>>> getStatuses() async {
    final url = await locator.get<CoreApi>().statusesUrl();

    final result = ApiDTO<List<Status>>();
    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response =
            (responseJson['response'] as List<Map<String, dynamic>>)
                .map((i) => Status.fromJson(i))
                .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> updateTaskStatus(
      {required int taskId,
      required int newStatusId,
      required int newStatusType}) async {
    final url =
        await locator.get<CoreApi>().updateTaskStatusUrl(taskId: taskId);

    final result = ApiDTO();

    final body = {'status': newStatusType, 'statusId': newStatusId};
    try {
      final response = await locator.get<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = responseJson['response'];
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }
    return result;
  }

  Future<ApiDTO> deleteTask({required int taskId}) async {
    final url = await locator.get<CoreApi>().deleteTaskUrl(taskId: taskId);

    final result = ApiDTO();

    try {
      final response = await locator.get<CoreApi>().deleteRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = responseJson['response'];
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }
    return result;
  }

  Future<ApiDTO> subscribeToTask({required int taskId}) async {
    final url = await locator.get<CoreApi>().subscribeTaskUrl(taskId: taskId);

    final result = ApiDTO();

    try {
      final response = await locator.get<CoreApi>().putRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = responseJson['response'];
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }
    return result;
  }

  Future<PageDTO<List<PortalTask>>> getTasksByParams({
    int? startIndex,
    String? query,
    String? sortBy,
    String? sortOrder,
    String? responsibleFilter,
    String? creatorFilter,
    String? projectFilter,
    String? milestoneFilter,
    String? statusFilter,
    String? projectId,
    String? deadlineFilter,
  }) async {
    var url = await locator.get<CoreApi>().tasksByParamsUrl();

    if (startIndex != null) {
      url += '&Count=25&StartIndex=$startIndex';
    }

    if (query != null) {
      final parsedData = Uri.encodeComponent(query);
      url += '&FilterValue=$parsedData';
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

    if (statusFilter != null) {
      url += statusFilter;
    }

    if (deadlineFilter != null) {
      url += deadlineFilter;
    }

    if (projectId != null) {
      url += '&projectId=$projectId';
    }

    final result = PageDTO<List<PortalTask>>();
    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.total = responseJson['total'] as int?;
        {
          result.response =
              (responseJson['response'] as List<Map<String, dynamic>>)
                  .map((i) => PortalTask.fromJson(i))
                  .toList();
        }
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalTask>> updateTask({required NewTaskDTO newTask}) async {
    final url = await locator.get<CoreApi>().updateTaskUrl(taskId: newTask.id!);
    final result = ApiDTO<PortalTask>();

    try {
      final response =
          await locator.get<CoreApi>().putRequest(url, body: newTask.toJson());

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = PortalTask.fromJson(
            responseJson['response'] as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }
    return result;
  }
}
