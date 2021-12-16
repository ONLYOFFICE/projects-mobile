/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/enums/viewstate.dart';
import 'package:projects/data/models/apiDTO.dart';
import 'package:projects/data/models/auth_token.dart';
import 'package:projects/data/models/from_api/capabilities.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/portal_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/portal_info_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/authentication/2fa_sms/2fa_sms_screen.dart';
import 'package:projects/presentation/views/authentication/2fa_sms/enter_sms_code_screen.dart';
import 'package:projects/presentation/views/authentication/code_view.dart';
import 'package:projects/presentation/views/authentication/code_views/get_code_views.dart';
import 'package:projects/presentation/views/authentication/login_view.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class LoginController extends GetxController {
  final AuthService _authService = locator<AuthService>();
  final PortalService _portalService = locator<PortalService>();
  final SecureStorage _secureStorage = locator<SecureStorage>();

  late TextEditingController portalAdressController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  TextEditingController get emailController => _emailController;

  TextEditingController get passwordController => _passwordController;

  RxBool portalFieldError = false.obs;
  RxBool emailFieldError = false.obs;
  RxBool passwordFieldError = false.obs;

  Capabilities? capabilities;
  String? _pass;
  String? _email;
  String? _tfaKey;

  String get portalAdress => portalAdressController.text.contains('//')
      ? portalAdressController.text.split('//')[1]
      : portalAdressController.text;
  String? get tfaKey => _tfaKey;

  final cookieManager = WebviewCookieManager();

  final checkBoxValue = false.obs;
  final needAgreement = Get.deviceLocale!.languageCode == 'zh';

  @override
  void onInit() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    portalAdressController = TextEditingController();
    super.onInit();
  }

  Future<void> loginByPassword() async {
    if (await _checkEmailAndPass()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      setState(ViewState.Busy);

      final result = await _authService.login(pass: password, email: email);

      if (result.response == null) {
        setState(ViewState.Idle);
        return;
      }
      if (result.response!.token != null) {
        await saveToken(result);
        await sendRegistrationType();
        setState(ViewState.Idle);
        clearInputFields();
        await AnalyticsService.shared.logEvent(AnalyticsService.Events.loginPortal,
            {AnalyticsService.Params.Key.portal: await _secureStorage.getString('portalName')});

        await cookieManager.setCookies([
          Cookie('asc_auth_key', result.response!.token!)
            ..domain = portalAdress
            ..expires = DateTime.now().add(const Duration(days: 10))
            ..httpOnly = false
        ]);

        locator<EventHub>().fire('loginSuccess');
      } else if (result.response!.tfa == true) {
        _email = email;
        _pass = password;
        setState(ViewState.Idle);

        if (result.response!.tfaKey != null) {
          _tfaKey = result.response!.tfaKey;
          await Get.to<GetCodeViews>(() => const GetCodeViews());
        } else {
          await Get.to<CodeView>(() => CodeView());
        }
      } else if (result.response!.sms == true) {
        _email = email;
        _pass = password;
        setState(ViewState.Idle);
        if (result.response!.phoneNoise != null) {
          await Get.to<EnterSMSCodeScreen>(
            () => const EnterSMSCodeScreen(),
            arguments: {
              'phoneNoise': result.response!.phoneNoise,
              'login': _email,
              'password': _pass
            },
          );
        } else {
          await Get.to<TFASmsScreen>(
            () => const TFASmsScreen(),
            arguments: {'login': _email, 'password': _pass},
          );
        }
      }
    }
  }

  Future<bool> _checkEmailAndPass() async {
    _emailController.text = _emailController.text.removeAllWhitespace;
    bool? result;

    emailFieldError.value = false;
    passwordFieldError.value = false;

    if (!_emailController.text.isEmail) {
      result = false;
      emailFieldError.value = true;
      // ignore: unawaited_futures
      900.milliseconds.delay().then((_) => emailFieldError.value = false);
      // save cursor position
      emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length),
      );
    }
    if (_passwordController.text.isEmpty) {
      result = false;
      passwordFieldError.value = true;
      // ignore: unawaited_futures
      900.milliseconds.delay().then((_) => passwordFieldError.value = false);
    }
    return result ?? true;
  }

  Future saveToken(ApiDTO<AuthToken> result) async {
    await _secureStorage.putString('token', result.response!.token);
    await _secureStorage.putString('expires', result.response!.expires);
  }

  Future<bool> sendCode(String code, {String? userName, String? password}) async {
    setState(ViewState.Busy);

    code = code.removeAllWhitespace;
    _email ??= userName;
    _pass ??= password;

    final result = await _authService.confirmTFACode(email: _email!, pass: _pass!, code: code);

    if (result.response == null) {
      setState(ViewState.Idle);
      return false;
    }

    if (result.response!.token != null) {
      await saveToken(result);
      await sendRegistrationType();
      setState(ViewState.Idle);
      clearInputFields();
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.loginPortal,
          {AnalyticsService.Params.Key.portal: await _secureStorage.getString('portalName')});
      locator<EventHub>().fire('loginSuccess');
    } else if (result.response!.tfa!) {
      setState(ViewState.Idle);
      await Get.to(() => CodeView());
      return true;
    }

    return false;
  }

  Future<void> getPortalCapabilities() async {
    if (needAgreement && !checkBoxValue.value) {
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('privacyAndTermsFooter.total'));
      return;
    }

    portalAdressController.text = portalAdressController.text.removeAllWhitespace;

    if (!(portalAdressController.text.isURL || portalAdressController.text.isIPv4)) {
      portalFieldError.value = true;
      // ignore: unawaited_futures
      900.milliseconds.delay().then((_) => portalFieldError.value = false);
      portalAdressController.selection = TextSelection.fromPosition(
        TextPosition(offset: portalAdressController.text.length),
      );
    } else {
      setState(ViewState.Busy);

      locator.get<CoreApi>().setPortalName(portalAdressController.text);

      final _capabilities = await _portalService.portalCapabilities();

      if (_capabilities != null) {
        capabilities = _capabilities;
        checkBoxValue.value = false;
        setState(ViewState.Idle);
        await Get.to(() => const LoginView());
      }

      setState(ViewState.Idle);
    }
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Введите корректный email';

    /// regex pattern to validate email inputs.
    const Pattern _emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]";

    if (RegExp(_emailPattern as String).hasMatch(value)) return null;

    return 'Введите корректный email';
  }

  String? passValidator(String? value) {
    if (value == null || value.isEmpty) return 'Введите пароль';
    return null;
  }

  Rx<ViewState> get state => ViewState.Idle.obs;

  void setState(ViewState viewState) {
    state.value = viewState;
  }

  Future<bool> sendRegistrationType() async {
    final result = await _authService.sendRegistrationType();
    return result != null;
  }

  Future<void> logout() async {
    final storage = locator<Storage>();

    locator.get<CoreApi>().cancellationToken.cancel();

    await _secureStorage.delete('expires');
    await _secureStorage.delete('portalName');
    await _secureStorage.delete('token');

    await storage.remove('taskFilters');
    await storage.remove('projectFilters');
    await storage.remove('discussionFilters');

    await cookieManager.clearCookies();

    Get.find<PortalInfoController>().logout();
    Get.find<UserController>().clear();

    locator<EventHub>().fire('logoutSuccess');
  }

  // TODO: check dispose textControllers
  @override
  void onClose() {
    // clearInputFields();
    clearErrors();
    super.onClose();
  }

  void clearInputFields() {
    portalAdressController.clear();
    _emailController.clear();
    _passwordController.clear();
    clearErrors();
  }

  void clearErrors() {
    portalFieldError.value = false;
    emailFieldError.value = false;
    passwordFieldError.value = false;
  }
}
