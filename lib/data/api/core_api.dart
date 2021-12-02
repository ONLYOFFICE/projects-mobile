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
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:projects/data/models/from_api/error.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/internal/locator.dart';

class CoreApi {
  final SecureStorage _secureStorage = locator<SecureStorage>();
  String? _portalName;

  final int timeout = 30;

  CancellationToken cancellationToken = CancellationToken();

  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': token
    };
  }

  String version = '2.0';

  String capabilitiesUrl(String portalName) {
    if (portalName.contains('http')) {
      _portalName = portalName;
    } else {
      _portalName = 'https://$portalName';
    }

    return '$_portalName/api/$version/capabilities';
  }

  Future<String> addTaskCommentUrl({required int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/comment';

  Future<String> addMessageUrl({required int projectId}) async =>
      '${await getPortalURI()}/api/$version/project/$projectId/message';

  Future<String> addMessageCommentUrl({required int messageId}) async =>
      '${await getPortalURI()}/api/$version/project/message/$messageId/comment';

  Future<String> allGroups() async =>
      '${await getPortalURI()}/api/$version/group';

  Future<String> addTaskUrl({required int projectId}) async =>
      '${await getPortalURI()}/api/$version/project/$projectId/task';

  Future<String> allProfiles() async =>
      '${await getPortalURI()}/api/$version/people';

  Future<String> authUrl() async =>
      '${await getPortalURI()}/api/$version/authentication';

  Future<String> copyTaskUrl({required int copyFrom}) async =>
      '${await getPortalURI()}/api/2.0/project/task/$copyFrom/copy';

  Future<String> copySubtaskUrl({
    required int taskId,
    required int subtaskId,
  }) async =>
      '${await getPortalURI()}/api/2.0/project/task/$taskId/$subtaskId/copy';

  Future<String> createSubtaskUrl({required int taskId}) async =>
      '${await getPortalURI()}/api/2.0/project/task/$taskId';

  Future<String> deleteCommentUrl({required String commentId}) async =>
      '${await getPortalURI()}/api/$version/project/comment/$commentId';

  Future<String> deleteTaskUrl({required int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId';

  Future<String> deleteMessageUrl({required int id}) async =>
      '${await getPortalURI()}/api/$version/project/message/$id';

  Future<String> deleteSubtaskUrl({
    required int taskId,
    required int subtaskId,
  }) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/$subtaskId';

  Future<String> getTaskFilesUrl({required int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/files';

  Future<String> getEntityFilesUrl({required int entityId}) async =>
      '${await getPortalURI()}/api/$version/project/$entityId/entityfiles';

  Future<String> getFilesBaseUrl() async =>
      '${await getPortalURI()}/api/$version/files/';

  Future<String> discussionsByParamsUrl() async =>
      '${await getPortalURI()}/api/$version/project/message/filter?';

  Future<String> discussionDetailedUrl({required int messageId}) async =>
      '${await getPortalURI()}/api/$version/project/message/$messageId';

  Future<String> milestonesByFilterUrl() async =>
      '${await getPortalURI()}/api/$version/project/milestone/filter?';

  Future<String> getTaskLinkUrl({
    required int taskId,
    required int projectId,
  }) async =>
      '${await getPortalURI()}/Products/Projects/Tasks.aspx?prjID=$projectId&id=$taskId#';

  Future<String> getDiscussionCommentLink({
    required int discussionId,
    required int projectId,
    required String commentId,
  }) async =>
      '${await getPortalURI()}/Products/Projects/Messages.aspx?prjID=$projectId&id=$discussionId#comment_$commentId';

  Future<String> getTaskCommentLink({
    required int taskId,
    required int projectId,
    required String commentId,
  }) async =>
      '${await getPortalURI()}/Products/Projects/Tasks.aspx?prjID=$projectId&id=$taskId#comment_$commentId';

  Future<String> passwordRecoveryUrl() async =>
      '${await getPortalURI()}/api/$version/people/password';

  Future<String> tfaUrl({required String code}) async =>
      '${await getPortalURI()}/api/$version/authentication/$code';

  Future<String> projectsByParamsBaseUrl() async =>
      '${await getPortalURI()}/api/$version/project/filter?';

  Future<String> tasksByParamsUrl() async =>
      '${await getPortalURI()}/api/$version/project/task/filter?';

  Future<String> taskByIdUrl(int id) async =>
      '${await getPortalURI()}/api/$version/project/task/$id';

  Future<String> taskComments({required int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/comment';

  Future<String> projectsUrl() async =>
      '${await getPortalURI()}/api/$version/project';

  Future<String> projectByIdUrl(int projectId) async =>
      '${await getPortalURI()}/api/$version/project/$projectId';

  Future<String> projectTags() async =>
      '${await getPortalURI()}/api/$version/project/tag';

  Future<String> selfInfoUrl() async =>
      '${await getPortalURI()}/api/$version/people/@self';

  Future<String> sendRegistrationTypeUrl() async =>
      '${await getPortalURI()}/api/$version/portal/mobile/registration';

  Future<String> sendSmsUrl() async =>
      '${await getPortalURI()}/api/$version/authentication/sendsms';

  Future<String> setPhoneUrl() async =>
      '${await getPortalURI()}/api/$version/authentication/setphone';

  Future<String> statusesUrl() async =>
      '${await getPortalURI()}/api/$version/project/status';

  Future<String> subscribeTaskUrl({required int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/subscribe';

  Future<String> subscribeToMessage({required int messageId}) async =>
      '${await getPortalURI()}/api/$version/project/message/$messageId/subscribe';

  Future<String> updateCommentUrl({required String commentId}) async =>
      '${await getPortalURI()}/api/$version/project/comment/$commentId';

  Future<String> updateMessageUrl({required int messageId}) async =>
      '${await getPortalURI()}/api/$version/project/message/$messageId';

  Future<String> updateMessageStatusUrl({required int messageId}) async =>
      '${await getPortalURI()}/api/$version/project/message/$messageId/status';

  Future<String> updateSubtask({
    required int taskId,
    required int subtaskId,
  }) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/$subtaskId';

  Future<String> updateSubtaskStatus({
    required int taskId,
    required int subtaskId,
  }) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/$subtaskId/status';

  Future<String> updateTaskUrl({required int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId';

  Future<String> updateTaskStatusUrl({required int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/status';

  Future<String> createProjectUrl() async =>
      '${await getPortalURI()}/api/$version/project/withSecurity';

  Future<String> createTagUrl() async =>
      '${await getPortalURI()}/api/$version/project/tag';

  Future<String> projectByIDUrl(int projectId) async =>
      '${await getPortalURI()}/api/$version/project/$projectId';

  Future<String> updateProjectStatusUrl({required int projectId}) async =>
      '${await projectByIDUrl(projectId)}/status';

  Future<String> followProjectUrl({required int projectId}) async =>
      '${await projectByIDUrl(projectId)}/follow';

  Future<String> projectTeamUrl({required int projectID}) async =>
      '${await getPortalURI()}/api/$version/project/$projectID/team';

  Future<String> createMilestoneUrl({required int projectID}) async =>
      '${await getPortalURI()}/api/$version/project/$projectID/milestone';

  Future<String> getFolderByIdUrl(String folderId) async =>
      '${await getPortalURI()}/api/$version/files/folder/$folderId';

  Future<String> getFileByIdUrl(String fileId) async =>
      '${await getPortalURI()}/api/$version/files/file/$fileId';

  Future<String> getMoveOpsUrl() async =>
      '${await getPortalURI()}/api/$version/files/fileops/move';
  Future<String> getCopyOpsUrl() async =>
      '${await getPortalURI()}/api/$version/files/fileops/copy';

  Future<String> getFileOperationsUrl() async =>
      '${await getPortalURI()}/api/$version/files/fileops';

  Future<String> getProjectSecurityInfoUrl() async =>
      '${await getPortalURI()}/api/$version/project/securityinfo';

  Future<dynamic> getRequest(String url) async {
    try {
      debugPrint(url);
      final headers = await getHeaders();
      final request = HttpClientHelper.get(
        Uri.parse(url),
        cancelToken: cancellationToken,
        timeLimit: Duration(seconds: timeout),
        headers: headers,
      );
      final response = await request;

      if (response == null) return CustomError(message: '');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        String? error;
        if (response.headers['content-type'] != null &&
            response.headers['content-type']!.contains('json')) {
          error = json.decode(response.body)['error']['message'] as String?;
        }

        return CustomError(message: error ?? response.reasonPhrase!);
      }
    } on TimeoutException catch (_) {
      return CustomError(message: '');
      // ignore: avoid_catching_errors
    } on OperationCanceledError catch (_) {
      return CustomError(message: '');
    } catch (e) {
      return CustomError(message: '');
    }
  }

  Future<dynamic> postRequest(String url, Map? body) async {
    try {
      debugPrint(url);
      final headers = await getHeaders();
      final request = HttpClientHelper.post(
        Uri.parse(url),
        cancelToken: cancellationToken,
        timeLimit: Duration(seconds: timeout),
        headers: headers,
        body: jsonEncode(body),
      );

      final response = await request;

      if (response == null) return CustomError(message: '');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        String? error;
        if (response.headers['content-type'] != null &&
            response.headers['content-type']!.contains('json')) {
          error = json.decode(response.body)['error']['message'] as String?;
        }

        return CustomError(message: error ?? response.reasonPhrase!);
      }
    } on TimeoutException catch (_) {
      return CustomError(message: '');
      // ignore: avoid_catching_errors
    } on OperationCanceledError catch (_) {
      return CustomError(message: '');
    } catch (e) {
      return CustomError(message: '');
    }
  }

  Future<dynamic> putRequest(String url,
      {Map<dynamic, dynamic> body = const <dynamic, dynamic>{}}) async {
    try {
      debugPrint(url);
      final headers = await getHeaders();
      final request = HttpClientHelper.put(
        Uri.parse(url),
        cancelToken: cancellationToken,
        timeLimit: Duration(seconds: timeout),
        headers: headers,
        body: body.isEmpty ? null : jsonEncode(body),
      );
      final response = await request;

      if (response == null) return CustomError(message: '');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        String? error;
        if (response.headers['content-type'] != null &&
            response.headers['content-type']!.contains('json')) {
          error = json.decode(response.body)['error']['message'] as String?;
        }

        return CustomError(message: error ?? response.reasonPhrase!);
      }
    } on TimeoutException catch (_) {
      return CustomError(message: '');
      // ignore: avoid_catching_errors
    } on OperationCanceledError catch (_) {
      return CustomError(message: '');
    } catch (e) {
      return CustomError(message: '');
    }
  }

  Future<dynamic> deleteRequest(String url) async {
    try {
      debugPrint(url);
      final headers = await getHeaders();
      final request = HttpClientHelper.delete(
        Uri.parse(url),
        cancelToken: cancellationToken,
        timeLimit: Duration(seconds: timeout),
        headers: headers,
      );
      final response = await request;

      if (response == null) return CustomError(message: '');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        String? error;
        if (response.headers['content-type'] != null &&
            response.headers['content-type']!.contains('json')) {
          error = json.decode(response.body)['error']['message'] as String?;
        }

        return CustomError(message: error ?? response.reasonPhrase!);
      }
    } on TimeoutException catch (_) {
      return CustomError(message: '');
      // ignore: avoid_catching_errors
    } on OperationCanceledError catch (_) {
      return CustomError(message: '');
    } catch (e) {
      return CustomError(message: '');
    }
  }

  Future<String?> getPortalURI() async {
    if (_portalName == null || _portalName!.isEmpty) {
      _portalName = await _secureStorage.getString('portalName');
    }

    if (_portalName == null) {
      return null;
    } else {
      if (!_portalName!.contains('http')) {
        _portalName = 'https://$_portalName';
        await savePortalName();
      }
    }
    return _portalName;
  }

  Future<String> getToken() async {
    final token = await _secureStorage.getString('token') ?? '';
    return token;
  }

  Future<void> savePortalName() async {
    await _secureStorage.putString('portalName', _portalName);
  }
}
