import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_controller.dart';

import 'package:projects/internal/utils/adaptive_size.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_dot.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_numbers.dart';

class PasscodeScreen extends StatelessWidget {
  const PasscodeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PasscodeController());

    return Scaffold(
      body: Obx(
        () {
          if (controller.loaded.isTrue) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: h(170)),
                  Text(
                    tr('passcodeToUnlock'),
                    textAlign: TextAlign.center,
                    style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onBackground,
                    ),
                  ),
                  SizedBox(
                    height: h(72),
                    child: Column(
                      children: [
                        const Flexible(flex: 1, child: SizedBox(height: 16)),
                        if (controller.passcodeCheckFailed.isTrue)
                          Text(tr('incorrectPIN'),
                              style: TextStyleHelper.subtitle1(
                                  color: Get.theme.colors().colorError)),
                        const Flexible(flex: 2, child: SizedBox(height: 32)),
                      ],
                    ),
                  ),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < 4; i++)
                          PasscodeDot(
                            inputLenght: controller.passcodeLen.value,
                            position: i,
                            passwordIsWrong:
                                controller.passcodeCheckFailed.value,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: h(150)),
                  PasscodeNumbersRow(
                    numbers: [1, 2, 3],
                    onPressed: controller.addNumberToPasscode,
                    // onPressed: print,
                  ),
                  PasscodeNumbersRow(
                    numbers: [4, 5, 6],
                    onPressed: controller.addNumberToPasscode,
                  ),
                  PasscodeNumbersRow(
                    numbers: [7, 8, 9],
                    onPressed: controller.addNumberToPasscode,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (!controller.isFingerprintAvailable ||
                          !controller.isFingerprintEnable)
                        SizedBox(width: w(47)),
                      SizedBox(width: w(63)),
                      if (controller.isFingerprintAvailable &&
                          controller.isFingerprintEnable)
                        IconButton(
                          icon: AppIcon(icon: SvgIcons.finger_print),
                          onPressed: () => controller.useFingerprint(),
                        ),
                      SizedBox(width: w(41.2)),
                      // const SizedBox(width: 17),
                      PasscodeNumber(
                          number: 0, onPressed: controller.addNumberToPasscode),
                      SizedBox(width: w(40)),
                      IconButton(
                        icon: AppIcon(icon: SvgIcons.delete_number),
                        onPressed: controller.deleteNumber,
                      )
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
