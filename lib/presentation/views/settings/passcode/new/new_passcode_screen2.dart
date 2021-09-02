import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_settings_controller.dart';
import 'package:projects/presentation/shared/widgets/passcode_screen_mixin.dart';

class NewPasscodeScreen2 extends StatelessWidget with PasscodeScreenMixin {
  NewPasscodeScreen2({
    Key key,
    this.onSaved,
  }) : super(key: key);

  final VoidCallback onSaved;

  final PasscodeSettingsController passcodeController =
      Get.find<PasscodeSettingsController>();

  @override
  String get caption => tr('reEnterPasscode');

  @override
  String get errorText => tr('passcodesNotMatch');

  @override
  void onNumberPressed(int number) =>
      passcodeController.addNumberToPasscodeCheck(number);

  @override
  void onDeletePressed() => passcodeController.deletePasscodeCheckNumber();

  @override
  void onBackPressed() => passcodeController.leave();

  @override
  RxInt get enteredCodeLen => passcodeController.passcodeCheckLen;
  @override
  RxBool get hasError => passcodeController.passcodeCheckFailed;
}
