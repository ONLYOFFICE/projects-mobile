import 'dart:async';

import 'package:get/get.dart';
import 'package:only_office_mobile/data/enums/viewstate.dart';
import 'package:only_office_mobile/data/models/capabilities.dart';
import 'package:only_office_mobile/data/services/authentication_service.dart';
import 'package:only_office_mobile/data/services/portal_service.dart';
import 'package:only_office_mobile/data/services/secure_storage.dart';
import 'package:only_office_mobile/internal/locator.dart';

class LoginController extends GetxController {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final PortalService _portalService = locator<PortalService>();
  final Storage _secureStorage = locator<Storage>();

  Capabilities capabilities;
  String _portalName;
  String _pass;
  String _email;

  bool _tokenExpired;

  @override
  void onInit() {
    super.onInit();
    setState(ViewState.Busy);
    Future.wait([isTokenExpired()]).then((value) => {
          _tokenExpired = value[0],
          setState(ViewState.Idle),
          if (!_tokenExpired) Get.offNamed('NavigationView'),
        });
  }

  Future<bool> loginByPassword(String email, String password) async {
    setState(ViewState.Busy);

    var result = await _authenticationService.login(email, password);

    if (result.response.token != null) {
      setState(ViewState.Idle);
      Get.offNamed('NavigationView');
    } else if (result.response.tfa) {
      setState(ViewState.Idle);
      _email = email;
      _pass = password;

      Get.toNamed('CodeView');
    }
    setState(ViewState.Idle);
  }

  Future<bool> sendCode(String code) async {
    setState(ViewState.Busy);

    var result =
        await _authenticationService.confirmTFACode(_email, _pass, code);

    if (result.response.token != null) {
      setState(ViewState.Idle);
      Get.toNamed('HomeView');
    } else if (result.response.tfa) {
      setState(ViewState.Idle);
      Get.toNamed('CodeView');
    }
  }

  Future<void> loginByProvider(String provider) async {
    switch (provider) {
      case 'google':
        try {
          var result = await _authenticationService.signInWithGoogle();
        } catch (e) {}

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

  Future<bool> isTokenExpired() async {
    String expirationDate = await _secureStorage.getString('expires');
    String token = await _secureStorage.getString('token');
    String portalName = await _secureStorage.getString('portalName');

    if (expirationDate == null ||
        expirationDate.isEmpty ||
        token == null ||
        token.isEmpty ||
        portalName == null ||
        portalName.isEmpty) return true;

    DateTime expiration = DateTime.parse(expirationDate);
    if (expiration.isBefore(DateTime.now())) return true;

    return false;
  }
}
