import 'package:http/http.dart' as http;

class CoreApi {
  var client = new http.Client();

  Map<String, String> headers() {
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    };
  }

  String getAuthUrl(String portalName) =>
      'https://$portalName/api/2.0/authentication.json';

  Future<http.Response> post(String url, String body) async {
    var post = client.post(
      url,
      headers: headers(),
      body: body,
    );
    final http.Response response = await post;
    return response;
  }
}
