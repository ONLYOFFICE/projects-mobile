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
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/new_task_DTO.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class TaskItemService {
  final TaskApi _api = locator<TaskApi>();
  final SecureStorage _secureStorage = locator<SecureStorage>();

  Rx<PortalTask> portalTask = PortalTask().obs;

  // TODO: Future <??>
  Future copyTask({required int copyFrom, required NewTaskDTO newTask}) async {
    final task = await _api.copyTask(copyFrom: copyFrom, task: newTask);
    final success = task.response != null;

    if (success) {
      return task.response;
    } else {
      await Get.find<ErrorDialog>().show(task.error!.message);
      return null;
    }
  }

  // TODO: Future <??>
  Future getTaskByID({required int id}) async {
    final task = await _api.getTaskByID(id: id);
    final success = task.response != null;

    if (success) {
      return task.response;
    } else {
      await Get.find<ErrorDialog>().show(task.error!.message);
      return null;
    }
  }

  // TODO: Future <??>
  Future updateTaskStatus(
      {required int taskId,
      required int newStatusId,
      required int newStatusType}) async {
    final task = await _api.updateTaskStatus(
        taskId: taskId, newStatusId: newStatusId, newStatusType: newStatusType);

    final success = task.response != null;

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

  Future<String> getTaskLink(
      {required int taskId, required int projectId}) async {
    return _api.getTaskLink(taskId: taskId, projectId: projectId);
  }

  // TODO: Future <??>
  Future deleteTask({required int taskId}) async {
    final task = await _api.deleteTask(taskId: taskId);
    final success = task.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.deleteEntity, {
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

  // TODO: Future <??>
  Future subscribeToTask({required int taskId}) async {
    final task = await _api.subscribeToTask(taskId: taskId);
    final success = task.response != null;

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
