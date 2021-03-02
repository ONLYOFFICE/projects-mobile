import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<LocalizationsDelegate> localizationsDelegates() => [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];

List<Locale> supportedLocales() => [
      const Locale('en', ''), // English, no country code
      const Locale('ru', ''),
    ];
