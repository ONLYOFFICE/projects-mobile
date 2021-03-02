import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:only_office_mobile/internal/localization/localization_setup.dart';
import 'package:only_office_mobile/internal/pages_setup.dart';

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
