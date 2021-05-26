import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class PasscodeScreen extends StatelessWidget {
  const PasscodeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PasscodeController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 62),
              Text('Enter passcode',
                  style: TextStyleHelper.headline6(
                      color: Theme.of(context).customColors().onBackground)),
              const SizedBox(height: 16),
              Text('Choose passcode to unlock app',
                  style: TextStyleHelper.subtitle1(
                      color: Theme.of(context).customColors().onBackground)),
              const SizedBox(height: 36),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 4; i++)
                      Container(
                        height: 16,
                        width: 16,
                        margin: i != 0 ? const EdgeInsets.only(left: 32) : null,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.passcodeLen >= i + 1
                              ? Theme.of(context).customColors().onBackground
                              : Theme.of(context)
                                  .customColors()
                                  .onBackground
                                  .withOpacity(0.4),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 140),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _PasscodeNumber(number: 1),
                  const SizedBox(width: 20),
                  const _PasscodeNumber(number: 2),
                  const SizedBox(width: 20),
                  const _PasscodeNumber(number: 3),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _PasscodeNumber(number: 4),
                  const SizedBox(width: 20),
                  const _PasscodeNumber(number: 5),
                  const SizedBox(width: 20),
                  const _PasscodeNumber(number: 6),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _PasscodeNumber(number: 7),
                  const SizedBox(width: 20),
                  const _PasscodeNumber(number: 8),
                  const SizedBox(width: 20),
                  const _PasscodeNumber(number: 9),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 59),
                  const _PasscodeNumber(number: 0),
                  IconButton(
                      icon: AppIcon(icon: SvgIcons.delete_number),
                      onPressed: () => controller.deleteNumber())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasscodeNumber extends StatelessWidget {
  final int number;
  // final PasscodeController controller;

  const _PasscodeNumber({
    Key key,
    this.number,
    // this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PasscodeController>();

    return TextButton(
      onPressed: () {
        controller.addNumberToPasscode(number);
        print(controller.passcodeLen);
      },
      child: Text(
        number.toString(),
        style: TextStyleHelper.headline3(
            color: Theme.of(context).customColors().onBackground),
      ),
    );
  }
}
