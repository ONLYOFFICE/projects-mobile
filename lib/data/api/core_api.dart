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

  String capabilitiesUrl(String portalName) =>
      'https://$portalName/api/$version/capabilities';

  Future<String> allProfiles() async =>
      '${await getPortalURI()}/api/2.0/people';

  Future<String> authUrl() async =>
      '${await getPortalURI()}/api/$version/authentication.json';

  Future<String> tfaUrl(String code) async =>
      '${await getPortalURI()}/api/$version/authentication/$code';

  Future<String> projectsByParamsBaseUrl() async =>
      '${await getPortalURI()}/api/$version/project/filter?';

  Future<String> tasksByFilterUrl(String params) async =>
      '${await getPortalURI()}/api/$version/project/task/filter?$params';

  Future<String> taskByIdUrl(int id) async =>
      '${await getPortalURI()}/api/$version/project/task/$id';

  Future<String> projectsUrl() async =>
      '${await getPortalURI()}/api/$version/project';

  Future<String> selfInfoUrl() async =>
      '${await getPortalURI()}/api/$version/people/@self';

  Future<String> statusesUrl() async =>
      '${await getPortalURI()}/api/$version/project/status';

  Future<String> updateTaskStatusUrl({int taskId}) async =>
      '${await getPortalURI()}/api/2.0/project/task/$taskId/status';

  Future<http.Response> getRequest(String url) async {
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

  Future<http.Response> putRequest(String url, Map body) async {
    var headers = await getHeaders();
    var request = client.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    final response = await request;
    return response;
  }

  Future<String> getPortalURI() async {
    if (_portalName == null || _portalName.isEmpty) {
      _portalName = await _secureStorage.getString('portalName');
    }

    return 'https://$_portalName';
  }

  Future<String> getToken() async {
    var token = await _secureStorage.getString('token');

    return token;
  }
}
