import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_editing_controller.dart';
import 'package:projects/presentation/shared/widgets/passcode_screen_mixin.dart';

class EditPasscodeScreen2 extends StatelessWidget with PasscodeScreenMixin {
  EditPasscodeScreen2({Key key}) : super(key: key);

  final PasscodeEditingController passcodeController =
      Get.find<PasscodeEditingController>();

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
  void onBackPressed() => passcodeController.leave2Page();

  @override
  RxInt get enteredCodeLen => passcodeController.passcodeCheckLen;
  @override
  RxBool get hasError => passcodeController.passcodeCheckFailed;
}
