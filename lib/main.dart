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

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projects/data/services/passcode_service.dart';
import 'package:projects/data/services/remote_config_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/internal/dev_http_overrides.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/internal/pages_setup.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/theme_service.dart';

void main() async {
  HttpOverrides.global = DevHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  await FlutterDownloader.initialize(debug: false);

  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp();
  await RemoteConfigService.initialize();
  await RemoteConfigService.fetchAndActivate();

  setupLocator();
  setupGetX();
  final page = await _getInitPage();

  runApp(
    EasyLocalization(
      supportedLocales: supportedLocales(),
      path: 'lib/l10n',
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      useOnlyLangCode: true,
      child: App(initialPage: page),
    ),
  );
}

List<Locale> supportedLocales() => [
      const Locale('de'),
      const Locale('en'),
      const Locale('es'),
      const Locale('fr'),
      const Locale('it'),
      const Locale('pt'),
      const Locale('ru'),
      const Locale('zh'),
    ];

Future<String> _getInitPage() async {
  final passcode = await locator<PasscodeService>().isPasscodeEnable;
  final _isLoggedIn = await isAuthorized();

  if (passcode && _isLoggedIn) return '/PasscodeScreen';

  return '/MainView';
}

Future<bool> isAuthorized() async {
  final _secureStorage = locator<SecureStorage>();
  final expirationDate = await _secureStorage.getString('expires');
  final token = await _secureStorage.getString('token');
  final portalName = await _secureStorage.getString('portalName');

  if (expirationDate == null ||
      expirationDate.isEmpty ||
      token == null ||
      token.isEmpty ||
      portalName == null ||
      portalName.isEmpty) return false;

  final expiration = DateTime.parse(expirationDate);
  if (expiration.isBefore(DateTime.now())) return false;

  return true;
}

class App extends StatelessWidget {
  final String? initialPage;

  const App({Key? key, this.initialPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.window.onPlatformBrightnessChanged = () {
      if (ThemeService.savedThemeMode() == ThemeMode.system)
        Get.rootController.restartApp(); // TODO change brightness without restart
    };

    print(context.locale.toString());
    print(context.deviceLocale.toString());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: GetMaterialApp(
        initialRoute: initialPage,
        getPages: getxPages(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.deviceLocale,
        title: 'ONLYOFFICE',
        theme: lightTheme.copyWith(
          splashFactory: GetPlatform.isIOS ? NoSplash.splashFactory : null,
        ),
        darkTheme: darkTheme.copyWith(
          splashFactory: GetPlatform.isIOS ? NoSplash.splashFactory : null,
        ),
        themeMode: ThemeService.savedThemeMode(),
      ),
    );
  }
}
