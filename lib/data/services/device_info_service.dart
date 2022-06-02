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

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

enum DeviceType { ios, android }

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  AndroidDeviceInfo? _androidDeviceInfo;
  IosDeviceInfo? _iosDeviceInfo;

  late DeviceType _deviceType;
  DeviceType get deviceType => _deviceType;

  DeviceInfoService() {
    GetPlatform.isAndroid ? _deviceType = DeviceType.android : _deviceType = DeviceType.ios;
  }

  Future<void> init() async {
    switch (_deviceType) {
      case DeviceType.ios:
        if (_iosDeviceInfo != null) return;
        _iosDeviceInfo = await _deviceInfoPlugin.iosInfo;
        break;
      case DeviceType.android:
        if (_androidDeviceInfo != null) return;
        _androidDeviceInfo = await _deviceInfoPlugin.androidInfo;
        break;
    }
  }

  Future<String?> get manufacturer async {
    await init();
    switch (_deviceType) {
      case DeviceType.ios:
        return 'Apple';
      case DeviceType.android:
        return _androidDeviceInfo?.manufacturer;
    }
  }

  Future<String?> get model async {
    await init();

    switch (_deviceType) {
      case DeviceType.ios:
        return _iosDeviceInfo?.model;
      case DeviceType.android:
        return _androidDeviceInfo?.model;
    }
  }

  Future<String?> get osReleaseVersion async {
    await init();
    switch (_deviceType) {
      case DeviceType.ios:
        return _iosDeviceInfo?.systemVersion;
      case DeviceType.android:
        return _androidDeviceInfo?.version.release;
    }
  }

  Future<String?> get osIncrementalVersion async {
    await init();
    switch (_deviceType) {
      case DeviceType.ios:
        return '';
      case DeviceType.android:
        return _androidDeviceInfo?.version.incremental;
    }
  }

  Future<String?> get osInfo async {
    await init();
    switch (_deviceType) {
      case DeviceType.ios:
        return '${Platform.operatingSystem} ${_iosDeviceInfo?.systemVersion}';
      case DeviceType.android:
        return '${Platform.operatingSystem} ${_androidDeviceInfo?.version.release}';
    }
  }

  Future<String?> get deviceInfo async {
    await init();
    switch (_deviceType) {
      case DeviceType.ios:
        return 'Apple ${_iosDeviceInfo?.name} ${_iosDeviceInfo?.systemVersion}';
      case DeviceType.android:
        return '${_androidDeviceInfo?.manufacturer} ${_androidDeviceInfo?.model} ${_androidDeviceInfo?.version.incremental}';
    }
  }

  Future<int?> get androidSdkVersion async {
    await init(); // TODO move init to constructor

    return Platform.isAndroid ? _androidDeviceInfo?.version.sdkInt : null;
  }
}
