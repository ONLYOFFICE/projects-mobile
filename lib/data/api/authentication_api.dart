import 'dart:convert';

import 'package:only_office_mobile/data/models/authDTO.dart';
import 'package:only_office_mobile/data/models/auth_token.dart';
import 'package:only_office_mobile/data/models/user.dart';
import 'package:only_office_mobile/internal/locator.dart';
import 'package:only_office_mobile/data/api/core_api.dart';
import 'package:only_office_mobile/data/models/error.dart';

class AuthApi {
  var coreApi = locator<CoreApi>();

  Future<AuthDTO> loginByUsername(
      String email, String pass, String portalName) async {
    var url = coreApi.getAuthUrl(portalName);
    var body =
        jsonEncode(<String, String>{'userName': email, 'password': pass});

    var result = new AuthDTO();
    try {
      var response = await coreApi.post(url, body);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 201) {
        result.authToken = AuthToken.fromJson(responseJson);
      } else {
        result.error = PortalError.fromJson(responseJson);
      }
    } catch (e) {
      result.error = new PortalError(message: 'Чтото пошло не так');
    }

    return result;
  }

  Future<User> getUserProfile(int userId) async {
    return new User(id: 1123, name: "test", username: "testing");
  }
}
