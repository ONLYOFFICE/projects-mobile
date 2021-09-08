import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/internal/locator.dart';

class CoreApi {
  var client = http.Client();
  final _secureStorage = locator<SecureStorage>();
  String _portalName;

  Future<Map<String, String>> getHeaders() async {
    var token = await getToken();
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': token
    };
  }

  var version = '2.0';

  String capabilitiesUrl(String portalName) {
    if (portalName.contains('http')) {
      _portalName = portalName;
    } else {
      _portalName = 'https://$portalName';
    }

    return '$_portalName/api/$version/capabilities';
  }

  Future<String> addTaskCommentUrl({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/comment';

  Future<String> addMessageUrl({int projectId}) async =>
      '${await getPortalURI()}/api/$version/project/$projectId/message';

  Future<String> addMessageCommentUrl({int messageId}) async =>
      '${await getPortalURI()}/api/$version/project/message/$messageId/comment';

  Future<String> allGroups() async =>
      '${await getPortalURI()}/api/$version/group';

  Future<String> addTaskUrl({projectId}) async =>
      '${await getPortalURI()}/api/$version/project/$projectId/task';

  Future<String> allProfiles() async =>
      '${await getPortalURI()}/api/$version/people';

  Future<String> authUrl() async =>
      '${await getPortalURI()}/api/$version/authentication';

  Future<String> copyTask({@required int copyFrom}) async =>
      '${await getPortalURI()}/api/2.0/project/task/$copyFrom/copy';

  Future<String> copySubtask({
    @required int taskId,
    @required int subtaskId,
  }) async =>
      '${await getPortalURI()}/api/2.0/project/task/$taskId/$subtaskId/copy';

  Future<String> createSubtaskUrl({@required int taskId}) async =>
      '${await getPortalURI()}/api/2.0/project/task/$taskId';

  Future<String> deleteCommentUrl({String commentId}) async =>
      '${await getPortalURI()}/api/$version/project/comment/$commentId';

  Future<String> deleteTask({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId';

  Future<String> deleteMessageUrl({int id}) async =>
      '${await getPortalURI()}/api/$version/project/message/$id';

  Future<String> deleteSubtask({
    @required int taskId,
    @required int subtaskId,
  }) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/$subtaskId';

  Future<String> getTaskFiles({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/files';

  Future<String> getEntityFilesUrl({String entityId}) async =>
      '${await getPortalURI()}/api/$version/project/$entityId/entityfiles';

  Future<String> getFilesBaseUrl() async =>
      '${await getPortalURI()}/api/$version/files/';

  Future<String> discussionsByParamsUrl() async =>
      '${await getPortalURI()}/api/$version/project/message/filter?';

  Future<String> discussionDetailedUrl({int messageId}) async =>
      '${await getPortalURI()}/api/$version/project/message/$messageId';

  Future<String> milestonesByFilter() async =>
      '${await getPortalURI()}/api/$version/project/milestone/filter?';

  Future<String> getTaskLink({@required taskId, @required projectId}) async =>
      '${await getPortalURI()}/Products/Projects/Tasks.aspx?prjID=$projectId&id=$taskId#';

  Future<String> getDiscussionCommentLink({
    @required discussionId,
    @required projectId,
    @required commentId,
  }) async =>
      '${await getPortalURI()}/Products/Projects/Messages.aspx?prjID=$projectId&id=$discussionId#comment_$commentId';

  Future<String> getTaskCommentLink({
    @required taskId,
    @required projectId,
    @required commentId,
  }) async =>
      '${await getPortalURI()}/Products/Projects/Tasks.aspx?prjID=$projectId&id=$taskId#comment_$commentId';

  Future<String> passwordRecoveryUrl() async =>
      '${await getPortalURI()}/api/$version/people/password';

  Future<String> tfaUrl(String code) async =>
      '${await getPortalURI()}/api/$version/authentication/$code';

  Future<String> projectsByParamsBaseUrl() async =>
      '${await getPortalURI()}/api/$version/project/filter?';

  Future<String> tasksByParamsrUrl() async =>
      '${await getPortalURI()}/api/$version/project/task/filter?';

  Future<String> taskByIdUrl(int id) async =>
      '${await getPortalURI()}/api/$version/project/task/$id';

  Future<String> taskComments({int taskId}) async =>
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

  Future<String> subscribeTask({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/subscribe';

  Future<String> subscribeToMessage({int messageId}) async =>
      '${await getPortalURI()}/api/$version/project/message/$messageId/subscribe';

  Future<String> updateCommentUrl({
    @required String commentId,
  }) async =>
      '${await getPortalURI()}/api/$version/project/comment/$commentId';

  Future<String> updateMessageUrl({@required int messageId}) async =>
      '${await getPortalURI()}/api/$version/project/message/$messageId';

  Future<String> updateMessageStatusUrl({@required int messageId}) async =>
      '${await getPortalURI()}/api/$version/project/message/$messageId/status';

  Future<String> updateSubtask({
    @required int taskId,
    @required int subtaskId,
  }) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/$subtaskId';

  Future<String> updateSubtaskStatus({
    @required int taskId,
    @required int subtaskId,
  }) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/$subtaskId/status';

  Future<String> updateTask({@required int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId';

  Future<String> updateTaskStatusUrl({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/status';

  Future<String> createProjectUrl() async =>
      '${await getPortalURI()}/api/$version/project/withSecurity';

  Future<String> createTagUrl() async =>
      '${await getPortalURI()}/api/$version/project/tag';

  Future<String> projectByIDUrl(int projectId) async =>
      '${await getPortalURI()}/api/$version/project/$projectId';

  Future<String> updateProjectStatusUrl(int projectId) async =>
      '${await projectByIDUrl(projectId)}/status';

  Future<String> followProjectUrl(int projectId) async =>
      '${await projectByIDUrl(projectId)}/follow';

  Future<String> projectTeamUrl(String projectID) async =>
      '${await getPortalURI()}/api/$version/project/$projectID/team';

  Future<String> createMilestoneUrl(String projectID) async =>
      '${await getPortalURI()}/api/$version/project/$projectID/milestone';

  Future<String> getFolderByIdUrl({String folderId}) async =>
      '${await getPortalURI()}/api/$version/files/folder/$folderId';

  Future<String> getFileByIdUrl({String fileId}) async =>
      '${await getPortalURI()}/api/$version/files/file/$fileId';

  Future<String> getMoveOpsUrl() async =>
      '${await getPortalURI()}/api/$version/files/fileops/move';
  Future<String> getCopyOpsUrl() async =>
      '${await getPortalURI()}/api/$version/files/fileops/copy';

  Future<String> getFileOperationsUrl() async =>
      '${await getPortalURI()}/api/$version/files/fileops';

  Future<String> getProjectSecurityinfoUrl() async =>
      '${await getPortalURI()}/api/$version/project/securityinfo';

  Future<http.Response> getRequest(String url) async {
    print(url);
    var headers = await getHeaders();
    var request = client.get(Uri.parse(url), headers: headers);
    final response = await request;
    return response;
  }

  Future<http.Response> postRequest(String url, Map body) async {
    debugPrint(url);
    var headers = await getHeaders();
    var request = client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    final response = await request;
    return response;
  }

  Future<http.Response> putRequest(String url, {Map body = const {}}) async {
    print(url);
    var headers = await getHeaders();
    var request = client.put(
      Uri.parse(url),
      headers: headers,
      body: body.isEmpty ? null : jsonEncode(body),
    );
    final response = await request;
    return response;
  }

  Future<http.Response> deleteRequest(String url) async {
    print(url);
    var headers = await getHeaders();
    var request = client.delete(
      Uri.parse(url),
      headers: headers,
    );
    final response = await request;
    return response;
  }

  Future<String> getPortalURI() async {
    if (_portalName == null || _portalName.isEmpty) {
      _portalName = await _secureStorage.getString('portalName');
    }

    if (!_portalName.contains('http')) {
      _portalName = 'https://$_portalName';
      await savePortalName();
    }

    //TODO return Uri instead of string Uri.parse(_portalName)
    return _portalName;
  }

  Future<String> getToken() async {
    var token = await _secureStorage.getString('token');

    return token;
  }

  Future<void> savePortalName() async {
    await _secureStorage.putString('portalName', _portalName);
  }
}
