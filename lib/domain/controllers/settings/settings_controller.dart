/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

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
import 'package:projects/domain/dialogs.dart';

import 'package:projects/internal/locator.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
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

    var url =
        'mailto:support@onlyoffice.com?subject=ONLYOFFICE Projects (iOS/Android) Feedback&body=$body';

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
      await Get.toNamed('AnalyticsScreen');
}
