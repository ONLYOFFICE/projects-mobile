import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_checking_controller.dart';
import 'package:projects/presentation/shared/widgets/passcode_screen_mixin.dart';

import 'package:projects/presentation/views/settings/passcode/passcode_keyboard_items.dart';

class PasscodeScreen extends StatelessWidget with PasscodeScreenMixin {
  PasscodeScreen({Key key}) : super(key: key);

  final passcodeCheckingController =
      Get.put(PasscodeCheckingController(canUseFingerprint: true));

  @override
  String get title => tr('passcodeToUnlock');

  @override
  RxInt get enteredCodeLen => passcodeCheckingController.passcodeLen;

  @override
  RxBool get hasError => passcodeCheckingController.passcodeCheckFailed;

  @override
  String get errorText => tr('incorrectPIN');

  @override
  void onBackPressed() => null;

  @override
  bool get hasBackButton => false;

  @override
  void onDeletePressed() => passcodeCheckingController.deleteNumber();

  @override
  void onNumberPressed(int number) =>
      passcodeCheckingController.addNumberToPasscode(number);

  @override
  Widget get keyboardLastRow {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          if (passcodeCheckingController.loaded.value == false ||
              !passcodeCheckingController.isFingerprintEnable)
            return const SizedBox(width: 72.53);
          return FingerprintButton(
              onTap: passcodeCheckingController.useFingerprint);
        }),
        const SizedBox(width: 20.53),
        PasscodeNumber(
            number: 0,
            onPressed: passcodeCheckingController.addNumberToPasscode),
        const SizedBox(width: 20.53),
        DeleteButton(onTap: passcodeCheckingController.deleteNumber),
      ],
    );
  }
}
