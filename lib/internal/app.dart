import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/internal/localization/localization_setup.dart';
import 'package:projects/internal/pages_setup.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/theme_service.dart';

class App extends StatelessWidget {
  final String initialPage;

  App({
    Key key,
    this.initialPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: initialPage,
      getPages: getxPages(),
      localizationsDelegates: localizationsDelegates(),
      supportedLocales: supportedLocales(),
      title: 'ONLYOFFICE',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeService().themeMode,
    );
  }
}
