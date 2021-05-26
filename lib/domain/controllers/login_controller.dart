import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/viewstate.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/auth_token.dart';
import 'package:projects/data/models/from_api/capabilities.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/portal_service.dart';
import 'package:projects/data/services/storage.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';
import 'package:projects/internal/locator.dart';

class LoginController extends GetxController {
  final AuthService _authService = locator<AuthService>();
  final PortalService _portalService = locator<PortalService>();
  final SecureStorage _secureStorage = locator<SecureStorage>();

  final TextEditingController _portalAdressController = TextEditingController();
  TextEditingController get portalAdressController => _portalAdressController;

  var portalFieldIsEmpty = true.obs;

  Capabilities capabilities;
  String _pass;
  String _email;

  bool _tokenExpired;

  String get portalAdress =>
      portalAdressController.text.replaceFirst('https://', '');

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
      setState(ViewState.Idle);
      await Get.offNamed('NavigationView');
    } else if (result.response.tfa) {
      _email = email;
      _pass = password;

      setState(ViewState.Idle);
      await Get.toNamed('CodeView');
    }
    setState(ViewState.Idle);
  }

  Future saveToken(ApiDTO<AuthToken> result) async {
    await _secureStorage.putString('token', result.response.token);
    await _secureStorage.putString('expires', result.response.expires);
  }

  Future<void> sendCode(String code) async {
    setState(ViewState.Busy);

    code = code.removeAllWhitespace;

    var result = await _authService.confirmTFACode(_email, _pass, code);

    if (result.response == null) {
      setState(ViewState.Idle);
      return;
    }

    if (result.response.token != null) {
      await saveToken(result);
      setState(ViewState.Idle);
      await Get.offNamed('NavigationView');
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

  Future<void> getPortalCapabilities() async {
    setState(ViewState.Busy);

    var _capabilities =
        await _portalService.portalCapabilities(_portalAdressController.text);

    if (_capabilities != null) {
      capabilities = _capabilities;
      setState(ViewState.Idle);
      await Get.toNamed('LoginView');
    }

    setState(ViewState.Idle);
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
    var expirationDate = await _secureStorage.getString('expires');
    var token = await _secureStorage.getString('token');
    var portalName = await _secureStorage.getString('portalName');

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

  Future<void> logout() async {
    await _secureStorage.deleteAll();
    Get.find<PortalInfoController>().logout();
    Get.find<NavigationController>().clearCurrentIndex();
  }
}
