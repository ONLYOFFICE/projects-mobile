import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';

class ThemeService {
  final storage = GetStorage();

  ThemeMode savedThemeMode() {
    var themeMode = storage.read('themeMode');

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
