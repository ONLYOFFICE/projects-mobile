import 'package:package_info/package_info.dart';

class PackageInfoService {
  PackageInfo packageInfo;

  Future<void> init() async {
    if (packageInfo != null) return;
    packageInfo = await PackageInfo.fromPlatform();
  }

  Future<String> get appName async {
    await init();
    return packageInfo.appName;
  }

  Future<String> get buildNumber async {
    await init();
    return packageInfo.buildNumber;
  }

  Future<String> get packageName async {
    await init();
    return packageInfo.packageName;
  }

  Future<String> get version async {
    await init();
    return packageInfo.version;
  }
}
