import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projects/data/services/storage/secure_storage.dart';

import 'package:projects/internal/pages_setup.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/theme_service.dart';
import 'package:projects/internal/locator.dart';

void main() async {
  setupLocator();
  await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  var page = await _getInitPage();

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

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
      const Locale('pt_BR'),
      const Locale('ru'),
      const Locale('zh'),
    ];

Future<String> _getInitPage() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);

  var storage = locator<SecureStorage>();
  var passcode = await storage.getString('passcode');

  var _isLoggedIn = await isAuthorized();

  if (passcode != null && _isLoggedIn) return '/PasscodeScreen';

  return '/MainView';
}

Future<bool> isAuthorized() async {
  var _secureStorage = locator<SecureStorage>();
  var expirationDate = await _secureStorage.getString('expires');
  var token = await _secureStorage.getString('token');
  var portalName = await _secureStorage.getString('portalName');

  if (expirationDate == null ||
      expirationDate.isEmpty ||
      token == null ||
      token.isEmpty ||
      portalName == null ||
      portalName.isEmpty) return false;

  var expiration = DateTime.parse(expirationDate);
  if (expiration.isBefore(DateTime.now())) return false;

  return true;
}

class App extends GetMaterialApp {
  final String initialPage;

  App({Key key, this.initialPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeService().savedThemeMode(),
      ),
    );
  }
}
