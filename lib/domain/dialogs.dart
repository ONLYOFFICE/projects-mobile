import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:only_office_mobile/data/models/from_api/error.dart';

class ErrorDialog {
  static show(CustomError error) {
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
  static show(CustomError error) {
    Get.dialog(Center(child: CircularProgressIndicator()));
  }

  static hide() {
    Get.back();
  }
}
