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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/settings/settings_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:settings_ui/settings_ui.dart';

class ColorThemeSelectionScreen extends StatelessWidget {
  const ColorThemeSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments ?? Get.arguments;
    final previousPage = args['previousPage'] as String?;

    final controller = Get.find<SettingsController>();
    final platformController = Get.find<PlatformController>();

    return Obx(
      () => Scaffold(
        backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
        appBar: StyledAppBar(
          backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
          titleText: tr('colorTheme'),
          onLeadingPressed: controller.back,
          previousPageTitle: previousPage,
        ),
        body: GetPlatform.isAndroid
            ? ListView.custom(
                childrenDelegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 10),
                    _ColorThemeTile(
                      text: tr('sameAsSystem'),
                      isSelected: controller.currentTheme.value == 'sameAsSystem',
                      onTap: () async => await controller.setTheme('sameAsSystem'),
                    ),
                    const StyledDivider(leftPadding: 16, rightPadding: 16),
                    _ColorThemeTile(
                      text: tr('lightTheme'),
                      isSelected: controller.currentTheme.value == 'lightTheme',
                      onTap: () async => await controller.setTheme('lightTheme'),
                    ),
                    const StyledDivider(leftPadding: 16, rightPadding: 16),
                    _ColorThemeTile(
                      text: tr('darkTheme'),
                      onTap: () async => await controller.setTheme('darkTheme'),
                      isSelected: controller.currentTheme.value == 'darkTheme',
                    ),
                  ],
                  addAutomaticKeepAlives: false,
                ),
              )
            : SettingsList(
                darkTheme: const SettingsThemeData().copyWith(
                  settingsListBackground: platformController.isMobile
                      ? Theme.of(context).colors().backgroundSecond
                      : Theme.of(context).colors().surface,
                  settingsSectionBackground:
                      platformController.isMobile ? null : Theme.of(context).colors().bgDescription,
                ),
                applicationType: ApplicationType.cupertino,
                sections: [
                  SettingsSection(
                    tiles: [
                      SettingsTile(
                        onPressed: (_) async => await controller.setTheme('sameAsSystem'),
                        title: Text(
                          tr('sameAsSystem'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.subtitle1(
                              color: Theme.of(context).colors().onBackground),
                        ),
                        trailing: controller.currentTheme.value == 'sameAsSystem'
                            ? Icon(
                                PlatformIcons(context).checkMark,
                                size: 20,
                                color: Theme.of(context).colors().primary,
                              )
                            : null,
                      ),
                      SettingsTile(
                        onPressed: (_) async => await controller.setTheme('lightTheme'),
                        title: Text(
                          tr('lightTheme'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.subtitle1(
                              color: Theme.of(context).colors().onBackground),
                        ),
                        trailing: controller.currentTheme.value == 'lightTheme'
                            ? Icon(
                                PlatformIcons(context).checkMark,
                                size: 20,
                                color: Theme.of(context).colors().primary,
                              )
                            : null,
                      ),
                      SettingsTile(
                        onPressed: (_) async => await controller.setTheme('darkTheme'),
                        title: Text(
                          tr('darkTheme'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.subtitle1(
                              color: Theme.of(context).colors().onBackground),
                        ),
                        trailing: controller.currentTheme.value == 'darkTheme'
                            ? Icon(
                                PlatformIcons(context).checkMark,
                                size: 20,
                                color: Theme.of(context).colors().primary,
                              )
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _ColorThemeTile extends StatelessWidget {
  final String text;
  final bool? isSelected;
  final Function? onTap;
  const _ColorThemeTile({
    Key? key,
    required this.text,
    this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 28, 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyleHelper.subtitle1()),
            if (isSelected!)
              Icon(
                PlatformIcons(context).checkMark,
                color: Theme.of(context).colors().onBackground.withOpacity(0.6),
              )
          ],
        ),
      ),
    );
  }
}
