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

import 'package:get/get.dart';
import 'package:projects/data/api/tasks_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/models/new_task_DTO.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class TaskService {
  final TaskApi _api = locator<TaskApi>();
  final SecureStorage _secureStorage = locator<SecureStorage>();

  Rx<PortalTask> portalTask = PortalTask().obs;

  Future<PortalTask?> addTask({required NewTaskDTO newTask}) async {
    final task = await _api.addTask(newTask: newTask);

    final success = task.error == null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.createEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.task
      });
      return task.response;
    } else {
      await Get.find<ErrorDialog>().show(task.error!.message);
      return null;
    }
  }

  Future<PortalTask?> getTaskByID({required int id}) async {
    final task = await _api.getTaskByID(id: id);

    final success = task.error == null;

    if (success) {
      return task.response;
    } else {
      await Get.find<ErrorDialog>().show(task.error!.message);
      return null;
    }
  }

  Future<List<Status>?> getStatuses() async {
    final statuses = await _api.getStatuses();

    final success = statuses.error == null;

    if (success) {
      return statuses.response;
    } else {
      await Get.find<ErrorDialog>().show(statuses.error!.message);
      return null;
    }
  }

  Future<PageDTO<List<PortalTask>>?> getTasksByParams({
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
    final projects = await _api.getTasksByParams(
      startIndex: startIndex,
      query: query,
      sortBy: sortBy,
      sortOrder: sortOrder,
      responsibleFilter: responsibleFilter,
      creatorFilter: creatorFilter,
      projectFilter: projectFilter,
      milestoneFilter: milestoneFilter,
      statusFilter: statusFilter,
      deadlineFilter: deadlineFilter,
      projectId: projectId,
    );

    final success = projects.error == null;

    if (success) {
      return projects;
    } else {
      await Get.find<ErrorDialog>().show(projects.error!.message);
      return null;
    }
  }

  Future<PageDTO<List<PortalTask>>?> searchTasks({
    int? startIndex,
    String? query,
    // String sortBy,
    // String sortOrder,
    // String responsibleFilter,
    // String creatorFilter,
    // String projectFilter,
    // String milestoneFilter,
    // String projectId,
    // String deadlineFilter,
  }) async {
    final projects = await _api.getTasksByParams(
      startIndex: startIndex,
      query: query,
      // sortBy: sortBy,
      // sortOrder: sortOrder,
      // responsibleFilter: responsibleFilter,
      // creatorFilter: creatorFilter,
      // projectFilter: projectFilter,
      // milestoneFilter: milestoneFilter,
      // deadlineFilter: deadlineFilter,
      // projectId: projectId,
    );

    final success = projects.error == null;

    if (success) {
      return projects;
    } else {
      await Get.find<ErrorDialog>().show(projects.error!.message);
      return null;
    }
  }

  Future<PortalTask?> updateTask({required NewTaskDTO newTask}) async {
    final task = await _api.updateTask(newTask: newTask);

    final success = task.error == null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage.getString('portalName'),
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.task
      });
      return task.response;
    } else {
      await Get.find<ErrorDialog>().show(task.error!.message);
      return null;
    }
  }
}
