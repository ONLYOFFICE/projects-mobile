import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projects/internal/app.dart';
import 'package:projects/internal/locator.dart';

void main() async {
  setupLocator();
  await GetStorage.init();
  runApp(App());
}
