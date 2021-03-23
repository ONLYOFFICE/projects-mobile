import 'dart:async';

import 'package:get/get.dart';
import 'package:projects/data/enums/viewstate.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/auth_token.dart';
import 'package:projects/data/models/from_api/capabilities.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/portal_service.dart';
import 'package:projects/data/services/storage.dart';
import 'package:projects/internal/locator.dart';

class LoginController extends GetxController {
  final AuthService _authService = locator<AuthService>();
  final PortalService _portalService = locator<PortalService>();
  final Storage _storage = locator<Storage>();

  Capabilities capabilities;
  String _pass;
  String _email;

  bool _tokenExpired;

  @override
  void onInit() {
    super.onInit();
    setState(ViewState.Busy);
    isTokenExpired().then(
      (value) => {
        _tokenExpired = value,
        setState(ViewState.Idle),
        if (!_tokenExpired) Get.offNamed('NavigationView'),
      },
    );
  }

  Future<void> loginByPassword(String email, String password) async {
    setState(ViewState.Busy);

    var result = await _authService.login(email, password);

    if (result.response == null) {
      setState(ViewState.Idle);
      return;
    }

    if (result.response.token != null) {
      await saveToken(result);
      await Get.offNamed('NavigationView');
      setState(ViewState.Idle);
    } else if (result.response.tfa) {
      _email = email;
      _pass = password;

      await Get.toNamed('CodeView');
      setState(ViewState.Idle);
    }
    setState(ViewState.Idle);
  }

  Future saveToken(ApiDTO<AuthToken> result) async {
    await _storage.putString('token', result.response.token);
    await _storage.putString('expires', result.response.expires);
  }

  Future<void> sendCode(String code) async {
    setState(ViewState.Busy);

    var result = await _authService.confirmTFACode(_email, _pass, code);

    if (result.response == null) {
      setState(ViewState.Idle);
      return;
    }

    if (result.response.token != null) {
      await saveToken(result);
      await Get.offNamed('NavigationView');
      setState(ViewState.Idle);
    } else if (result.response.tfa) {
      setState(ViewState.Idle);
      await Get.toNamed('CodeView');
    }
  }

  Future<void> loginByProvider(String provider) async {
    switch (provider) {
      case 'google':
        // try {
        //   var result = await _authService.signInWithGoogle();
        // } catch (e) {}

        break;
      case 'facebook':
      // var result = await _authenticationService.signInWithFacebook();
      // break;
      case 'twitter':
      // var result = await _authenticationService.signInWithTwitter();
      // break;
      case 'linkedin':

      case 'mailru':

      case 'vk':

      case 'yandex':

      case 'gosuslugi':

      default:
    }
  }

  Future<bool> getPortalCapabilities(String portalName) async {
    setState(ViewState.Busy);

    var _capabilities = await _portalService.portalCapabilities(portalName);

    if (_capabilities != null) {
      capabilities = _capabilities;
      await Get.toNamed('LoginView');
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

  Future<bool> isTokenExpired() async {
    var expirationDate = await _storage.getString('expires');
    var token = await _storage.getString('token');
    var portalName = await _storage.getString('portalName');

    if (expirationDate == null ||
        expirationDate.isEmpty ||
        token == null ||
        token.isEmpty ||
        portalName == null ||
        portalName.isEmpty) return true;

    var expiration = DateTime.parse(expirationDate);
    if (expiration.isBefore(DateTime.now())) return true;

    return false;
  }
}
