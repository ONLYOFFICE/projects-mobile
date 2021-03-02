import 'dart:async';

import 'package:get/get.dart';
import 'package:only_office_mobile/data/enums/viewstate.dart';
import 'package:only_office_mobile/data/models/capabilities.dart';
import 'package:only_office_mobile/data/services/authentication_service.dart';
import 'package:only_office_mobile/data/services/portal_service.dart';
import 'package:only_office_mobile/internal/locator.dart';

class LoginController extends GetxController {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final PortalService _portalService = locator<PortalService>();

  Capabilities capabilities;

  String _portalName;

  Future<bool> loginByPassword(String email, String password) async {
    setState(ViewState.Busy);

    var result =
        await _authenticationService.login(email, password, _portalName);

    // TODO Handle potential error here too.

    setState(ViewState.Idle);
    return result.response != null;
  }

  getPortalCapabilities(String portalName) async {
    setState(ViewState.Busy);
    _portalName = portalName;

    var _capabilities = await _portalService.portalCapabilities(portalName);

    if (_capabilities != null) {
      capabilities = _capabilities;
      Get.toNamed('LoginView');
    }

    setState(ViewState.Idle);
    return true;
  }

  String emailValidator(value) {
    if (value.isEmpty) return 'Введите корректный email';

    /// regex pattern to validate email inputs.
    final Pattern _emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]";

    if (RegExp(_emailPattern).hasMatch(value)) return null;

    return 'Введите корректный email';
  }

  String passValidator(value) {
    if (!value.isEmpty) return null;
    return 'Введите пароль';
  }

  var state = ViewState.Idle.obs;

  void setState(ViewState viewState) {
    state.value = viewState;
  }
}
