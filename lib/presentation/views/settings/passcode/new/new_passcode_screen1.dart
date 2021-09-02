import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_settings_controller.dart';
import 'package:projects/presentation/shared/widgets/passcode_screen_mixin.dart';

class NewPasscodeScreen1 extends StatelessWidget with PasscodeScreenMixin {
  NewPasscodeScreen1({Key key}) : super(key: key);

  final passcodeController = Get.find<PasscodeSettingsController>();

  @override
  void onNumberPressed(int number) =>
      passcodeController.addNumberToPasscode(number);

  @override
  String get caption => tr('choosePasscode');

  @override
  void onDeletePressed() => passcodeController.deleteNumber();

  @override
  void onBackPressed() => passcodeController.cancelEnablingPasscode();

  @override
  RxInt get enteredCodeLen => passcodeController.enteredPasscodeLen;
}
