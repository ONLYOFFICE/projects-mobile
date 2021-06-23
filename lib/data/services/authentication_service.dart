import 'dart:async';

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

    var tokenReceived = authResponse.response != null;

    if (!tokenReceived) {
      await ErrorDialog.show(authResponse.error);
    }
    return authResponse;
  }

  Future<ApiDTO<AuthToken>> login(String email, String pass) async {
    var authResponse = await _api.loginByUsername(email, pass);

    var tokenReceived = authResponse.response != null;

    if (!tokenReceived) {
      await ErrorDialog.show(authResponse.error);
    }
    return authResponse;
  }

  Future<ApiDTO<AuthToken>> confirmTFACode(
      String email, String pass, String code) async {
    var authResponse = await _api.confirmTFACode(email, pass, code);

    var tokenReceived = authResponse.response != null;

    if (!tokenReceived) {
      await ErrorDialog.show(authResponse.error);
    }
    return authResponse;
  }
}
