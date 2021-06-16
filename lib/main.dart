import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projects/data/services/storage.dart';
import 'package:projects/internal/app.dart';
import 'package:projects/internal/locator.dart';

void main() async {
  setupLocator();
  await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  var page = await _getInitPage();
  runApp(App(initialPage: page));
}

Future<String> _getInitPage() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);

  var storage = locator<SecureStorage>();
  var token = await storage.getString('token');
  var passcode = await storage.getString('passcode');
  // await Get.find<LoginController>().logout();

  // TODO CHECK TOKEN (isTokenExpired)
  if (token != null) {
    if (passcode != null) return 'PasscodeScreen';
    return '/';
  } else {
    return 'PortalView';
  }
}
