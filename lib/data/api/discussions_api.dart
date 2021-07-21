import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/models/from_api/new_discussion_DTO.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class DiscussionsApi {
  var coreApi = locator<CoreApi>();

  Future<PageDTO<List<Discussion>>> getDiscussionsByParams({
    int startIndex,
    String query,
    String sortBy,
    String sortOrder,
    String authorFilter,
    String statusFilter,
    String creationDateFilter,
    String projectFilter,
    String projectId,
    String otherFilter,
  }) async {
    var url = await coreApi.discussionsByParamsUrl();

    if (startIndex != null) {
      url += '&Count=25&StartIndex=$startIndex';
    }

    if (query != null) {
      var parsedData = Uri.encodeComponent(query);
      url += '&FilterValue=$parsedData';
    }

    if (sortBy != null &&
        sortBy.isNotEmpty &&
        sortOrder != null &&
        sortOrder.isNotEmpty) url += '&sortBy=$sortBy&sortOrder=$sortOrder';

    url += authorFilter ?? '';
    url += statusFilter ?? '';
    url += creationDateFilter ?? '';
    url += projectFilter ?? '';
    url += otherFilter ?? '';

    if (projectId != null) {
      url += '&projectId=$projectId';
    }

    var result = PageDTO<List<Discussion>>();
    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.total = responseJson['total'];
        {
          result.response = (responseJson['response'] as List)
              .map((i) => Discussion.fromJson(i))
              .toList();
        }
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> addMessage({int projectId, NewDiscussionDTO newDiss}) async {
    var url = await coreApi.addMessageUrl(projectId: projectId);
    var result = ApiDTO();

    try {
      var response = await coreApi.postRequest(url, newDiss.toJson());
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 201) {
        result.response = Discussion.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> getMessageDetailed({int id}) async {
    var url = await coreApi.discussionDetailedUrl(messageId: id);
    var result = ApiDTO();

    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = Discussion.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> updateMessage({int id, NewDiscussionDTO discussion}) async {
    var url = await coreApi.updateMessageUrl(messageId: id);
    var result = ApiDTO();

    try {
      var body = discussion.toJson();

      var response = await coreApi.putRequest(url, body: body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = Discussion.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> updateMessageStatus({int id, String newStatus}) async {
    var url = await coreApi.updateMessageStatusUrl(messageId: id);
    var result = ApiDTO();

    try {
      var body = {'status': newStatus};

      var response = await coreApi.putRequest(url, body: body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = Discussion.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> subscribeToMessage({int id}) async {
    var url = await coreApi.subscribeToMessage(messageId: id);
    var result = ApiDTO();

    try {
      var body = {};

      var response = await coreApi.putRequest(url, body: body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = Discussion.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> deleteMessage({int id}) async {
    var url = await coreApi.deleteMessageUrl(id: id);
    var result = ApiDTO();

    try {
      var response = await coreApi.deleteRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = Discussion.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
