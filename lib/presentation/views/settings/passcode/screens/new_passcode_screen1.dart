import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_settings_controller.dart';
import 'package:projects/internal/utils/adaptive_size.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_dot.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_numbers.dart';

class NewPasscodeScreen1 extends StatelessWidget {
  const NewPasscodeScreen1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PasscodeSettingsController>();
    final arguments = Get.arguments;
    var title;
    var caption;

    if (arguments != null) {
      title = arguments['title'] ?? tr('enterPasscode');
      caption = arguments['caption'] ?? tr('choosePasscode');
    }
    title = title ?? tr('enterPasscode');
    caption = caption ?? tr('choosePasscode');

    return WillPopScope(
      onWillPop: () async {
        controller.cancelEnablingPasscode();
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h(170)),
              Text(title,
                  style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onBackground)),
              SizedBox(height: h(16)),
              Text(caption,
                  style: TextStyleHelper.subtitle1(
                      color: Get.theme.colors().onBackground.withOpacity(0.6))),
              SizedBox(height: h(32)),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 4; i++)
                      PasscodeDot(
                        inputLenght: controller.passcodeLen.value,
                        position: i,
                      ),
                  ],
                ),
              ),
              SizedBox(height: h(150)),
              PasscodeNumbersRow(
                numbers: [1, 2, 3],
                onPressed: controller.addNumberToPasscode,
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
                    onPressed: controller.addNumberToPasscode,
                  ),
                  SizedBox(width: w(44)),
                  InkResponse(
                    onTap: controller.deleteNumber,
                    child: AppIcon(icon: SvgIcons.delete_number),
                  ),
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
