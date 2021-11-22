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
import 'package:projects/data/api/subtasks_api.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class SubtasksService {
  final SubtasksApi? _api = locator<SubtasksApi>();
  final SecureStorage? _secureStorage = locator<SecureStorage>();

  Future acceptSubtask({int? taskId, int? subtaskId, required Map data}) async {
    var response = await _api!.acceptSubtask(
        data: data, taskId: taskId, subtaskId: subtaskId);
    var success = response.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage!.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.subtask
      });
      return response.response;
    } else {
      await Get.find<ErrorDialog>().show(response.error!.message!);
      return null;
    }
  }

  Future deleteSubtask({int? taskId, int? subtaskId}) async {
    var response =
        await _api!.deleteSubTask(taskId: taskId, subtaskId: subtaskId);
    var success = response.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.deleteEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage!.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.subtask
      });
      return response.response;
    } else {
      await Get.find<ErrorDialog>().show(response.error!.message!);
      return null;
    }
  }

  Future createSubtask({int? taskId, Map? data}) async {
    var response = await _api!.createSubtask(taskId: taskId, data: data);
    var success = response.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.createEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage!.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.subtask
      });
      return response.response;
    } else {
      await Get.find<ErrorDialog>().show(response.error!.message!);
      return null;
    }
  }

  Future copySubtask({int? taskId, int? subtaskId}) async {
    var response = await _api!.copySubtask(taskId: taskId, subtaskId: subtaskId);
    var success = response.response != null;

    if (success) {
      return response.response;
    } else {
      await Get.find<ErrorDialog>().show(response.error!.message!);
      return null;
    }
  }

  Future updateSubtaskStatus({int? taskId, int? subtaskId, required Map data}) async {
    var response = await _api!.updateSubtaskStatus(
        taskId: taskId, subtaskId: subtaskId, data: data);
    var success = response.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage!.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.subtask
      });
      return response.response;
    } else {
      await Get.find<ErrorDialog>().show(response.error!.message!);
      return null;
    }
  }

  Future updateSubtask({int? taskId, int? subtaskId, required Map data}) async {
    var response = await _api!.updateSubtask(
      taskId: taskId,
      subtaskId: subtaskId,
      data: data,
    );

    var success = response.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage!.getString('portalName'),
        AnalyticsService.Params.Key.entity:
            AnalyticsService.Params.Value.subtask
      });
      return response.response;
    } else {
      await Get.find<ErrorDialog>().show(response.error!.message!);
      return null;
    }
  }
}
