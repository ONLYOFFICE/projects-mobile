import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/auth_token.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class AuthApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<AuthToken>> loginByUsername(String email, String pass) async {
    var url = await coreApi.authUrl();
    var body =
        jsonEncode(<String, String>{'userName': email, 'password': pass});

    var result = ApiDTO<AuthToken>();
    try {
      var response = await coreApi.postRequest(url, body);

      if (response.statusCode == 500) {
        result.error = CustomError(message: response.reasonPhrase);
        return result;
      }
      if (response.statusCode == 201) {
        result.response =
            // ignore: avoid_dynamic_calls
            AuthToken.fromJson(json.decode(response.body)['response']);
      } else {
        result.error = CustomError.fromJson(json.decode(response.body));
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }

    return result;
  }

  Future<ApiDTO<AuthToken>> confirmTFACode(
    String email,
    String pass,
    String code,
  ) async {
    var url = await coreApi.tfaUrl(code);
    var body = jsonEncode(<String, String>{
      'userName': email,
      'password': pass,
      'accessToken': '',
      'provider': ''
    });

    var result = ApiDTO<AuthToken>();
    try {
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 201) {
        result.response = AuthToken.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }

    return result;
  }

  Future<ApiDTO<PortalUser>> getUserInfo() async {
    var url = await coreApi.selfInfoUrl();

    var result = ApiDTO<PortalUser>();
    try {
      var response = await coreApi.getRequest(url);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = PortalUser.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: 'Ошибка');
    }

    return result;
  }
}
