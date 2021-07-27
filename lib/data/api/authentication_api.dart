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
    var body = {'userName': email, 'password': pass};

    var result = ApiDTO<AuthToken>();
    try {
      var response = await coreApi.postRequest(url, body);

      if (response.statusCode == 500) {
        var message = json.decode(response.body)['error']['message'];
        result.error = CustomError(message: message);
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
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO<AuthToken>> confirmTFACode(
    String email,
    String pass,
    String code,
  ) async {
    var url = await coreApi.tfaUrl(code);
    var body = {
      'userName': email,
      'password': pass,
      'accessToken': '',
      'provider': ''
    };

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
      result.error = CustomError(message: e.toString());
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
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> setPhone(Map body) async {
    var url = await coreApi.setPhoneUrl();

    var result = ApiDTO();
    try {
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = AuthToken.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> sendSms(Map body) async {
    var url = await coreApi.sendSmsUrl();

    var result = ApiDTO();
    try {
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = AuthToken.fromJson(responseJson['response']);
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }

  Future<ApiDTO> passwordRecovery(String email) async {
    var url = await coreApi.passwordRecoveryUrl();

    var result = ApiDTO();

    var body = {'email': email};

    try {
      var response = await coreApi.postRequest(url, body);
      final Map responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.response = responseJson['response'];
      } else {
        result.error = CustomError.fromJson(responseJson['error']);
      }
    } catch (e) {
      result.error = CustomError(message: e.toString());
    }

    return result;
  }
}
