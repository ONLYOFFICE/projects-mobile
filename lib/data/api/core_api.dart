import 'package:http/http.dart' as http;
import 'package:projects/data/services/storage.dart';
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

  Future<String> allGroups() async =>
      '${await getPortalURI()}/api/$version/group';

  Future<String> addTaskUrl({projectId}) async =>
      '${await getPortalURI()}/api/$version/project/$projectId/task';

  Future<String> allProfiles() async =>
      '${await getPortalURI()}/api/$version/people';

  Future<String> authUrl() async =>
      '${await getPortalURI()}/api/$version/authentication.json';

  Future<String> deleteTask({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId';

  Future<String> getTaskFiles({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/files';

  Future<String> milestonesByFilter() async =>
      '${await getPortalURI()}/api/$version/project/milestone/filter';

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

  Future<String> projectTags() async =>
      '${await getPortalURI()}/api/$version/project/tag';

  Future<String> selfInfoUrl() async =>
      '${await getPortalURI()}/api/$version/people/@self';

  Future<String> statusesUrl() async =>
      '${await getPortalURI()}/api/$version/project/status';

  Future<String> subscribeTask({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/subscribe';

  Future<String> updateTaskStatusUrl({int taskId}) async =>
      '${await getPortalURI()}/api/$version/project/task/$taskId/status';

  Future<String> createProjectUrl() async =>
      '${await getPortalURI()}/api/$version/project/withSecurity';
  Future<String> projectTeamUrl(String projectID) async =>
      '${await getPortalURI()}/api/$version/project/$projectID/team';

  Future<http.Response> getRequest(String url) async {
    print(url);
    var headers = await getHeaders();
    var request = client.get(Uri.parse(url), headers: headers);
    final response = await request;
    return response;
  }

  Future<http.Response> postRequest(String url, String body) async {
    var headers = await getHeaders();
    var request = client.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    final response = await request;
    return response;
  }

  Future<http.Response> putRequest(String url, {Map body = const {}}) async {
    var headers = await getHeaders();
    var request = client.put(
      Uri.parse(url),
      headers: headers,
      body: body.isEmpty ? null : body.toString(),
    );
    final response = await request;
    return response;
  }

  Future<http.Response> deleteRequest(String url) async {
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
