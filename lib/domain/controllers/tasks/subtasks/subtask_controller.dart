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

import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/data/services/task/subtasks_service.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class SubtaskStatus {
  static const OPEN = 1;
  static const CLOSED = 2;
}

class SubtaskController extends GetxController {
  final SubtasksService _api = locator<SubtasksService>();
  late Rx<Subtask?> subtask;
  PortalTask? parentTask;
  final _userController = Get.find<UserController>();

  SubtaskController({Subtask? subtask, this.parentTask}) {
    this.subtask = subtask.obs;
  }

  bool get canEdit => subtask.value!.canEdit! && parentTask!.status != SubtaskStatus.CLOSED;
  bool get canCreateSubtask =>
      parentTask!.canCreateSubtask! && parentTask!.status != SubtaskStatus.CLOSED;

  void acceptSubtask({
    required int taskId,
    required int subtaskId,
  }) async {
    await _userController.getUserInfo();
    final selfUser = _userController.user!;
    final data = {'responsible': selfUser.id, 'title': subtask.value!.title};

    final result = await _api.acceptSubtask(data: data, taskId: taskId, subtaskId: subtaskId);

    if (result != null) {
      subtask.value = result;
      MessagesHandler.showSnackBar(
        context: Get.context!,
        text: tr('subtaskAccepted'),
        buttonText: tr('ok'),
        buttonOnTap: ScaffoldMessenger.maybeOf(Get.context!)!.hideCurrentSnackBar,
      );
    }
  }

  void copySubtask(
    BuildContext context, {
    required int taskId,
    required int subtaskId,
  }) async {
    final result = await _api.copySubtask(taskId: taskId, subtaskId: subtaskId);
    if (result != null) {
      MessagesHandler.showSnackBar(context: context, text: tr('subtaskCopied'));
      locator<EventHub>().fire('needToRefreshParentTask', [taskId]);
    }
  }

  void deleteSubtask({
    required BuildContext context,
    required int taskId,
    required int subtaskId,
    bool closePage = false,
  }) async {
    final result = await _api.deleteSubtask(taskId: taskId, subtaskId: subtaskId);
    if (result != null) {
      locator<EventHub>().fire('needToRefreshParentTask', [taskId]);

      MessagesHandler.showSnackBar(context: context, text: 'Subtask deleted');
      if (closePage) Get.back();
    }
  }

  void updateSubtaskStatus({
    required BuildContext context,
    required int taskId,
    required int subtaskId,
  }) async {
    if (subtask.value!.canEdit!) {
      var newStatus;

      if (subtask.value!.status == SubtaskStatus.OPEN)
        newStatus = 'closed';
      else
        newStatus = 'open';

      final data = {'status': newStatus};

      final result =
          await _api.updateSubtaskStatus(data: data, taskId: taskId, subtaskId: subtaskId);

      if (result != null) subtask.value = result;
    } else {
      MessagesHandler.showSnackBar(context: context, text: tr('cantEditSubtask'));
    }
  }

  void deleteSubtaskResponsible({
    required int taskId,
    required int subtaskId,
  }) async {
    if (subtask.value!.canEdit!) {
      final data = {'title': subtask.value!.title, 'responsible': null};

      final result = await _api.updateSubtask(
        data: data,
        taskId: taskId,
        subtaskId: subtaskId,
      );

      if (result != null) subtask.value = result;
    }
  }
}
