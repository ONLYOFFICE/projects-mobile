import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_settings_controller.dart';
import 'package:projects/domain/controllers/passcode/passcode_controller.dart';
import 'package:projects/internal/utils/adaptive_size.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_dot.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_numbers.dart';

class CurrentPasscodeCheckScreen extends StatelessWidget {
  const CurrentPasscodeCheckScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final passcodeSettingsController = Get.find<PasscodeSettingsController>();
    var passcodeController;

    try {
      passcodeController = Get.find<PasscodeController>();
    } catch (_) {
      passcodeController = Get.put(PasscodeController());
    }

    var onPass = Get.arguments['onPass'];
    return WillPopScope(
      onWillPop: () async {
        passcodeSettingsController.cancelEnablingPasscode();
        passcodeController.clear();
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h(170)),
              Text(tr('enterCurrentPasscode'),
                  style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onBackground)),
              Obx(
                () => SizedBox(
                  height: h(72),
                  child: Column(
                    children: [
                      const Flexible(flex: 1, child: SizedBox(height: 16)),
                      if (passcodeController.passcodeCheckFailed == true)
                        Text(tr('incorrectPIN'),
                            style: TextStyleHelper.subtitle1(
                                color: Get.theme.colors().colorError)),
                      const Flexible(flex: 2, child: SizedBox(height: 32)),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 4; i++)
                      PasscodeDot(
                        inputLenght: passcodeController.passcodeLen.value,
                        position: i,
                        passwordIsWrong:
                            passcodeController.passcodeCheckFailed.value,
                      ),
                  ],
                ),
              ),
              SizedBox(height: h(165)),
              PasscodeNumbersRow(
                numbers: [1, 2, 3],
                onPressed: (number) => passcodeController.addNumberToPasscode(
                  number,
                  nextPage: 'NewPasscodeScreen1',
                  nextPageArguments: {
                    'title': tr('enterNewPasscode'),
                    'caption': '',
                  },
                  onPass: onPass,
                ),
              ),
              PasscodeNumbersRow(
                numbers: [4, 5, 6],
                onPressed: (number) => passcodeController.addNumberToPasscode(
                  number,
                  nextPage: 'NewPasscodeScreen1',
                  nextPageArguments: {
                    'title': tr('enterNewPasscode'),
                    'caption': '',
                  },
                  onPass: onPass,
                ),
              ),
              PasscodeNumbersRow(
                numbers: [7, 8, 9],
                onPressed: (number) => passcodeController.addNumberToPasscode(
                  number,
                  nextPage: 'NewPasscodeScreen1',
                  nextPageArguments: {
                    'title': tr('enterNewPasscode'),
                    'caption': '',
                  },
                  onPass: onPass,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: w(49)),
                  TextButton(
                    onPressed:
                        passcodeSettingsController.cancelEnablingPasscode,
                    child: Text(
                      tr('cancel'),
                      style: TextStyleHelper.button(
                          color: Get.theme.colors().primary),
                    ),
                  ),
                  SizedBox(width: w(25.8)),
                  PasscodeNumber(
                    number: 0,
                    onPressed: (number) {
                      return passcodeController.addNumberToPasscode(
                        number,
                        nextPage: 'NewPasscodeScreen1',
                        onPass: onPass,
                      );
                    },
                  ),
                  SizedBox(width: w(44)),
                  DeleteButton(onTap: passcodeController.deleteNumber)
                  // const SizedBox(width: 25),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
