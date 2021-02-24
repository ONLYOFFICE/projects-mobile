import 'dart:async';

import 'package:only_office_mobile/data/api/authentication_api.dart';
import 'package:only_office_mobile/data/models/authDTO.dart';
import 'package:only_office_mobile/data/models/user.dart';
import 'package:only_office_mobile/internal/locator.dart';

class AuthenticationService {
  AuthApi _api = locator<AuthApi>();

  StreamController<User> userController = StreamController<User>();

  Future<bool> login(String email, String pass, String portalName) async {
    AuthDTO authResponse = await _api.loginByUsername(email, pass, portalName);

    var tokenReceived = authResponse.authToken != null;

    if (tokenReceived) {
      userController.add(new User(id: 111, name: 'bill', username: 'gates'));
    } else {
      userController.addError(authResponse.error);
    }
    return tokenReceived;
  }
}
