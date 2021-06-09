import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_settings_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';

class PasscodeSettingsScreen extends StatelessWidget {
  const PasscodeSettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PasscodeSettingsController());

    return WillPopScope(
      onWillPop: () async {
        controller.leavePasscodeSettingsScreen();
        // controller.leave();
        return true;
      },
      child: Scaffold(
        appBar: StyledAppBar(
          titleText: 'Passcode Lock',
          onLeadingPressed: controller.leavePasscodeSettingsScreen,
          // onLeadingPressed: controller.leave,
        ),
        body: Obx(
          () {
            if (controller.loaded.isTrue) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Obx(
                      () => SwitchListTile(
                        value: controller.isPasscodeEnable.value,
                        onChanged: (value) async =>
                            controller.onPasscodeTilePressed(value),
                        // controller.tryEnablingPasscode(),
                        title: Text(
                          'Включить код доступа',
                          style: TextStyleHelper.projectTitle,
                        ),
                      ),
                    ),
                    if (controller.isPasscodeEnable == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: TextButton(
                          onPressed: controller.tryChangingPasscode,
                          child: Text(
                            'Сменить код доступа',
                            style: TextStyleHelper.projectTitle.copyWith(
                                color:
                                    Theme.of(context).customColors().primary),
                          ),
                        ),
                      ),
                    const StyledDivider(leftPadding: 16, rightPadding: 16),
                    const SizedBox(height: 17),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 12),
                      child: RichText(
                        text: TextSpan(
                          text: _boldText,
                          style: TextStyleHelper.caption().copyWith(
                            color: Theme.of(context).customColors().onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: _text,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (controller.isFingerprintAvailable.value == true)
                      SwitchListTile(
                        value: controller.isFingerprintEnable.value,
                        onChanged: controller.toggleFingerprintStatus,
                        title: Text(
                          'Use Fingerprint to unlock',
                          style: TextStyleHelper.projectTitle,
                        ),
                      ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

String _boldText = 'Passсode Lock';

String _text = ''' - это код, который запрашивается, при запуске приложения.

Обратите внимание, если вы забудете код доступа, вам понадобится удалить или переустановить приложение.''';
