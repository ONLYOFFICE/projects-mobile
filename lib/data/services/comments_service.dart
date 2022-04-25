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

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:projects/data/api/comments_api.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/domain/controllers/portal_info_controller.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class CommentsService {
  final CommentsApi _api = locator<CommentsApi>();
  final _portalInfo = Get.find<PortalInfoController>();

  Future<List<PortalComment>?> getTaskComments({required int taskId}) async {
    final files = await _api.getTaskComments(taskId: taskId);
    final success = files.response != null;

    if (success) {
      return files.response;
    } else {
      await Get.find<ErrorDialog>().show(files.error!.message);
      return null;
    }
  }

  Future<PortalComment?> addTaskReplyComment({
    required int taskId,
    required String content,
    required String parentId,
  }) async {
    final result = await _api.addTaskReplyComment(
      taskId: taskId,
      content: content,
      parentId: parentId,
    );
    final success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return null;
    }
  }

  Future<PortalComment?> addMessageReplyComment({
    required int messageId,
    required String content,
    required String parentId,
  }) async {
    final result = await _api.addMessageReplyComment(
      content: content,
      messageId: messageId,
      parentId: parentId,
    );
    final success = result.response != null;

    if (success) {
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.createEntity, {
        AnalyticsService.Params.Key.portal: _portalInfo.portalUri,
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.reply
      });
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return null;
    }
  }

  Future<PortalComment?> addTaskComment({required int taskId, required String content}) async {
    final result = await _api.addTaskComment(taskId: taskId, content: content);
    final success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return null;
    }
  }

  Future<PortalComment?> addMessageComment(
      {required int messageId, required String content}) async {
    final result = await _api.addMessageComment(messageId: messageId, content: content);
    final success = result.response != null;

    if (success) {
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return null;
    }
  }

  Future<dynamic> deleteComment({required String commentId}) async {
    final task = await _api.deleteComment(commentId: commentId);
    final success = task.response != null;

    if (success) {
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.deleteEntity, {
        AnalyticsService.Params.Key.portal: _portalInfo.portalUri,
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.reply
      });
      return task.response;
    } else {
      await Get.find<ErrorDialog>().show(task.error!.message);
      return null;
    }
  }

  Future<String> getDiscussionCommentLink({
    required int discussionId,
    required int projectId,
    required String commentId,
  }) async {
    return _api.getDiscussionCommentLink(
      discussionId: discussionId,
      projectId: projectId,
      commentId: commentId,
    );
  }

  Future<String> getTaskCommentLink(
      {required int taskId, required int projectId, required String commentId}) async {
    return _api.getTaskCommentLink(
      taskId: taskId,
      projectId: projectId,
      commentId: commentId,
    );
  }

  Future<dynamic> updateComment({required String commentId, required String content}) async {
    final result = await _api.updateComment(commentId: commentId, content: content);
    final success = result.response != null;

    if (success) {
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.editEntity, {
        AnalyticsService.Params.Key.portal: _portalInfo.portalUri,
        AnalyticsService.Params.Key.entity: AnalyticsService.Params.Value.reply
      });
      return result.response;
    } else {
      await Get.find<ErrorDialog>().show(result.error!.message);
      return null;
    }
  }

  Future<String?> uploadImages(image) async {
    final file = http.MultipartFile.fromBytes(
      'upload',
      image.bytes as List<int>,
      filename: image.name as String?,
      contentType: MediaType('image', image.extension as String),
    );

    final result = await _api.uploadImage(file: file);

    final success = result.response != null;
    if (success) {
      // TODO if portal version < 12
      //return _portalInfo.portalUri! +
      //    result.response
      ///       .toString()
      //        .split("'")[1];

      final responseJson = json.decode(result.response!);
      final imageUrl = responseJson['url']?.toString();
      if (imageUrl?.isNotEmpty == true) return _portalInfo.portalUri! + imageUrl!;
    }
    return null;
  }
}
