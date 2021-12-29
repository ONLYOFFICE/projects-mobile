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
import 'package:http/http.dart';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class CommentsApi {
  Future<ApiDTO<List<PortalComment>>> getTaskComments({required int taskId}) async {
    final url = await locator.get<CoreApi>().taskComments(taskId: taskId);

    final result = ApiDTO<List<PortalComment>>();

    try {
      final response = await locator.get<CoreApi>().getRequest(url);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = (responseJson['response'] as List)
            .map((i) => PortalComment.fromJson(i as Map<String, dynamic>))
            .toList();
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalComment>> addTaskComment({
    required int taskId,
    required String content,
  }) async {
    final url = await locator.get<CoreApi>().addTaskCommentUrl(taskId: taskId);

    final result = ApiDTO<PortalComment>();

    try {
      final body = {'content': content};
      final response = await locator.get<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = PortalComment.fromJson(responseJson as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalComment>> addMessageComment({
    required int messageId,
    required String content,
  }) async {
    final url = await locator.get<CoreApi>().addMessageCommentUrl(messageId: messageId);

    final result = ApiDTO<PortalComment>();

    try {
      final body = {'content': content};
      final response = await locator.get<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = PortalComment.fromJson(responseJson as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalComment>> addTaskReplyComment({
    required int taskId,
    required String content,
    required String parentId,
  }) async {
    final url = await locator.get<CoreApi>().addTaskCommentUrl(taskId: taskId);

    final result = ApiDTO<PortalComment>();

    try {
      final body = {'content': content, 'parentId': parentId};
      final response = await locator.get<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = PortalComment.fromJson(responseJson as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalComment>> addMessageReplyComment({
    required int messageId,
    required String content,
    required String parentId,
  }) async {
    final url = await locator.get<CoreApi>().addMessageCommentUrl(messageId: messageId);

    final result = ApiDTO<PortalComment>();

    try {
      final body = {'content': content, 'parentId': parentId};
      final response = await locator.get<CoreApi>().postRequest(url, body);

      if (response is http.Response) {
        final responseJson = json.decode(response.body);
        result.response = PortalComment.fromJson(responseJson as Map<String, dynamic>);
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> deleteComment({required String commentId}) async {
    final url = await locator.get<CoreApi>().deleteCommentUrl(commentId: commentId);

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

  Future<String> getDiscussionCommentLink({
    required int discussionId,
    required int projectId,
    required String commentId,
  }) async {
    return locator.get<CoreApi>().getDiscussionCommentLink(
          discussionId: discussionId,
          projectId: projectId,
          commentId: commentId,
        );
  }

  Future<String> getTaskCommentLink({
    required int taskId,
    required int projectId,
    required String commentId,
  }) async {
    return locator.get<CoreApi>().getTaskCommentLink(
          taskId: taskId,
          projectId: projectId,
          commentId: commentId,
        );
  }

  Future<ApiDTO> updateComment({
    required String commentId,
    required String content,
  }) async {
    final url = await locator.get<CoreApi>().updateCommentUrl(commentId: commentId);

    final result = ApiDTO();

    try {
      final body = {'content': content, 'commentid': commentId};
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

  Future<ApiDTO<String>> uploadImage({required MultipartFile file}) async {
    final url = await locator.get<CoreApi>().getUploadImagesUrl();

    final result = ApiDTO<String>();

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['name'] = 'upload';
    request.fields['filename'] = file.filename ?? '';
    request.headers['Authorization'] =
        await locator.get<CoreApi>().getToken() ?? ''; //TODO nullcheck
    request.files.add(file);

    try {
      final responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);

      if (response is http.Response) {
        result.response = response.body;
      } else {
        result.error = response as CustomError;
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
