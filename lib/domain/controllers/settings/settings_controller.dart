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

import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projects/data/services/device_info_service.dart';
import 'package:projects/data/services/package_info_service.dart';
import 'package:projects/data/services/remote_config_service.dart';
import 'package:projects/data/services/settings_service.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/dialogs.dart';
import 'package:projects/internal/constants.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/settings/analytics_screen.dart';
import 'package:projects/presentation/views/settings/color_theme_selection_screen.dart';
import 'package:projects/presentation/views/settings/passcode/screens/passcode_settings_screen.dart';
import 'package:projects/presentation/views/settings/settings_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  final SettingsService _service = locator<SettingsService>();
  final PackageInfoService _packageInfoService = locator<PackageInfoService>();
  final DeviceInfoService _deviceInfoService = locator<DeviceInfoService>();
  final Storage _storage = locator<Storage>();
  final platformController = Get.find<PlatformController>();
  final navigationController = Get.find<NavigationController>();

  String? appVersion;
  String? buildNumber;

  final loaded = false.obs;
  final currentTheme = ''.obs;
  final cacheSize = ''.obs;
  final isPasscodeEnable = false.obs;
  final shareAnalytics = true.obs;

  String get versionAndBuildNumber => '$appVersion ($buildNumber)';

  @override
  void onInit() async {
    loaded.value = false;

    // ignore: unawaited_futures
    RemoteConfigService.fetchAndActivate();
    final isPassEnable = await _service.isPasscodeEnable;
    isPasscodeEnable.value = isPassEnable;

    appVersion = await _packageInfoService.version;
    buildNumber = await _packageInfoService.buildNumber;

    var themeMode = await _storage.getString('themeMode');
    if (themeMode == null) {
      themeMode = 'sameAsSystem';
      await _storage.saveString('themeMode', themeMode);
    }

    final analytics = await _storage.getBool('shareAnalytics');

    if (analytics == null) {
      await _storage.saveBool('shareAnalytics', true);
      shareAnalytics.value = true;
    } else {
      shareAnalytics.value = analytics;
    }

    currentTheme.value = themeMode;

    unawaited(setupCacheDirectorySize());

    loaded.value = true;

    super.onInit();
  }

  void leave() => Get.find<NavigationController>().back();

  Future setTheme(String themeMode) async {
    if (themeMode == currentTheme.value) return;

    switch (themeMode) {
      case 'darkTheme':
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case 'lightTheme':
        Get.changeThemeMode(ThemeMode.light);
        break;
      case 'sameAsSystem':
        Get.changeThemeMode(ThemeMode.system);
        break;
      default:
        Get.changeThemeMode(ThemeMode.system);
    }

    currentTheme.value = themeMode;
    await _storage.saveString('themeMode', themeMode);
  }

  Future<void> changeAnalyticsSharingEnability(bool value) async {
    try {
      await _storage.saveBool('shareAnalytics', value);
      shareAnalytics.value = value;
    } catch (_) {
      await Get.find<ErrorDialog>().show(tr('error'));
    }
  }

  Future<void> onClearCachePressed() async {
    final cm = DefaultCacheManager();
    cm.store.emptyMemoryCache();
    await cm.store.emptyCache();

    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      await Directory(cacheDir.path).list().forEach((e) => e.delete(recursive: true));
    }

    await setupCacheDirectorySize();
  }

  Future<void> setupCacheDirectorySize() async {
    final cacheDir = (await getTemporaryDirectory()).path;

    var totalSize = 0;
    final cache = Directory(cacheDir);
    try {
      if (cache.existsSync()) {
        cache.listSync(recursive: true, followLinks: false).forEach((FileSystemEntity entity) {
          if (entity is File) {
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }

    if (totalSize < 1024 * 100) {
      cacheSize.value = '${(totalSize / 1024).toStringAsFixed(2)} Kb';
    } else {
      cacheSize.value = '${(totalSize / 1024 / 1024).toStringAsFixed(2)} Mb';
    }
  }

  Future<void> onHelpPressed() async {
    GetPlatform.isAndroid ? await launch(Const.Urls.help) : await launch(Const.Urls.helpIOS);
  }

  Future<void> onSupportPressed() async {
    final device = await _deviceInfoService.deviceInfo;
    final os = await _deviceInfoService.osReleaseVersion;

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    var body = '';
    body += '\n\n\n\n\n';
    body += '____________________';
    body += '\nApp version: $versionAndBuildNumber';
    body += '\nDevice model: $device';
    switch (_deviceInfoService.deviceType) {
      case DeviceType.ios:
        body += '\niOS version: $os';
        break;
      case DeviceType.android:
        body += '\nAndroid version: $os';
        break;
    }

    String subject;
    switch (_deviceInfoService.deviceType) {
      case DeviceType.ios:
        subject = 'ONLYOFFICE Projects iOS Feedback';
        break;
      case DeviceType.android:
        subject = 'ONLYOFFICE Projects Android Feedback';
        break;
    }

    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: Const.Urls.supportMail,
      query: encodeQueryParameters(
        <String, String>{
          'subject': subject,
          'body': body,
        },
      ),
    );

    await _service.openEmailApp(emailLaunchUri.toString(), Get.context!);
  }

  Future<void> onRateAppPressed() async {
    await LaunchReview.launch(
      androidAppId: Const.Identificators.projectsAndroidAppBundle,
      iOSAppId: Const.Identificators.projectsAppStore,
      writeReview: true,
    );
  }

  Future<void> onTermsOfServicePressed() async => await launch(
        RemoteConfigService.getString(RemoteConfigService.Keys.linkTermsOfService),
      );

  Future<void> onPrivacyPolicyPressed() async => await launch(
        RemoteConfigService.getString(RemoteConfigService.Keys.linkPrivacyPolicy),
      );

  void onAnalyticsPressed() => navigationController.toScreen(
        const AnalyticsScreen(),
        page: '/AnalyticsScreen',
        arguments: {'previousPage': SettingsScreen.pageName},
      );

  void onPasscodePressed() => navigationController.toScreen(
        const PasscodeSettingsScreen(),
        page: '/PasscodeSettingsScreen',
        arguments: {'previousPage': SettingsScreen.pageName},
      );

  void onThemePressed() => navigationController.toScreen(
        const ColorThemeSelectionScreen(),
        page: '/ColorThemeSelectionScreen',
        arguments: {'previousPage': SettingsScreen.pageName},
      );

  void back({bool closeTabletModalScreen = false}) =>
      Get.find<NavigationController>().back(closeTabletModalScreen: closeTabletModalScreen);
}
