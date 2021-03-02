import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:only_office_mobile/data/models/error.dart';

class ErrorDialog {
  static show(Error error) {
    Get.defaultDialog(
        title: '${error.message}',
        textConfirm: 'ok',
        onConfirm: () => Get.back(),
        barrierDismissible: false);
  }

  static hide() {
    Get.back();
  }
}

class ProgressDialog {
  static show(Error error) {
    Get.dialog(Center(child: CircularProgressIndicator()));
  }

  static hide() {
    Get.back();
  }
}
