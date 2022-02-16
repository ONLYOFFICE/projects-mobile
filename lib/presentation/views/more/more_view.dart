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
import 'package:projects/data/enums/user_status.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/profile_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class MoreView extends StatelessWidget {
  const MoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final portalUser = Get.find<ProfileController>(tag: 'SelfProfileScreen');

    return Container(
      height: 312,
      decoration: BoxDecoration(
        color: Get.theme.colors().primarySurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Get.find<NavigationController>().changeTabIndex(4),
            child: Container(
                constraints: const BoxConstraints(minHeight: 76),
                padding: const EdgeInsets.fromLTRB(12, 16, 10, 15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Get.theme.colors().outline, width: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Get.theme.colors().bgDescription,
                            child: ClipOval(
                              child: Obx(() {
                                return portalUser.avatar.value;
                              }),
                            ),
                          ),
                          if (portalUser.status.value == UserStatus.Terminated)
                            const Positioned(
                                bottom: 0,
                                right: 0,
                                child: AppIcon(icon: SvgIcons.userBlocked, width: 16, height: 16)),
                          if ((portalUser.isAdmin.value || portalUser.isOwner.value) &&
                              portalUser.status.value != UserStatus.Terminated)
                            const Positioned(
                                bottom: 0,
                                right: 0,
                                child: AppIcon(icon: SvgIcons.userAdmin, width: 16, height: 16)),
                          if (portalUser.isVisitor.value &&
                              portalUser.status.value != UserStatus.Terminated)
                            const Positioned(
                                bottom: 0,
                                right: 0,
                                child: AppIcon(icon: SvgIcons.userVisitor, width: 16, height: 16)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return Text(
                              portalUser.username.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleHelper.subtitle1(color: Get.theme.colors().onNavBar),
                            );
                          }),
                          Obx(() {
                            return Text(
                              portalUser.portalName.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleHelper.body2(
                                  color: Get.theme.colors().onNavBar.withOpacity(0.6)),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                )),
          ),
          _MoreTile(
              iconPath: SvgIcons.discussions,
              text: tr('discussions'),
              onTap: () => Get.find<NavigationController>().changeTabIndex(5)),
          _MoreTile(
              iconPath: SvgIcons.documents,
              text: tr('documents'),
              onTap: () => Get.find<NavigationController>().changeTabIndex(6)),
        ],
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final String iconPath;
  final String text;
  final Function() onTap;

  const _MoreTile({
    Key? key,
    required this.iconPath,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: AppIcon(icon: iconPath),
            ),
            Text(text, style: TextStyleHelper.subtitle1(color: Get.theme.colors().onNavBar)),
          ],
        ),
      ),
    );
  }
}
