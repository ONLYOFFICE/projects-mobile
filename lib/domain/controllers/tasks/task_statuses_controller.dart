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

import 'dart:async';

import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/models/from_api/status.dart';
import 'package:projects/data/services/task/task_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/internal/utils/debug_print.dart';
import 'package:projects/internal/utils/image_decoder.dart';

class TaskStatusesController extends GetxController {
  final TaskService _api = locator<TaskService>();

  RxList<Status> statuses = <Status>[].obs;
  RxList<String> statusImagesDecoded = <String>[].obs;
  RxBool loaded = false.obs;

  Future getStatuses() async {
    if (statuses.isNotEmpty) return;
    await _updateStatuses(forceReload: true);
  }

  Future<void> _updateStatuses({bool forceReload = false}) async {
    if (forceReload || loaded.value != false) {
      loaded.value = false;
      statuses.value = await _api.getStatuses() as List<Status>;
      statusImagesDecoded.clear();
      for (final element in statuses) {
        if (element.image == null) continue;
        statusImagesDecoded.add(decodeImageString(element.image as String));
      }
      loaded.value = true;
    }
  }

  Future getTaskStatus(PortalTask? task) async {
    if (!loaded.isFalse) {
      final status = await _findStatus(task!);
      if (status == null && !loaded.isFalse) {
        printWarning('TASK ID ${task.id} STATUS DIDNT FIND');
        await _updateStatuses();
        await _findStatus(task);
      }
      return status;
    }
  }

  Future<Status?> _findStatus(PortalTask task) async {
    // TODO async???
    Status status;

    if (task.customTaskStatus != null) {
      status = statuses.firstWhere(
        (element) => element.id == task.customTaskStatus,
        orElse: () => Status(),
      );
    } else {
      status = statuses.firstWhere(
        (element) => -element.id == task.status,
        orElse: () => Status(),
      );
      status ??= statuses.lastWhere(
        (element) => element.statusType == task.status,
        orElse: () => null,
      );
    }
    return status;
  }
}
