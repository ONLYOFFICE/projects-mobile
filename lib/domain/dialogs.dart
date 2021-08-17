import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/error.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class ErrorDialog {
  static Future<void> show(CustomError error) async {
    await Get.dialog(SingleButtonDialog(
      titleText: tr('error'),
      contentText: '${error.message}',
      acceptText: tr('ok'),
      onAcceptTap: Get.back,
    ));
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
    Get.dialog(const Center(child: CircularProgressIndicator()));
  }

  static void hide() {
    Get.back();
  }
}
