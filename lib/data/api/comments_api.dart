import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class CommentsApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<List<PortalComment>>> getTaskComments({int taskId}) async {
    var url = await coreApi.taskComments(taskId: taskId);

    var result = ApiDTO<List<PortalComment>>();

    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = (responseJson['response'] as List)
            .map((i) => PortalComment.fromJson(i))
            .toList();
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalComment>> addTaskComment({
    int taskId,
    String content,
  }) async {
    var url = await coreApi.addTaskCommentUrl(taskId: taskId);

    var result = ApiDTO<PortalComment>();

    try {
      var body = {'content': content};
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = PortalComment.fromJson(responseJson);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalComment>> addMessageComment({
    int messageId,
    String content,
  }) async {
    var url = await coreApi.addMessageCommentUrl(messageId: messageId);

    var result = ApiDTO<PortalComment>();

    try {
      var body = {'content': content};
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = PortalComment.fromJson(responseJson);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalComment>> addTaskReplyComment({
    int taskId,
    String content,
    String parentId,
  }) async {
    var url = await coreApi.addTaskCommentUrl(taskId: taskId);

    var result = ApiDTO<PortalComment>();

    try {
      var body = {'content': content, 'parentId': parentId};
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = PortalComment.fromJson(responseJson);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<PortalComment>> addMessageReplyComment({
    int messageId,
    String content,
    String parentId,
  }) async {
    var url = await coreApi.addMessageCommentUrl(messageId: messageId);

    var result = ApiDTO<PortalComment>();

    try {
      var body = {'content': content, 'parentId': parentId};
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = PortalComment.fromJson(responseJson);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> deleteComment({String commentId}) async {
    var url = await coreApi.deleteCommentUrl(commentId: commentId);

    var result = ApiDTO();

    Map responseJson;

    try {
      var response = await coreApi.deleteRequest(url);
      responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        result.response = responseJson['response'];
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }
    return result;
  }

  Future<String> getCommentLink({taskId, projectId, commentId}) async {
    return await coreApi.getCommentLink(
      taskId: taskId,
      projectId: projectId,
      commentId: commentId,
    );
  }

  Future<ApiDTO> updateComment({
    String commentId,
    String content,
  }) async {
    var url = await coreApi.updateCommentUrl(commentId: commentId);

    var result = ApiDTO();

    try {
      var body = {'content': content, 'commentid': commentId};
      var response = await coreApi.putRequest(url, body: body);

      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = responseJson['response'];
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
