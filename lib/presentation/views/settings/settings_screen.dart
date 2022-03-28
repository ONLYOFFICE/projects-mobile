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
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/settings/settings_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/shared/wrappers/platform_widget.dart';
import 'package:projects/presentation/views/settings/color_theme_selection_screen.dart';
import 'package:projects/presentation/views/settings/passcode/screens/passcode_settings_screen.dart';
import 'package:projects/presentation/views/settings/setting_tile.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final platformController = Get.find<PlatformController>();

    controller.setupCacheDirectorySize();

    final mobileAppBar = StyledAppBar(
      backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
      titleText: tr('settings'),
      onLeadingPressed: controller.leave,
      backButtonIcon: platformController.isMobile
          ? Icon(PlatformIcons(context).back)
          : Icon(PlatformIcons(context).clear),
    );

    final tabletAppBar = StyledAppBar(
      backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
      titleText: tr('settings'),
      leadingWidth: GetPlatform.isIOS ? 100 : null,
      leading: PlatformWidget(
        cupertino: (_, __) => CupertinoButton(
          padding: const EdgeInsets.only(left: 16),
          alignment: Alignment.centerLeft,
          onPressed: controller.leave,
          child: Text(
            tr('closeLowerCase'),
            style: TextStyleHelper.button(),
          ),
        ),
        material: (_, __) => IconButton(
          onPressed: controller.leave,
          icon: const Icon(Icons.close),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: platformController.isMobile ? mobileAppBar : tabletAppBar,
      body: Obx(
        () {
          if (controller.loaded.value == true) {
            if (GetPlatform.isAndroid) {
              return ListView.custom(
                childrenDelegate: SliverChildListDelegate(
                  [
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
                        transition: Transition.rightToLeft,
                        isRootModalScreenView: false,
                      ),
                    ),
                    SettingTile(
                      text: tr('colorTheme'),
                      loverText: tr(controller.currentTheme.value),
                      enableIconOpacity: true,
                      icon: SvgIcons.color_scheme,
                      onTap: () => Get.find<NavigationController>().toScreen(
                        const ColorThemeSelectionScreen(),
                        transition: Transition.rightToLeft,
                        isRootModalScreenView: false,
                      ),
                    ),
                    SettingTile(
                      text: tr('clearCache'),
                      enableIconOpacity: true,
                      icon: SvgIcons.clean,
                      enableUnderline: true,
                      onTap: () {
                        Get.dialog(
                          StyledAlertDialog(
                            title: Text(tr('clearCacheQuestion')),
                            // content: Text(tr('clearCacheQuestionDescription')),
                            cancelText: tr('cancel').toLowerCase().capitalizeFirst,
                            acceptText: tr('clearCache'),
                            onCancelTap: () {
                              Navigator.pop(context);
                            },
                            onAcceptTap: () {
                              controller.onClearCachePressed();
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                      suffix: Obx(
                        () => Text(
                          controller.cacheSize.value,
                          style: TextStyleHelper.body2(
                              color: Theme.of(context).colors().onSurface.withOpacity(0.6)),
                        ),
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
                      onTap: controller.onSupportPressed,
                    ),
                    SettingTile(
                      text: tr('rateApp'),
                      icon: SvgIcons.rate_app,
                      enableUnderline: true,
                      onTap: controller.onRateAppPressed,
                    ),
                    SettingTile(
                      text: tr('privacyAndTermsFooter.privacyPolicyWithLink'),
                      icon: SvgIcons.privacy_policy,
                      onTap: controller.onPrivacyPolicyPressed,
                    ),
                    SettingTile(
                      text: tr('privacyAndTermsFooter.termsOfServiceWithLink'),
                      icon: SvgIcons.terms_of_service,
                      onTap: controller.onTermsOfServicePressed,
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
                  addAutomaticKeepAlives: false,
                ),
              );
            } else {
              return SettingsList(
                darkTheme: const SettingsThemeData().copyWith(
                  settingsListBackground: platformController.isMobile
                      ? Get.theme.colors().backgroundSecond
                      : Get.theme.colors().surface,
                  settingsSectionBackground:
                      platformController.isMobile ? null : Get.theme.colors().bgDescription,
                ),
                applicationType: ApplicationType.cupertino,
                sections: [
                  SettingsSection(
                    tiles: [
                      SettingsTile.navigation(
                        onPressed: (_) => Get.find<NavigationController>().toScreen(
                          const PasscodeSettingsScreen(),
                          transition: Transition.rightToLeft,
                          isRootModalScreenView: false,
                        ),
                        title: Text(
                          tr('passcodeLock'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.subtitle1(color: Get.theme.colors().onBackground),
                        ),
                        trailing: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.isPasscodeEnable.value == true
                                  ? tr('enabled')
                                  : tr('disabled'),
                              style: TextStyleHelper.body2(
                                color: Get.theme.colors().onBackground.withOpacity(0.75),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Get.theme.colors().onBackground.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SettingsSection(
                    tiles: [
                      SettingsTile.navigation(
                        onPressed: (_) => Get.find<NavigationController>().toScreen(
                          const ColorThemeSelectionScreen(),
                          transition: Transition.rightToLeft,
                          isRootModalScreenView: false,
                        ),
                        title: Text(
                          tr('colorTheme'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.subtitle1(color: Get.theme.colors().onBackground),
                        ),
                        trailing: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              tr(controller.currentTheme.value),
                              style: TextStyleHelper.body2(
                                color: Get.theme.colors().onBackground.withOpacity(0.75),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Get.theme.colors().onBackground.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SettingsSection(
                    tiles: [
                      SettingsTile(
                        onPressed: (context) {
                          if (platformController.isMobile) {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => CupertinoActionSheet(
                                title: Text(tr('clearCacheQuestion')),
                                message: Text(tr('clearCacheQuestionDescription')),
                                actions: <CupertinoActionSheetAction>[
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      controller.onClearCachePressed();
                                      Navigator.pop(context);
                                    },
                                    isDestructiveAction: true,
                                    child: Text(tr('clearCache')),
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  isDefaultAction: true,
                                  child: Text(tr('cancel').toLowerCase().capitalizeFirst!),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          } else {
                            showCupertinoDialog<void>(
                              context: context,
                              builder: (BuildContext context) => CupertinoAlertDialog(
                                title: Text(tr('clearCacheQuestion')),
                                content: Text(tr('clearCacheQuestionDescription')),
                                actions: <CupertinoDialogAction>[
                                  CupertinoDialogAction(
                                    child: Text(tr('cancel').toLowerCase().capitalizeFirst!),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      controller.onClearCachePressed();
                                      Navigator.pop(context);
                                    },
                                    child: Text(tr('clearCache')),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                        title: Text(
                          tr('clearCache'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.subtitle1(color: Get.theme.colors().onBackground),
                        ),
                        trailing: Obx(
                          () => Text(
                            controller.cacheSize.value,
                            style: TextStyleHelper.body1(color: CupertinoColors.activeBlue),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SettingsSection(
                    tiles: [
                      SettingsTile(
                        onPressed: (_) => controller.onHelpPressed(),
                        title: Text(
                          tr('help'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.subtitle1(color: Get.theme.colors().onBackground),
                        ),
                      ),
                      SettingsTile(
                        onPressed: (_) => controller.onSupportPressed(),
                        title: Text(
                          tr('support'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.subtitle1(color: Get.theme.colors().onBackground),
                        ),
                      ),
                      SettingsTile(
                        onPressed: (_) => controller.onRateAppPressed(),
                        title: Text(
                          tr('rateApp'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.subtitle1(color: Get.theme.colors().onBackground),
                        ),
                      ),
                      SettingsTile(
                        onPressed: (_) => controller.onPrivacyPolicyPressed(),
                        title: Text(
                          tr('privacyAndTermsFooter.privacyPolicyWithLink'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.subtitle1(color: Get.theme.colors().onBackground),
                        ),
                      ),
                      SettingsTile(
                        onPressed: (_) => controller.onTermsOfServicePressed(),
                        title: Text(
                          tr('privacyAndTermsFooter.termsOfServiceWithLink'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.subtitle1(color: Get.theme.colors().onBackground),
                        ),
                      ),
                      SettingsTile.navigation(
                        onPressed: (_) => controller.onAnalyticsPressed(),
                        title: Text(
                          tr('analytics'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.subtitle1(color: Get.theme.colors().onBackground),
                        ),
                      ),
                      SettingsTile(
                        title: Text(
                          tr('version'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.subtitle1(color: Get.theme.colors().onBackground),
                        ),
                        trailing: Text(
                          controller.versionAndBuildNumber,
                          style: TextStyleHelper.body2(
                              color: Theme.of(context).colors().onSurface.withOpacity(0.6)),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
