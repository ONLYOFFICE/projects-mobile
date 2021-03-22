import 'dart:convert';

import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/auth_token.dart';
import 'package:projects/data/models/from_api/self_user_profile.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/error.dart';

class AuthApi {
  var coreApi = locator<CoreApi>();

  Future<ApiDTO<AuthToken>> loginByUsername(String email, String pass) async {
    var url = await coreApi.authUrl();
    var body =
        jsonEncode(<String, String>{'userName': email, 'password': pass});

    var result = new ApiDTO<AuthToken>();
    try {
      var response = await coreApi.postRequest(url, body);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 201) {
        result.response = AuthToken.fromJson(responseJson['response']);
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
    var url = await coreApi.tfaUrl(code);
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

  Future<ApiDTO<SelfUserProfile>> getUserInfo() async {
    var url = await coreApi.selfInfoUrl();

    var result = new ApiDTO<SelfUserProfile>();
    try {
      var response = await coreApi.getRequest(url);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        result.response = SelfUserProfile.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson);
      }
    } catch (e) {
      result.error = new CustomError(message: 'Ошибка');
    }

    return result;
  }
}
