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

class ConfirmDialog {
  static void show({
    String title,
    String message,
    String textConfirm,
    String textCancel,
    Function confirmFunction,
    Function cancelFunction,
  }) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      textConfirm: textConfirm,
      onConfirm: confirmFunction(),
      onCancel: cancelFunction(),
      barrierDismissible: false,
      textCancel: textCancel,
    );
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
