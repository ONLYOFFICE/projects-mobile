import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_editing_controller.dart';
import 'package:projects/presentation/shared/widgets/passcode_screen_mixin.dart';

class EditPasscodeScreen1 extends StatelessWidget with PasscodeScreenMixin {
  EditPasscodeScreen1({Key key}) : super(key: key);

  final controller = Get.put(PasscodeEditingController());

  @override
  String get title => tr('enterNewPasscode');

  @override
  void onNumberPressed(int number) => controller.addNumberToPasscode(number);

  @override
  void onDeletePressed() => controller.deleteNumber();

  @override
  void onBackPressed() => controller.leave1Page();

  @override
  RxInt get enteredCodeLen => controller.enteredPasscodeLen;
}
