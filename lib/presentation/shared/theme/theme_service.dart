import 'package:flutter/material.dart';

import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/internal/locator.dart';

class ThemeService {
  final storage = locator<Storage>();

  ThemeMode savedThemeMode() {
    var themeMode = storage.getValue('themeMode');

    switch (themeMode) {
      case 'darkTheme':
        return ThemeMode.dark;
        break;
      case 'lightTheme':
        return ThemeMode.light;
        break;
      case 'sameAsSystem':
        return ThemeMode.system;
        break;
      default:
        return ThemeMode.system;
    }
  }
}
