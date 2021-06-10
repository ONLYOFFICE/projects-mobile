import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/storage.dart';
import 'package:projects/internal/localization/localization_setup.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/internal/pages_setup.dart';
import 'package:projects/internal/splash_view.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/theme_service.dart';

class App extends StatelessWidget {
  App({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getInitPage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            initialRoute: snapshot.data,
            getPages: getxPages(),
            localizationsDelegates: localizationsDelegates(),
            supportedLocales: supportedLocales(),
            title: 'ONLYOFFICE',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeService().themeMode,
          );
        } else {
          return const SplashView();
        }
      },
    );
  }
}

Future<String> _getInitPage() async {
  var storage = locator<SecureStorage>();
  var token = await storage.getString('token');
  var passcode = await storage.getString('passcode');
  // await Get.find<LoginController>().logout();

  // TODO CHECK TOKEN (isTokenExpired)
  if (token != null) {
    if (passcode != null) return 'PasscodeScreen';
    return '/';
  } else {
    return 'PortalView';
  }
}
