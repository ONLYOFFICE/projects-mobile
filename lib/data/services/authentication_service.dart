import 'dart:async';

import 'package:get/get.dart';
import 'package:projects/data/api/authentication_api.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/auth_token.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/locator.dart';

class AuthService {
  final AuthApi _api = locator<AuthApi>();

  Future<ApiDTO<PortalUser>> getSelfInfo() async {
    var authResponse = await _api.getUserInfo();

    var result = authResponse.response != null;

    if (!result) {
      await Get.find<ErrorDialog>().show(authResponse.error.message);
    }
    return authResponse;
  }

  Future<bool> checkAuthorization() async {
    var authResponse = await _api.getUserInfo();

    if (authResponse.response == null) {
      if (authResponse.error.message.toLowerCase().contains('unauthorized'))
        return false;
      else
        await Get.find<ErrorDialog>().show(authResponse.error.message);
    }
    return true;
  }

  Future<ApiDTO<AuthToken>> login(String email, String pass) async {
    var authResponse = await _api.loginByUsername(email, pass);

    var tokenReceived = authResponse.response != null;

    if (!tokenReceived) {
      await Get.find<ErrorDialog>().show(authResponse.error.message);
    }
    return authResponse;
  }

  Future<ApiDTO<AuthToken>> confirmTFACode(
      String email, String pass, String code) async {
    var authResponse = await _api.confirmTFACode(email, pass, code);

    var tokenReceived = authResponse.response != null;

    if (!tokenReceived) {
      await Get.find<ErrorDialog>().show(authResponse.error.message);
    }
    return authResponse;
  }

  Future passwordRecovery(String email) async {
    var response = await _api.passwordRecovery(email);

    var success = response.response != null;

    if (!success) {
      await Get.find<ErrorDialog>().show(response.error.message);
      return null;
    } else {
      return response;
    }
  }

  Future sendRegistrationType() async {
    var response = await _api.sendRegistrationType();

    var success = response.response != null;

    if (!success) {
      await Get.find<ErrorDialog>().show(response.error.message);
      return null;
    } else {
      return response;
    }
  }
}
