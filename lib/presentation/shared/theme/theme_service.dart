import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final storage = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get themeMode => isDark() ? ThemeMode.dark : ThemeMode.light;

  bool isDark() {
    //TODO: fix dark mode when dark theme is ready
    return false;

    // var appDarkModeIsOn = storage.read(_key);

    // if (appDarkModeIsOn == null) {
    //   var brightness = SchedulerBinding.instance.window.platformBrightness;
    //   var systemDarkModeIsOn = brightness == Brightness.dark;
    //   _saveThemeToStorage(systemDarkModeIsOn);

    //   return systemDarkModeIsOn;
    // }

    // return appDarkModeIsOn;
  }

  void _saveThemeToStorage(bool isDarkMode) => storage.write(_key, isDarkMode);

  void switchTheme() {
    Get.changeThemeMode(isDark() ? ThemeMode.light : ThemeMode.dark);

    _saveThemeToStorage(!isDark());
  }
}
