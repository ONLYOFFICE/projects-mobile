import 'package:get/get.dart';
import 'package:projects/data/services/settings_service.dart';

import 'package:projects/internal/locator.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final _service = locator<SettingsService>();

  var loaded = false.obs;
  var currentTheme = ''.obs;

  var isPasscodeEnable;

  @override
  void onInit() async {
    loaded.value = false;
    var isPassEnable = await _service.isPasscodeEnable;
    isPasscodeEnable = isPassEnable.obs;

    currentTheme.value = await GetStorage().read('themeMode');
    loaded.value = true;

    super.onInit();
  }

  void leave() => Get.offNamed('/');

  Future setTheme(String themeMode) async {
    switch (themeMode) {
      case 'darkTheme':
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case 'lightTheme':
        Get.changeThemeMode(ThemeMode.light);
        break;
      case 'sameAsSystem':
        Get.isPlatformDarkMode
            ? Get.changeThemeMode(ThemeMode.dark)
            : Get.changeThemeMode(ThemeMode.light);
        break;
      default:
        Get.changeThemeMode(ThemeMode.system);
    }

    currentTheme.value = themeMode;
    await GetStorage().write('themeMode', themeMode);

    //TODO fix if possible: errors flood without restart
    Get.rootController.restartApp();
  }
}
