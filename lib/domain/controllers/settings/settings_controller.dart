import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projects/data/models/from_api/error.dart';
import 'package:projects/data/services/device_info_service.dart';
import 'package:projects/data/services/package_info_service.dart';
import 'package:projects/data/services/settings_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/dialogs.dart';

import 'package:projects/internal/locator.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/settings/analytics_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  final _service = locator<SettingsService>();
  final _packageInfoService = locator<PackageInfoService>();
  final _deviceInfoService = locator<DeviceInfoService>();

  String appVersion;
  String buildNumber;

  var loaded = false.obs;
  var currentTheme = ''.obs;
  var isPasscodeEnable;
  RxBool shareAnalytics = true.obs;

  String get versionAndBuildNumber => '$appVersion ($buildNumber)';

  @override
  void onInit() async {
    loaded.value = false;
    var isPassEnable = await _service.isPasscodeEnable;
    isPasscodeEnable = isPassEnable.obs;

    appVersion = await _packageInfoService.version;
    buildNumber = await _packageInfoService.buildNumber;

    var themeMode = await GetStorage().read('themeMode');
    if (themeMode == null) {
      themeMode = 'sameAsSystem';
      await GetStorage().write(themeMode, themeMode);
    }

    var analytics = await GetStorage().read('shareAnalytics');

    if (analytics == null) {
      await GetStorage().write('shareAnalytics', true);
      shareAnalytics.value = true;
    } else {
      shareAnalytics.value = analytics;
    }

    currentTheme.value = themeMode;
    loaded.value = true;

    super.onInit();
  }

  void leave() => Get.back(); //offNamed('NavigationView');

  Future setTheme(String themeMode) async {
    currentTheme.value = themeMode;
    await GetStorage().write('themeMode', themeMode);

    await Get.dialog(StyledAlertDialog(
      titleText: tr('reloadDialogTitle'),
      acceptText: tr('reload').toUpperCase(),
      cancelText: tr('notNow').toUpperCase(),
      onAcceptTap: () {
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

        Get.rootController.restartApp();
      },
      onCancelTap: Get.back,
    ));
  }

  Future<void> changeAnalyticsSharingEnability(bool value) async {
    try {
      await GetStorage().write('shareAnalytics', value);
      shareAnalytics.value = value;
    } catch (_) {
      await ErrorDialog.show(CustomError(message: tr('error')));
    }
  }

  void onClearCachePressed() async {
    var appDir = (await getTemporaryDirectory()).path;
    await DefaultCacheManager().emptyCache();
    await Directory(appDir).delete(recursive: true);
  }

  void onHelpPressed() async {
    // TODO REPLACE
    const url = 'https://helpcenter.onlyoffice.com/userguides/projects.aspx';
    await launch(url);
  }

  void onSupportPressed(context) async {
    var device = await _deviceInfoService.deviceInfo;
    var os = await _deviceInfoService.osReleaseVersion;

    var body = '';
    body += '\n\n\n\n\n';
    body += '____________________';
    body += '\nApp version: $versionAndBuildNumber';
    body += '\nDevice model: $device';
    body += '\nAndroid version: $os';

    // TODO change to ONLYOFFICE Projects IOS Feedback on ios
    var url =
        'mailto:support@onlyoffice.com?subject=ONLYOFFICE Projects Android Feedback&body=$body';

    await _service.openEmailApp(url, context);
  }

  Future<void> onRateAppPressed() async {
    await LaunchReview.launch(
      androidAppId: 'com.onlyoffice.projects',
      iOSAppId: '388497605',
      writeReview: true,
    );
  }

  Future<void> onUserAgreementPressed() async =>
      await launch('https://www.onlyoffice.com/legalterms.aspx');

  Future<void> onAnalyticsPressed() async =>
      Get.find<NavigationController>().toScreen(const AnalyticsScreen());
}
