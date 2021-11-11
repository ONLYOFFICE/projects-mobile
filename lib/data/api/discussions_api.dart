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

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/models/from_api/new_discussion_DTO.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class DiscussionsApi {
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
    var url = await locator<CoreApi>().discussionsByParamsUrl();

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
      var response = await locator<CoreApi>().getRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.total = responseJson['total'];
        {
          result.response = (responseJson['response'] as List)
              .map((i) => Discussion.fromJson(i))
              .toList();
        }
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> addMessage({int projectId, NewDiscussionDTO newDiss}) async {
    var url = await locator<CoreApi>().addMessageUrl(projectId: projectId);
    var result = ApiDTO();

    try {
      var response =
          await locator<CoreApi>().postRequest(url, newDiss.toJson());

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = Discussion.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> getMessageDetailed({int id}) async {
    var url = await locator<CoreApi>().discussionDetailedUrl(messageId: id);
    var result = ApiDTO();

    try {
      var response = await locator<CoreApi>().getRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = Discussion.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> updateMessage({int id, NewDiscussionDTO discussion}) async {
    var url = await locator<CoreApi>().updateMessageUrl(messageId: id);
    var result = ApiDTO();

    try {
      var body = discussion.toJson();

      var response = await locator<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = Discussion.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> updateMessageStatus({int id, String newStatus}) async {
    var url = await locator<CoreApi>().updateMessageStatusUrl(messageId: id);
    var result = ApiDTO();

    try {
      var body = {'status': newStatus};

      var response = await locator<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = Discussion.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> subscribeToMessage({int id}) async {
    var url = await locator<CoreApi>().subscribeToMessage(messageId: id);
    var result = ApiDTO();

    try {
      var body = {};

      var response = await locator<CoreApi>().putRequest(url, body: body);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = Discussion.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> deleteMessage({int id}) async {
    var url = await locator<CoreApi>().deleteMessageUrl(id: id);
    var result = ApiDTO();

    try {
      var response = await locator<CoreApi>().deleteRequest(url);

      if (response is http.Response) {
        var responseJson = json.decode(response.body);
        result.response = Discussion.fromJson(responseJson['response']);
      } else {
        result.error = (response as CustomError);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
