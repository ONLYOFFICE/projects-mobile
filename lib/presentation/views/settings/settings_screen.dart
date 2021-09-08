import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/settings/settings_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

import 'package:projects/presentation/views/settings/color_theme_selection_screen.dart';
import 'package:projects/presentation/views/settings/passcode/screens/passcode_settings_screen.dart';

import 'package:projects/presentation/views/settings/setting_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SettingsController());
    final platformController = Get.find<PlatformController>();

    return WillPopScope(
      onWillPop: () async {
        controller.leave();
        return true;
      },
      child: Scaffold(
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
        appBar: StyledAppBar(
          backgroundColor:
              platformController.isMobile ? null : Get.theme.colors().surface,
          titleText: tr('settings'),
          onLeadingPressed: controller.leave,
          backButtonIcon: Get.put(PlatformController()).isMobile
              ? const Icon(Icons.arrow_back_rounded)
              : const Icon(Icons.close),
        ),
        body: Obx(
          () {
            if (controller.loaded.value == true) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    SettingTile(
                      text: tr('passcodeLock'),
                      loverText: controller.isPasscodeEnable.value == true
                          ? tr('enabled')
                          : tr('disabled'),
                      enableIconOpacity: true,
                      icon: SvgIcons.passcode,
                      onTap: () => Get.find<NavigationController>().toScreen(
                        const PasscodeSettingsScreen(),
                      ),
                    ),
                    SettingTile(
                      text: tr('colorTheme'),
                      loverText: tr(controller.currentTheme.value),
                      enableIconOpacity: true,
                      icon: SvgIcons.color_scheme,
                      enableUnderline: true,
                      onTap: () => Get.find<NavigationController>().toScreen(
                        const ColorThemeSelectionScreen(),
                      ),
                    ),
                    SettingTile(
                      text: tr('help'),
                      enableIconOpacity: true,
                      icon: SvgIcons.help,
                      onTap: controller.onHelpPressed,
                    ),
                    SettingTile(
                      text: tr('support'),
                      icon: SvgIcons.support,
                      enableUnderline: true,
                      onTap: () => controller.onSupportPressed(context),
                    ),
                    SettingTile(
                      text: tr('rateApp'),
                      icon: SvgIcons.rate_app,
                      onTap: controller.onRateAppPressed,
                    ),
                    SettingTile(
                      text: tr('userAgreement'),
                      icon: SvgIcons.user_agreement,
                      onTap: controller.onUserAgreementPressed,
                    ),
                    SettingTile(
                      text: tr('analytics'),
                      icon: SvgIcons.analytics,
                      onTap: controller.onAnalyticsPressed,
                    ),
                    SettingTile(
                      text: tr('version'),
                      icon: SvgIcons.version,
                      suffixText: controller.versionAndBuildNumber,
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
