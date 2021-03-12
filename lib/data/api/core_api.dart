import 'package:http/http.dart' as http;
import 'package:only_office_mobile/data/services/secure_storage.dart';
import 'package:only_office_mobile/internal/locator.dart';

class CoreApi {
  var client = new http.Client();
  var _secureStorage = locator<Storage>();
  String _portalName;

  CoreApi() {
    _secureStorage
        .getString('portalName')
        .then((value) => {_portalName = value});
  }

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

  String authUrl() => '${getPortalURI()}/api/2.0/authentication.json';

  String tfaUrl(String code) =>
      '${getPortalURI()}/api/2.0/authentication/${code}';

  String filteredProjectsUrl(String params) =>
      '${getPortalURI()}/api/2.0/project/filter?${params}';
  String projectsUrl() => '${getPortalURI()}/api/2.0/project';

  Future<http.Response> getRequest(String url) async {
    var headers = await getHeaders();
    var request = client.get(Uri.parse(url), headers: headers);
    final http.Response response = await request;
    return response;
  }

  Future<http.Response> postRequest(String url, String body) async {
    var headers = await getHeaders();
    var request = client.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    final http.Response response = await request;
    return response;
  }

  String getPortalURI() {
    if (_portalName == null || _portalName.isEmpty) {
      _secureStorage
          .getString('portalName')
          .then((value) => {_portalName = value});
    }

    return 'https://${_portalName}';
  }

  Future<String> getToken() async {
    String token = await _secureStorage.getString('token');

    return token;
  }
}
