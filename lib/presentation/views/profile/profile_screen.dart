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
import 'package:projects/data/enums/user_status.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/portal_info_controller.dart';
import 'package:projects/domain/controllers/profile_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/internal/utils/text_utils.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/default_avatar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/settings/settings_screen.dart';

class SelfProfileScreen extends StatelessWidget {
  const SelfProfileScreen({Key? key}) : super(key: key);

  static String get pageName => tr('profile');

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>(tag: 'SelfProfileScreen');

    // arguments may be null or may not contain needed parameters
    // then Get.arguments['param_name'] will return null
    final args = ModalRoute.of(context)!.settings.arguments ?? Get.arguments;
    final bool showBackButton;
    if (args == null) {
      showBackButton = false;
    } else {
      showBackButton = args['showBackButton'] as bool? ?? false;
    }
    final bool showSettingsButton;
    if (args == null) {
      showSettingsButton = true;
    } else {
      showSettingsButton = args['showSettingsButton'] as bool? ?? true;
    }

    final platformController = Get.find<PlatformController>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
        appBar: StyledAppBar(
          backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
          showBackButton: showBackButton,
          leadingWidth: showBackButton && GetPlatform.isIOS
              ? TextUtils.getTextWidth(tr('closeLowerCase'), TextStyleHelper.button()) + 16
              : null,
          leading: showBackButton
              ? PlatformWidget(
                  cupertino: (_, __) => CupertinoButton(
                    padding: const EdgeInsets.only(left: 16),
                    alignment: Alignment.centerLeft,
                    onPressed: Get.back,
                    child: Text(
                      tr('closeLowerCase'),
                      style: TextStyleHelper.button(),
                    ),
                  ),
                  material: (_, __) => IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close),
                  ),
                )
              : null,
          // title: Text(
          //   tr('profile'),
          //   style: TextStyle(color: Theme.of(context).colors().onSurface),
          // ),
          titleText: tr('profile'),
          centerTitle: !GetPlatform.isAndroid,
          actions: [
            if (showSettingsButton)
              PlatformIconButton(
                cupertino: (_, __) {
                  return CupertinoIconButtonData(
                    icon: AppIcon(
                      icon: SvgIcons.settings,
                      color: Theme.of(context).colors().primary,
                    ),
                    onPressed: () => Get.find<NavigationController>().to(
                      const SettingsScreen(),
                      arguments: {'previousPage': pageName},
                    ),
                    padding: EdgeInsets.zero,
                  );
                },
                materialIcon: const AppIcon(icon: SvgIcons.settings),
                onPressed: () => Get.find<NavigationController>().to(const SettingsScreen()),
              )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              Obx(
                () => Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Opacity(
                      opacity: profileController.status.value == UserStatus.Terminated ? 0.4 : 1.0,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Theme.of(context).colors().bgDescription,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: profileController.avatar.value),
                      ),
                    ),
                    if (profileController.status.value == UserStatus.Terminated)
                      const Positioned(
                          bottom: 0,
                          right: 15,
                          child: AppIcon(icon: SvgIcons.userBlocked, width: 32, height: 32)),
                    if ((profileController.isAdmin.value || profileController.isOwner.value) &&
                        profileController.status.value != UserStatus.Terminated)
                      const Positioned(
                          bottom: 0,
                          right: 15,
                          child: AppIcon(icon: SvgIcons.userAdmin, width: 32, height: 32)),
                    if (profileController.isVisitor.value &&
                        profileController.status.value != UserStatus.Terminated)
                      const Positioned(
                          bottom: 0,
                          right: 15,
                          child: AppIcon(icon: SvgIcons.userVisitor, width: 32, height: 32)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(
                  () => Text(
                    profileController.username.value,
                    style: TextStyleHelper.headline6(
                      color: Theme.of(context).colors().onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 68),
              Obx(
                () => _ProfileInfoTile(
                  caption: '${tr('email')}:',
                  text: profileController.email.value,
                  icon: SvgIcons.message,
                ),
              ),
              Obx(
                () => _ProfileInfoTile(
                  caption: '${tr('portalAdress')}:',
                  text: profileController.portalName.value,
                  icon: SvgIcons.cloud,
                ),
              ),
              const SizedBox(height: 48),
              _ProfileInfoTile(
                text: tr('logOut'),
                icon: SvgIcons.logout,
                onTap: () async => profileController.logout(context),
              ),
              _ProfileInfoTile(
                text: tr('Delete account'),
                textColor: Theme.of(context).colors().colorError,
                icon: SvgIcons.delete,
                iconColor: Theme.of(context).colors().colorError.withOpacity(0.6),
                onTap: () async => profileController.deleteAccount(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments ?? Get.arguments;
    final controller = args['controller'] as PortalUserItemController;
    final portalUser = controller.portalUser;
    final portalInfoController = Get.find<PortalInfoController>();
    portalInfoController.setup();

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
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Obx(() => CustomNetworkImage(
                            image: controller.profileAvatar.value,
                            defaultImage: const DefaultAvatar(),
                            fit: BoxFit.contain,
                          )),
                    ),
                  ),
                  if (portalUser.status == UserStatus.Terminated)
                    const Positioned(
                        bottom: 0,
                        right: 15,
                        child: AppIcon(icon: SvgIcons.userBlocked, width: 32, height: 32)),
                  if ((portalUser.isAdmin == true || portalUser.isOwner == true) &&
                      portalUser.status != UserStatus.Terminated)
                    const Positioned(
                        bottom: 0,
                        right: 15,
                        child: AppIcon(icon: SvgIcons.userAdmin, width: 32, height: 32)),
                  if (portalUser.isVisitor == true && portalUser.status != UserStatus.Terminated)
                    const Positioned(
                        bottom: 0,
                        right: 15,
                        child: AppIcon(icon: SvgIcons.userVisitor, width: 16, height: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  portalUser.displayName!,
                  style: TextStyleHelper.headline6(
                    color: Theme.of(context).colors().onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 68),
              _ProfileInfoTile(
                caption: '${tr('email')}:',
                text: portalUser.email ?? '',
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
  final int? maxLines;
  final bool enableBorder;
  final TextStyle? textStyle;
  final String text;
  final String? icon;
  final Color? iconColor;
  final String? caption;
  final Function()? onTap;
  final Color? textColor;
  final EdgeInsetsGeometry suffixPadding;
  final TextOverflow textOverflow;

  const _ProfileInfoTile({
    Key? key,
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
    required this.text,
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
                          color: iconColor ?? Theme.of(context).colors().onSurface.withOpacity(0.6))
                      : null,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: caption != null && caption!.isNotEmpty ? 10 : 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (caption != null && caption!.isNotEmpty)
                          Text(caption!,
                              style: TextStyleHelper.caption(
                                  color:
                                      Theme.of(context).colors().onBackground.withOpacity(0.75))),
                        Text(text,
                            maxLines: maxLines,
                            overflow: textOverflow,
                            style: textStyle ??
                                TextStyleHelper.subtitle1(
                                    // ignore: prefer_if_null_operators
                                    color: textColor ?? Theme.of(context).colors().onSurface))
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
