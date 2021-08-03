/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/settings/settings_controller.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

import 'package:projects/presentation/shared/widgets/styled_divider.dart';
import 'package:projects/presentation/views/settings/color_theme_selection_screen.dart';
import 'package:projects/presentation/views/settings/passcode/screens/passcode_settings_screen.dart';

import 'package:projects/presentation/views/settings/setting_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SettingsController());

    return WillPopScope(
      onWillPop: () async {
        controller.leave();
        return true;
      },
      child: Scaffold(
        appBar: StyledAppBar(
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
                      loverText: controller.isPasscodeEnable == true
                          ? tr('enabled')
                          : tr('disabled'),
                      enableIconOpacity: true,
                      icon: SvgIcons.passcode,
                      onTap: () => Get.find<NavigationController>().showScreen(
                        const PasscodeSettingsScreen(),
                      ),
                    ),
                    SettingTile(
                      text: tr('colorTheme'),
                      loverText: tr(controller.currentTheme.value),
                      enableIconOpacity: true,
                      icon: SvgIcons.color_scheme,
                      onTap: () => Get.find<NavigationController>().showScreen(
                        const ColorThemeSelectionScreen(),
                      ),
                    ),
                    SettingTile(
                      text: tr('clearCache'),
                      enableIconOpacity: true,
                      icon: SvgIcons.clean,
                      enableUnderline: true,
                      onTap: controller.onClearCachePressed,
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
