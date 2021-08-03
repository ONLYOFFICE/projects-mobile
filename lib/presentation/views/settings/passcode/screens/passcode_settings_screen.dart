import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_settings_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
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
          titleText: tr('passcodeLock'),
          onLeadingPressed: controller.leavePasscodeSettingsScreen,
          backButtonIcon: Get.put(PlatformController()).isMobile
              ? const Icon(Icons.arrow_back_rounded)
              : const Icon(Icons.close),
          // onLeadingPressed: controller.leave,
        ),
        body: Obx(
          () {
            if (controller.loaded.value == true) {
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
                          tr('enablePasscode'),
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
                            tr('changePasscode'),
                            style: TextStyleHelper.projectTitle
                                .copyWith(color: Get.theme.colors().primary),
                          ),
                        ),
                      ),
                    const StyledDivider(leftPadding: 16, rightPadding: 16),
                    const SizedBox(height: 17),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 12),
                      child: RichText(
                        text: TextSpan(
                          text: tr('passcodeLock'),
                          style: TextStyleHelper.caption().copyWith(
                            color: Get.theme.colors().onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: " - ${tr('passcodeLockDescription')}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (controller.isFingerprintAvailable.value == true &&
                        controller.isPasscodeEnable.value == true)
                      SwitchListTile(
                        value: controller.isFingerprintEnable.value,
                        onChanged: controller.toggleFingerprintStatus,
                        title: Text(
                          tr('fingerprint'),
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
