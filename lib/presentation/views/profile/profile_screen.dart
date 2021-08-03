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
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';
import 'package:projects/domain/controllers/profile_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

class SelfProfileScreen extends StatelessWidget {
  const SelfProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userController = Get.find<UserController>();
    var portalInfoController = Get.find<PortalInfoController>();

    var profileController = Get.put(ProfileController());

    var showBackButton = Get.arguments['showBackButton'];
    var showSettingsButton = Get.arguments['showSettingsButton'];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: StyledAppBar(
          showBackButton: showBackButton ?? false,
          backButtonIcon: Get.put(PlatformController()).isMobile
              ? const Icon(Icons.arrow_back_rounded)
              : const Icon(Icons.close),
          titleText: tr('profile'),
          actions: [
            if (showSettingsButton)
              IconButton(
                icon: AppIcon(icon: SvgIcons.settings),
                onPressed: () => Get.toNamed('SettingsScreen'),
              )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.grey, shape: BoxShape.circle),
                height: 120,
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: CustomNetworkImage(
                    image: userController.user?.avatar ??
                        userController.user?.avatarMedium ??
                        userController.user?.avatarSmall,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  userController.user?.displayName,
                  style: TextStyleHelper.headline6(
                    color: Get.theme.colors().onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 68),
              _ProfileInfoTile(
                caption: '${tr('email')}:',
                text: userController.user?.email ?? '',
                icon: SvgIcons.message,
              ),
              _ProfileInfoTile(
                caption: '${tr('portalAdress')}:',
                text: portalInfoController.portalName ?? '',
                icon: SvgIcons.cloud,
              ),
              _ProfileInfoTile(
                text: tr('logOut'),
                textColor: Get.theme.colors().colorError,
                icon: SvgIcons.logout,
                iconColor: Get.theme.colors().colorError.withOpacity(0.6),
                onTap: () async => profileController.logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PortalUser portalUser = Get.arguments['portalUser'];
    var portalInfoController = Get.find<PortalInfoController>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: StyledAppBar(
          showBackButton: true,
          titleText: tr('profile'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.grey, shape: BoxShape.circle),
                height: 120,
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: CustomNetworkImage(
                    image: portalUser?.avatar ??
                        portalUser?.avatarMedium ??
                        portalUser?.avatarSmall,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  portalUser?.displayName,
                  style: TextStyleHelper.headline6(
                    color: Get.theme.colors().onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 68),
              _ProfileInfoTile(
                caption: '${tr('email')}:',
                text: portalUser?.email ?? '',
                icon: SvgIcons.message,
              ),
              _ProfileInfoTile(
                caption: '${tr('portalAdress')}:',
                text: portalInfoController.portalName ?? '',
                icon: SvgIcons.cloud,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO instead crerate shared styledTile
class _ProfileInfoTile extends StatelessWidget {
  final int maxLines;
  final bool enableBorder;
  final TextStyle textStyle;
  final String text;
  final String icon;
  final Color iconColor;
  final String caption;
  final Function() onTap;
  final Color textColor;
  final EdgeInsetsGeometry suffixPadding;
  final TextOverflow textOverflow;

  const _ProfileInfoTile({
    Key key,
    this.caption,
    this.enableBorder = true,
    this.icon,
    this.iconColor,
    this.maxLines,
    this.onTap,
    this.suffixPadding = const EdgeInsets.symmetric(horizontal: 25),
    this.textOverflow = TextOverflow.ellipsis,
    this.textColor,
    this.textStyle,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 56,
                  child: icon != null
                      ? AppIcon(
                          icon: icon,
                          color: iconColor ??
                              Get.theme.colors().onSurface.withOpacity(0.6))
                      : null,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            caption != null && caption.isNotEmpty ? 10 : 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (caption != null && caption.isNotEmpty)
                          Text(caption,
                              style: TextStyleHelper.caption(
                                  color: Get.theme
                                      .colors()
                                      .onBackground
                                      .withOpacity(0.75))),
                        Text(text,
                            maxLines: maxLines,
                            overflow: textOverflow,
                            style: textStyle ??
                                TextStyleHelper.subtitle1(
                                    // ignore: prefer_if_null_operators
                                    color: textColor ??
                                        Get.theme.colors().onSurface))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
