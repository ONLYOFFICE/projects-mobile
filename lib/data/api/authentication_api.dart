import 'dart:convert';

import 'package:only_office_mobile/data/models/apiDTO.dart';
import 'package:only_office_mobile/data/models/auth_token.dart';
import 'package:only_office_mobile/data/models/user.dart';
import 'package:only_office_mobile/internal/locator.dart';
import 'package:only_office_mobile/data/api/core_api.dart';
import 'package:only_office_mobile/data/models/error.dart';

class AuthApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<AuthToken>> loginByUsername(String email, String pass) async {
    var url = coreApi.authUrl();
    var body =
        jsonEncode(<String, String>{'userName': email, 'password': pass});

    var result = new ApiDTO<AuthToken>();
    try {
      var response = await coreApi.postRequest(url, body);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 201) {
        result.response = AuthToken.fromJson(responseJson);
      } else {
        result.error = CustomError.fromJson(responseJson);
      }
    } catch (e) {
      result.error = new CustomError(message: 'Ошибка');
    }

    return result;
  }

  Future<ApiDTO<AuthToken>> confirmTFACode(
    String email,
    String pass,
    String code,
  ) async {
    var url = coreApi.tfaUrl(code);
    var body = jsonEncode(<String, String>{
      'userName': email,
      'password': pass,
      'accessToken': '',
      'provider': ''
    });

    var result = new ApiDTO<AuthToken>();
    try {
      var response = await coreApi.postRequest(url, body);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 201) {
        result.response = AuthToken.fromJson(responseJson);
      } else {
        result.error = CustomError.fromJson(responseJson);
      }
    } catch (e) {
      result.error = new CustomError(message: 'Ошибка');
    }

    return result;
  }
}
