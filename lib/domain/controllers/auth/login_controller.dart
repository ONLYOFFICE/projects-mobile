import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/viewstate.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/auth_token.dart';
import 'package:projects/data/models/from_api/capabilities.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/portal_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/authentication/2fa_sms/2fa_sms_screen.dart';
import 'package:projects/presentation/views/authentication/2fa_sms/enter_sms_code_screen.dart';
import 'package:projects/presentation/views/authentication/code_view.dart';
import 'package:projects/presentation/views/authentication/code_views/get_code_views.dart';
import 'package:projects/presentation/views/authentication/login_view.dart';
import 'package:projects/presentation/views/navigation_view.dart';

class LoginController extends GetxController {
  final AuthService _authService = locator<AuthService>();
  final PortalService _portalService = locator<PortalService>();
  final SecureStorage _secureStorage = locator<SecureStorage>();

  TextEditingController _portalAdressController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController get portalAdressController => _portalAdressController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  var portalFieldError = false.obs;
  var emailFieldError = false.obs;
  var passwordFieldError = false.obs;

  Capabilities capabilities;
  String _pass;
  String _email;
  String _tfaKey;

  bool _tokenExpired;

  String get portalAdress =>
      portalAdressController.text.replaceFirst('https://', '');
  String get tfaKey => _tfaKey;

  @override
  void onInit() {
    _portalAdressController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.onInit();
  }

  Future<void> loginByPassword() async {
    if (_checkEmailAndPass()) {
      var email = _emailController.text;
      var password = _passwordController.text;

      setState(ViewState.Busy);

      var result = await _authService.login(email, password);

      if (result.response == null) {
        setState(ViewState.Idle);
        return;
      }
      if (result.response.token != null) {
        await saveToken(result);
        // need to save the token to send the device type
        if (await sendRegistrationType()) {
          setState(ViewState.Idle);
          clearInputFields();
          await AnalyticsService.shared.logEvent(
              AnalyticsService.Events.loginPortal, {
            AnalyticsService.Params.Key.portal:
                await _secureStorage.getString('portalName')
          });
          await Get.offAll(() => NavigationView()); //fix
        } else {
          // if the device type has not been sent, the token must be deleted
          await logout();
        }
      } else if (result.response.tfa == true) {
        _email = email;
        _pass = password;
        setState(ViewState.Idle);

        if (result.response.tfaKey != null) {
          _tfaKey = result.response.tfaKey;
          await Get.to(() => const GetCodeViews());
        } else {
          await Get.to(() => CodeView());
        }
      } else if (result.response.sms == true) {
        _email = email;
        _pass = password;
        setState(ViewState.Idle);
        if (result.response.phoneNoise != null) {
          await Get.to(() => const EnterSMSCodeScreen(), arguments: {
            'phoneNoise': result.response.phoneNoise,
            'login': _email,
            'password': _pass
          });
        } else {
          await Get.to(() => const TFASmsScreen(),
              arguments: {'login': _email, 'password': _pass});
        }
      }
    }
  }

  bool _checkEmailAndPass() {
    _emailController.text = _emailController.text.removeAllWhitespace;
    var result;

    emailFieldError.value = false;
    passwordFieldError.value = false;

    if (!_emailController.text.isEmail) {
      result = false;
      emailFieldError.value = true;
    }
    if (_passwordController.text.isEmpty) {
      result = false;
      passwordFieldError.value = true;
    }
    return result ?? true;
  }

  Future saveToken(ApiDTO<AuthToken> result) async {
    await _secureStorage.putString('token', result.response.token);
    await _secureStorage.putString('expires', result.response.expires);
  }

  Future<bool> sendCode(String code, {String userName, String password}) async {
    setState(ViewState.Busy);

    code = code.removeAllWhitespace;
    _email ??= userName;
    _pass ??= password;

    var result = await _authService.confirmTFACode(_email, _pass, code);

    if (result.response == null) {
      setState(ViewState.Idle);
      return false;
    }

    if (result.response.token != null) {
      await saveToken(result);
      // need to save the token to send the device type
      if (await sendRegistrationType()) {
        setState(ViewState.Idle);
        clearInputFields();
        await AnalyticsService.shared.logEvent(
            AnalyticsService.Events.loginPortal, {
          AnalyticsService.Params.Key.portal:
              await _secureStorage.getString('portalName')
        });
        await Get.offAllNamed('NavigationView');
        return true;
      } else {
        // if the device type has not been sent, the token must be deleted
        await logout();
      }
    } else if (result.response.tfa) {
      setState(ViewState.Idle);
      await Get.to(() => CodeView());
      return true;
    }

    return false;
  }

  Future<void> loginByProvider(String provider) async {
    switch (provider) {
      case 'google':
        // try {
        //   var result = await _authService.signInWithGoogle();
        // } catch (e) {debugPrint(e);}

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
    _portalAdressController.text =
        _portalAdressController.text.removeAllWhitespace;

    if (!_portalAdressController.text.isURL) {
      portalFieldError.value = true;
    } else {
      setState(ViewState.Busy);

      var _capabilities =
          await _portalService.portalCapabilities(_portalAdressController.text);

      if (_capabilities != null) {
        capabilities = _capabilities;
        setState(ViewState.Idle);
        await Get.to(() => LoginView());
      } else {
        // to prevent socket exception
        _portalAdressController.dispose();
        _portalAdressController = TextEditingController();
      }

      setState(ViewState.Idle);
    }
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

  Future<bool> get isLoggedIn async => !await isTokenExpired();

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

  Future<bool> sendRegistrationType() async {
    var result = await _authService.sendRegistrationType();
    return result != null;
  }

  Future<void> logout() async {
    var storage = locator<Storage>();

    await _secureStorage.delete('expires');
    await _secureStorage.delete('portalName');
    await _secureStorage.delete('token');

    await storage.remove('taskFilters');
    await storage.remove('projectFilters');
    await storage.remove('discussionFilters');

    Get.find<PortalInfoController>().logout();
    Get.find<NavigationController>().clearCurrentIndex();
  }

  @override
  void onClose() {
    // clearInputFields();z
    _clearErrors();
    _tokenExpired = null;
    super.onClose();
  }

  void clearInputFields() {
    _portalAdressController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  void _clearErrors() {
    portalFieldError.value = false;
    emailFieldError.value = false;
    passwordFieldError.value = false;
  }
}
