import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_checking_controller.dart';
import 'package:projects/presentation/shared/widgets/passcode_screen_mixin.dart';

class EnterCurrentPasscodeScreen extends StatelessWidget
    with PasscodeScreenMixin {
  EnterCurrentPasscodeScreen({
    Key key,
    @required this.onPass,
    this.onBack,
  }) : super(key: key);

  final VoidCallback onPass;
  final VoidCallback onBack;

  final passcodeCheckingController = Get.put(PasscodeCheckingController());

  @override
  String get title => tr('enterCurrentPasscode');

  @override
  RxInt get enteredCodeLen => passcodeCheckingController.passcodeLen;

  @override
  RxBool get hasError => passcodeCheckingController.passcodeCheckFailed;

  @override
  String get errorText => tr('incorrectPIN');

  @override
  void onBackPressed() => onBack != null ? onBack() : Get.back();

  @override
  void onDeletePressed() => passcodeCheckingController.deleteNumber();

  @override
  void onNumberPressed(int number) {
    passcodeCheckingController.addNumberToPasscode(number, onPass: onPass);
  }
}
