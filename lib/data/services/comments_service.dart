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
import 'package:projects/data/api/comments_api.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class CommentsService {
  final CommentsApi? _api = locator<CommentsApi>();
  final SecureStorage? _secureStorage = locator<SecureStorage>();

  Future getTaskComments({int? taskId}) async {
    var files = await _api!.getTaskComments(taskId: taskId);
    var success = files.response != null;

    if (success) {
      return files.response;
    } else {
      await Get.find<ErrorDialog>().show(files.error!.message!);
      return null;
    }
  }

  Future addTaskReplyComment({
    int? taskId,
    String? content,
    String? parentId,
  }) async {
    var result = await _api!.addTaskReplyComment(
      taskId: taskId,
      content: content,
      parentId: parentId,
    );
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message!);
      return null;
    }
  }

  Future addMessageReplyComment({
    int? messageId,
    String? content,
    String? parentId,
  }) async {
    var result = await _api!.addMessageReplyComment(
      content: content,
      messageId: messageId,
      parentId: parentId,
    );
    var success = result.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.createEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage!.getString('portalName'),
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.reply
      });
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message!);
      return null;
    }
  }

  Future addTaskComment({int? taskId, String? content}) async {
    var result = await _api!.addTaskComment(taskId: taskId, content: content);
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message!);
      return null;
    }
  }

  Future addMessageComment({int? messageId, String? content}) async {
    var result =
        await _api!.addMessageComment(messageId: messageId, content: content);
    var success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message!);
      return null;
    }
  }

  Future deleteComment({String? commentId}) async {
    var task = await _api!.deleteComment(commentId: commentId);
    var success = task.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.deleteEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage!.getString('portalName'),
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.reply
      });
      return task.response;
    } else {
      await Get.find<ErrorDialog>().show(task.error!.message!);
      return null;
    }
  }

  Future<String> getDiscussionCommentLink({
    discussionId,
    projectId,
    commentId,
  }) async {
    return await _api!.getDiscussionCommentLink(
      discussionId: discussionId,
      projectId: projectId,
      commentId: commentId,
    );
  }

  Future<String> getTaskCommentLink({taskId, projectId, commentId}) async {
    return await _api!.getTaskCommentLink(
      taskId: taskId,
      projectId: projectId,
      commentId: commentId,
    );
  }

  Future updateComment({String? commentId, String? content}) async {
    var result =
        await _api!.updateComment(commentId: commentId, content: content);
    var success = result.response != null;

    if (success) {
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal:
            await _secureStorage!.getString('portalName'),
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.reply
      });
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message!);
      return null;
    }
  }
}
