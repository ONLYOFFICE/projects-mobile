import 'dart:async';

import 'package:only_office_mobile/data/api/authentication_api.dart';
import 'package:only_office_mobile/data/models/apiDTO.dart';
import 'package:only_office_mobile/data/models/auth_token.dart';
import 'package:only_office_mobile/domain/dialogs.dart';
import 'package:only_office_mobile/internal/locator.dart';

class AuthenticationService {
  AuthApi _api = locator<AuthApi>();

  Future<ApiDTO<AuthToken>> login(
      String email, String pass, String portalName) async {
    ApiDTO<AuthToken> authResponse =
        await _api.loginByUsername(email, pass, portalName);

    var tokenReceived = authResponse.response != null;

    if (!tokenReceived) {
      ErrorDialog.show(authResponse.error);
    }
    return authResponse;
  }
}
