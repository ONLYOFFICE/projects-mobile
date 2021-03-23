import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/internal/localization/localization_setup.dart';
import 'package:projects/internal/pages_setup.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: 'PortalView',
      getPages: getxPages(),
      localizationsDelegates: localizationsDelegates(),
      supportedLocales: supportedLocales(),
      title: 'ONLYOFFICE',
      theme: ThemeData(),
    );
  }
}
