import 'package:http/http.dart' as http;
import 'package:projects/data/services/storage.dart';
import 'package:projects/internal/locator.dart';

class CoreApi {
  var client = http.Client();
  var _storage = locator<Storage>();
  String _portalName;

  Future<Map<String, String>> getHeaders() async {
    var token = await getToken();
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': token
    };
  }

  String capabilitiesUrl(String portalName) =>
      'https://$portalName/api/2.0/capabilities';

  Future<String> authUrl() async =>
      '${await getPortalURI()}/api/2.0/authentication.json';

  Future<String> tfaUrl(String code) async =>
      '${await getPortalURI()}/api/2.0/authentication/$code';

  Future<String> projectsByParamsUrl(String params) async =>
      '${await getPortalURI()}/api/2.0/project/filter?$params';

  Future<String> tasksByFilterUrl(String params) async =>
      '${await getPortalURI()}/api/2.0/project/task/filter?$params';

  Future<String> projectsUrl() async =>
      '${await getPortalURI()}/api/2.0/project';

  Future<String> selfInfoUrl() async =>
      '${await getPortalURI()}/api/2.0/people/@self';

  Future<String> statusesUrl() async =>
      '${await getPortalURI()}/api/2.0/project/status';

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

  Future<String> getPortalURI() async {
    if (_portalName == null || _portalName.isEmpty) {
      _portalName = await _storage.getString('portalName');
    }

    return 'https://${_portalName}';
  }

  Future<String> getToken() async {
    String token = await _storage.getString('token');

    return token;
  }
}
