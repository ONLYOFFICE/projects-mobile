import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/error.dart';

class ErrorDialog {
  static void show(CustomError error) {
    Get.defaultDialog(
        title: '${error.message}',
        textConfirm: 'ok',
        onConfirm: () => Get.back(),
        barrierDismissible: false);
  }

  static void hide() {
    Get.back();
  }
}

class ProgressDialog {
  static void show(CustomError error) {
    Get.dialog(Center(child: CircularProgressIndicator()));
  }

  static void hide() {
    Get.back();
  }
}
