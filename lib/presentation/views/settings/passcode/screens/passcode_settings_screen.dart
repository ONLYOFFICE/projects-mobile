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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:projects/domain/controllers/passcode/passcode_settings_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/option_with_switch.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:settings_ui/settings_ui.dart';

class PasscodeSettingsScreen extends StatelessWidget {
  const PasscodeSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments ?? Get.arguments;
    final previousPage = args['previousPage'] as String?;

    final controller = Get.put(PasscodeSettingsController());
    final platformController = Get.find<PlatformController>();

    Color backgroundColor;
    if (GetPlatform.isAndroid) {
      if (platformController.isMobile) {
        Theme.of(context).brightness == Brightness.dark
            ? backgroundColor = Theme.of(context).colors().background
            : backgroundColor = Theme.of(context).colors().surface;
      } else {
        backgroundColor = Theme.of(context).colors().surface;
      }
    } else {
      if (platformController.isMobile) {
        Theme.of(context).brightness == Brightness.dark
            ? backgroundColor = Theme.of(context).colors().backgroundSecond
            : backgroundColor = CupertinoColors.systemGrey6;
      } else {
        Theme.of(context).brightness == Brightness.dark
            ? backgroundColor = Theme.of(context).colors().surface
            : backgroundColor = CupertinoColors.systemGrey6;
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: StyledAppBar(
        titleText: tr('passcodeLock'),
        backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
        onLeadingPressed: controller.leavePasscodeSettingsScreen,
        previousPageTitle: previousPage,
      ),
      body: Obx(
        () {
          if (controller.loaded.value == true) {
            if (GetPlatform.isAndroid) {
              return ListView.custom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                childrenDelegate: SliverChildListDelegate([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 3),
                      TextButton(
                        onPressed: () =>
                            controller.onPasscodeTilePressed(!controller.isPasscodeEnable.value),
                        style: ButtonStyle(
                          alignment: Alignment.centerLeft,
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: Text(
                          controller.isPasscodeEnable.value
                              ? tr('disablePasscode')
                              : tr('enablePasscode'),
                          style:
                              TextStyleHelper.subtitle1(color: Theme.of(context).colors().primary),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      if (controller.isPasscodeEnable.value == true)
                        TextButton(
                          onPressed: controller.tryChangingPasscode,
                          style: ButtonStyle(
                            alignment: Alignment.centerLeft,
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: Text(
                            tr('changePasscode'),
                            style: TextStyleHelper.subtitle1(
                                color: Theme.of(context).colors().primary),
                          ),
                        ),
                      const StyledDivider(),
                      const SizedBox(height: 17),
                      RichText(
                        text: TextSpan(
                          text: tr('passcodeLock'),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colors().onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: " - ${tr('passcodeLockDescription')}",
                              // style: const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      if (controller.isBiometricAvailable.value == true &&
                          controller.isPasscodeEnable.value == true)
                        OptionWithSwitch(
                            title: controller.biometricType == BiometricType.fingerprint
                                ? tr('fingerprint')
                                : tr('faceId'),
                            style: TextStyleHelper.subtitle1(
                                color: Theme.of(context).colors().onSurface),
                            switchOnChanged: controller.tryTogglingFingerprintStatus,
                            switchValue: controller.isBiometricEnable),
                    ],
                  ),
                ]),
              );
            } else {
              final scaleFactor = MediaQuery.of(context).textScaleFactor;
              return ListView.custom(
                childrenDelegate: SliverChildListDelegate(
                  [
                    SettingsList(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      darkTheme: const SettingsThemeData().copyWith(
                        settingsListBackground: platformController.isMobile
                            ? Theme.of(context).colors().backgroundSecond
                            : Theme.of(context).colors().surface,
                        settingsSectionBackground: platformController.isMobile
                            ? null
                            : Theme.of(context).colors().bgDescription,
                      ),
                      applicationType: ApplicationType.cupertino,
                      sections: [
                        SettingsSection(
                          margin: EdgeInsetsDirectional.only(
                            top: 14.0 * scaleFactor,
                            bottom: 10 * scaleFactor,
                            start: 16,
                            end: 16,
                          ),
                          tiles: [
                            SettingsTile(
                              onPressed: (_) => controller
                                  .onPasscodeTilePressed(!controller.isPasscodeEnable.value),
                              title: Text(
                                controller.isPasscodeEnable.value
                                    ? tr('disablePasscode')
                                    : tr('enablePasscode'),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyleHelper.subtitle1(
                                    color: Theme.of(context).colors().primary),
                              ),
                            ),
                            if (controller.isPasscodeEnable.value == true)
                              SettingsTile(
                                onPressed: (_) => controller.tryChangingPasscode(),
                                title: Text(
                                  tr('changePasscode'),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyleHelper.subtitle1(
                                      color: Theme.of(context).colors().primary),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 27.5),
                      child: RichText(
                        text: TextSpan(
                          text: tr('passcodeLock'),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colors().onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: " - ${tr('passcodeLockDescription')}",
                              // style: const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (controller.isBiometricAvailable.value == true &&
                        controller.isPasscodeEnable.value == true)
                      SettingsList(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        darkTheme: const SettingsThemeData().copyWith(
                          settingsListBackground: platformController.isMobile
                              ? null
                              : Theme.of(context).colors().surface,
                          settingsSectionBackground: platformController.isMobile
                              ? null
                              : Theme.of(context).colors().bgDescription,
                        ),
                        applicationType: ApplicationType.cupertino,
                        sections: [
                          SettingsSection(
                            tiles: [
                              SettingsTile.switchTile(
                                initialValue: controller.isBiometricEnable.value,
                                onToggle: controller.tryTogglingFingerprintStatus,
                                activeSwitchColor: Theme.of(context).colors().primary,
                                title: Text(
                                  controller.biometricTypeDescription,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyleHelper.subtitle1(
                                      color: Theme.of(context).colors().primary),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              );
            }
          } else {
            return Center(child: PlatformCircularProgressIndicator());
          }
        },
      ),
    );
  }
}
