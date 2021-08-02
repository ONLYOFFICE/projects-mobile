import 'dart:io';

import 'package:device_info/device_info.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo _androidInfo;

  Future<void> init() async {
    if (_androidInfo != null) return;
    _androidInfo = await _deviceInfo.androidInfo;
  }

  Future<String> get manufacturer async {
    await init();
    return _androidInfo.manufacturer;
  }

  Future<String> get model async {
    await init();
    return _androidInfo.model;
  }

  Future<String> get osReleaseVersion async {
    await init();
    return _androidInfo.version.release;
  }

  Future<String> get osIncrementalVersion async {
    await init();
    return _androidInfo.version.incremental;
  }

  Future<String> get osInfo async {
    await init();
    return '${Platform.operatingSystem} ${_androidInfo.version.release}';
  }

  Future<String> get deviceInfo async {
    await init();
    return '${_androidInfo.manufacturer} ${_androidInfo.model} ${_androidInfo.version.incremental}';
  }
}
