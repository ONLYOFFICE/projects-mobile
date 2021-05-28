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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class MoreView extends StatelessWidget {
  const MoreView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userController = Get.find<UserController>();
    var portalInfoController = Get.find<PortalInfoController>();

    userController.getUserInfo();
    portalInfoController.getPortalInfo();

    var imageAdress = _getImageAdress(
      portalAdress: portalInfoController.portalUri,
      imageAdress: userController.user?.avatarMedium,
    );

    return Container(
      height: 312,
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().primarySurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Obx(
            () => GestureDetector(
              onTap: () => Get.find<NavigationController>().changeTabIndex(4),
              child: Container(
                  height: 76,
                  padding: const EdgeInsets.fromLTRB(12, 16, 10, 15),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                    ),
                  ),
                  child: userController.loaded.isTrue &&
                          portalInfoController.loaded.isTrue
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              maxRadius: 20,
                              minRadius: 20,
                              backgroundImage: NetworkImage(
                                imageAdress,
                                headers: portalInfoController.headers,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userController.user?.displayName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyleHelper.subtitle1(
                                        color: Theme.of(context)
                                            .customColors()
                                            .onNavBar),
                                  ),
                                  Text(
                                    portalInfoController.portalName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyleHelper.body2(
                                        color: Theme.of(context)
                                            .customColors()
                                            .onNavBar
                                            .withOpacity(0.6)),
                                  ),
                                  // Text(),
                                ],
                              ),
                            )
                          ],
                        )
                      : const Center(
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator()))),
            ),
          ),
          _MoreTile(
              iconPath: SvgIcons.discussions,
              text: 'Discussions',
              onTap: () => Get.find<NavigationController>().changeTabIndex(5)),
          _MoreTile(
              iconPath: SvgIcons.documents,
              text: 'Documents',
              onTap: () => Get.find<NavigationController>().changeTabIndex(6)),
        ],
      ),
    );
  }
}

// TODO use shared
String _getImageAdress({String portalAdress, String imageAdress}) {
  if (imageAdress.startsWith('http')) return imageAdress;
  return '$portalAdress$imageAdress';
}

class _MoreTile extends StatelessWidget {
  final String iconPath;
  final String text;
  final Function() onTap;

  const _MoreTile({
    Key key,
    @required this.iconPath,
    @required this.onTap,
    @required this.text,
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
            Text(text,
                style: TextStyleHelper.subtitle1(
                    color: Theme.of(context).customColors().onNavBar)),
          ],
        ),
      ),
    );
  }
}
