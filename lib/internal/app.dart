import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:only_office_mobile/data/models/user.dart';
import 'package:only_office_mobile/data/services/authentication_service.dart';
import 'package:only_office_mobile/internal/locator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:only_office_mobile/internal/router.dart' as UI;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>(
      initialData: User.initial(),
      create: (BuildContext context) =>
          locator<AuthenticationService>().userController.stream,
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English, no country code
          const Locale('ru', ''),
        ],
        title: 'ONLYOFFICE',
        theme: ThemeData(),
        initialRoute: 'login',
        onGenerateRoute: UI.Router.generateRoute,
      ),
    );
  }
}
