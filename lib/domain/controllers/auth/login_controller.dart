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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/data/services/portal_service.dart';
import 'package:projects/data/services/remote_config_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/auth/account_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/portal_info_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/loading_hud.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
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

  late AccountManager accountManager;

  late TextEditingController _portalAdressController;
  TextEditingController get portalAdressController => _portalAdressController;

  late TextEditingController _emailController;
  TextEditingController get emailController => _emailController;

  late TextEditingController _passwordController;
  TextEditingController get passwordController => _passwordController;

  final portalFieldError = false.obs;
  final emailFieldError = false.obs;
  final passwordFieldError = false.obs;

  String? _pass;
  String? _email;
  String? _tfaKey;
  String? get tfaKey => _tfaKey;

  String get portalAdress => _portalAdressController.text.removeAllWhitespace;

  final cookieManager = WebviewCookieManager();

  final checkBoxValue = false.obs;
  final needAgreement = Get.deviceLocale!.languageCode == 'zh';

  final loaded = true.obs;
  final loadingScreen = LoadingWithoutProgress();

  @override
  void onInit() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _portalAdressController = TextEditingController();

    _portalAdressController.addListener(() {
      checkBoxValue.value = false;
    });

    accountManager =
        Get.isRegistered<AccountManager>() ? Get.find<AccountManager>() : Get.put(AccountManager());

    loaded.listen((value) => loadingScreen.showLoading(!value));

    super.onInit();
  }

  void setup() {
    _portalAdressController.text = '';
    _emailController.text = '';
    _passwordController.text = '';
  }

  Future<void> loginByPassword() async {
    if (await _checkEmailAndPass()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      loaded.value = false;

      final result = await _authService.login(pass: password, email: email);

      if (result.response == null) {
        loaded.value = true;
        return;
      }

      if (result.response!.token != null) {
        await _login(result.response!.token!, result.response!.expires!);

        loaded.value = true;
      } else if (result.response!.tfa == true) {
        _email = email;
        _pass = password;
        loaded.value = true;

        if (result.response!.tfaKey != null) {
          _tfaKey = result.response!.tfaKey;
          await Get.to<GetCodeViews>(() => const GetCodeViews());
        } else {
          await Get.to<CodeView>(CodeView.new);
        }
      } else if (result.response!.sms == true) {
        _email = email;
        _pass = password;
        loaded.value = true;
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
          loaded.value = true;
          await Get.to<TFASmsScreen>(
            () => const TFASmsScreen(),
            arguments: {'login': _email, 'password': _pass},
          );
        }
      }
    }
  }

  Future<void> saveLoginData({required String token, required String expires}) async {
    GetIt.instance.resetLazySingleton<CoreApi>();
    await saveToken(token, expires);
    await sendRegistrationType();

    await AnalyticsService.shared.logEvent(AnalyticsService.Events.loginPortal,
        {AnalyticsService.Params.Key.portal: await _secureStorage.getString('portalName')});
  }

  Future<bool> _checkEmailAndPass() async {
    _emailController.text = _emailController.text.removeAllWhitespace;
    _emailController.selection = TextSelection.fromPosition(
      TextPosition(offset: _emailController.text.length),
    );

    _passwordController.text = _passwordController.text.removeAllWhitespace;
    _passwordController.selection = TextSelection.fromPosition(
      TextPosition(offset: _passwordController.text.length),
    );

    var result = true;

    emailFieldError.value = false;
    passwordFieldError.value = false;

    if (!_emailController.text.isEmail) {
      result = false;
      emailFieldError.value = true;
      // ignore: unawaited_futures
      900.milliseconds.delay().then((_) => emailFieldError.value = false);
    }
    if (_passwordController.text.isEmpty) {
      result = false;
      passwordFieldError.value = true;
      // ignore: unawaited_futures
      900.milliseconds.delay().then((_) => passwordFieldError.value = false);
    }
    return result;
  }

  Future saveToken(String token, String expires) async {
    //TODO: replace with AccountData
    await _secureStorage.putString('token', token);
    await _secureStorage.putString('expires', expires);
  }

  Future clearToken() async {
    //TODO: replace with AccountData
    await _secureStorage.delete('token');
    await _secureStorage.delete('expires');
  }

  Future<bool> sendCode(String code, {String? userName, String? password}) async {
    loaded.value = false;

    _email ??= userName;
    _pass ??= password;

    final result = await _authService.confirmTFACode(
        email: _email!, pass: _pass!, code: code.removeAllWhitespace);

    if (result.response == null) {
      loaded.value = true;
      return false;
    }

    if (result.response!.token != null) {
      await _login(result.response!.token!, result.response!.expires!);

      loaded.value = true;
      return true;
    } else if (result.response!.tfa!) {
      loaded.value = true;
      await Get.to(CodeView.new);
      return true;
    }

    return false;
  }

  Future<bool> _login(String token, String expires) async {
    await saveToken(token, expires);
    locator.get<CoreApi>().token = token;
    if (!(await _authService.checkAuthorization())) {
      unawaited(clearToken());
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
      return false;
    }

    await saveLoginData(token: token, expires: expires);
    await Get.find<AccountManager>().addAccount(tokenString: token, expires: expires);

    await cookieManager.setCookies([
      Cookie('asc_auth_key', token)
        ..domain = portalAdress
        ..expires = DateTime.parse(expires)
        ..httpOnly = false
    ]);

    locator<EventHub>().fire('loginSuccess');
    return true;
  }

  Future<void> getPortalCapabilities() async {
    if (needAgreement && !checkBoxValue.value) {
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('privacyAndTermsFooter.total'));
      return;
    }

    if (_isPersonalPortal(portalAdress)) {
      portalFieldError.value = true;
      // ignore: unawaited_futures
      900.milliseconds.delay().then((_) => portalFieldError.value = false);

      final alertContent = RichText(
        textAlign: Platform.isIOS ? TextAlign.center : TextAlign.left,
        text: TextSpan(
          style: TextStyleHelper.body2(
              color: Theme.of(Get.context!).colors().onSurface.withOpacity(0.6)),
          children: [
            TextSpan(text: tr('projectModuleNotSupported.projectModule')),
            TextSpan(text: portalAdress, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: tr('projectModuleNotSupported.notSupported')),
          ],
        ),
      );

      await Get.find<NavigationController>().showPlatformDialog(
        SingleButtonDialog(
          titleText: tr('error'),
          content: alertContent,
          acceptText: tr('ok'),
        ),
      );
      return;
    }

    if (portalAdress.isEmpty) {
      portalFieldError.value = true;
      // ignore: unawaited_futures
      900.milliseconds.delay().then((_) => portalFieldError.value = false);
    } else {
      loaded.value = false;

      _portalAdressController.text = _portalAdressController.text.removeAllWhitespace;
      if (_portalAdressController.text[_portalAdressController.text.length - 1] == '.')
        _portalAdressController.text =
            _portalAdressController.text.substring(0, _portalAdressController.text.length - 1);

      _portalAdressController.selection = TextSelection.fromPosition(
        TextPosition(offset: _portalAdressController.text.length),
      );

      locator.get<CoreApi>().setPortalName(portalAdress);

      final _capabilities = await _portalService.portalCapabilities();

      if (_capabilities != null) {
        checkBoxValue.value = false;
        loaded.value = true;
        await Get.to(() => LoginView());
      }

      loaded.value = true;
    }
  }

  Future<bool> sendRegistrationType() async {
    final result = await _authService.sendRegistrationType();
    return result != null;
  }

  Future<void> logout() async {
    final storage = locator<Storage>();

    locator.get<CoreApi>().cancellationToken.cancel();

    await _secureStorage.delete('portalName');
    await clearToken();

    await storage.remove('taskFilters');
    await storage.remove('projectFilters');
    await storage.remove('discussionFilters');

    await cookieManager.clearCookies();

    Get.find<PortalInfoController>().logout();
    Get.find<UserController>().clear();

    await RemoteConfigService.fetchAndActivate();

    locator<EventHub>().fire('logoutSuccess');
    loaded.value = true;
  }

  // TODO: check dispose textControllers
  @override
  void onClose() {
    clearInputFields();

    _portalAdressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    loaded.close();

    super.onClose();
  }

  void clearInputFields() {
    _portalAdressController.clear();
    _emailController.clear();
    _passwordController.clear();

    _pass = null;
    _email = null;
    _tfaKey = null;

    clearErrors();
  }

  void clearErrors() {
    portalFieldError.value = false;
    emailFieldError.value = false;
    passwordFieldError.value = false;
  }

  void leaveLoginScreen() {
    _emailController.clear();
    _passwordController.clear();

    _pass = null;
    _email = null;
    _tfaKey = null;

    clearErrors();

    Get.back();
  }

  bool _isPersonalPortal(String portalAdress) {
    final domains = portalAdress.split('.');
    return domains[0].contains('personal');
  }
}
