import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_settings_controller.dart';
import 'package:projects/internal/utils/adaptive_size.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_dot.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_numbers.dart';

class NewPasscodeScreen2 extends StatelessWidget {
  const NewPasscodeScreen2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PasscodeSettingsController());

    return WillPopScope(
      onWillPop: () async {
        controller.leave();
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h(170)),
              Text(tr('enterPasscode'),
                  style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onBackground)),
              SizedBox(height: h(16)),
              Obx(() {
                return Text(
                    controller.passcodeCheckFailed.value == true
                        ? tr('passcodesNotMatch')
                        : tr('reEnterPasscode'),
                    style: TextStyleHelper.subtitle1(
                        color: controller.passcodeCheckFailed.value == true
                            ? Get.theme.colors().colorError
                            : Get.theme
                                .colors()
                                .onBackground
                                .withOpacity(0.6)));
              }),
              SizedBox(height: h(32)),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 4; i++)
                      PasscodeDot(
                        inputLenght: controller.passcodeCheckLen.value,
                        position: i,
                        passwordIsWrong: controller.passcodeCheckFailed.value,
                      ),
                  ],
                ),
              ),
              SizedBox(height: h(165)),
              PasscodeNumbersRow(
                numbers: [1, 2, 3],
                onPressed: controller.addNumberToPasscodeCheck,
              ),
              PasscodeNumbersRow(
                numbers: [4, 5, 6],
                onPressed: controller.addNumberToPasscodeCheck,
              ),
              PasscodeNumbersRow(
                numbers: [7, 8, 9],
                onPressed: controller.addNumberToPasscodeCheck,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: w(49)),
                  TextButton(
                    onPressed: controller.cancelEnablingPasscode,
                    child: Text(
                      tr('cancel'),
                      style: TextStyleHelper.button(
                          color: Get.theme.colors().primary),
                    ),
                  ),
                  SizedBox(width: w(25.8)),
                  PasscodeNumber(
                    number: 0,
                    onPressed: controller.addNumberToPasscodeCheck,
                  ),
                  SizedBox(width: w(44)),
                  DeleteButton(onTap: controller.deleteNumber),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
