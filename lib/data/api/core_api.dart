import 'package:http/http.dart' as http;

class CoreApi {
  var client = new http.Client();

  Map<String, String> headers() {
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    };
  }

  String authUrl(String portalName) =>
      'https://$portalName/api/2.0/authentication.json';

  String capabilitiesUrl(String portalName) =>
      'https://$portalName/api/2.0/capabilities';

  Future<http.Response> getRequest(String url) async {
    var request = client.get(
      url,
      headers: headers(),
    );
    final http.Response response = await request;
    return response;
  }

  Future<http.Response> postRequest(String url, String body) async {
    var request = client.post(
      url,
      headers: headers(),
      body: body,
    );
    final http.Response response = await request;
    return response;
  }
}
