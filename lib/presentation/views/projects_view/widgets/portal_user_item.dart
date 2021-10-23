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
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/enums/user_status.dart';

import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class PortalUserItem extends StatelessWidget {
  const PortalUserItem({
    Key key,
    @required this.onTapFunction,
    @required this.userController,
  }) : super(key: key);

  final Function onTapFunction;
  final PortalUserItemController userController;

  @override
  Widget build(BuildContext context) {
    var user = userController.portalUser;
    return InkWell(
      onTap: () {
        userController.onTap();
        if (onTapFunction != null) onTapFunction(userController);
      },
      child: Container(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 72,
              child: Container(
                width: 40,
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Opacity(
                      opacity: user.status == UserStatus.Terminated ? 0.4 : 1.0,
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Get.theme.colors().bgDescription,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Obx(() {
                            return userController.avatar.value;
                          }),
                        ),
                      ),
                    ),
                    if (user.status == null ||
                        user.status == UserStatus.Terminated)
                      Positioned(
                          bottom: 0,
                          right: 15,
                          child: AppIcon(
                              icon: SvgIcons.userBlocked,
                              width: 16,
                              height: 16)),
                    if (((user.isAdmin != null && user.isAdmin) ||
                            (user.isAdmin != null && user.isOwner)) &&
                        user.status != UserStatus.Terminated)
                      Positioned(
                          bottom: 0,
                          right: 15,
                          child: AppIcon(
                              icon: SvgIcons.userAdmin, width: 16, height: 16)),
                    if (user.isVisitor != null &&
                        user.isVisitor &&
                        user.status != UserStatus.Terminated)
                      Positioned(
                          bottom: 0,
                          right: 15,
                          child: AppIcon(
                              icon: SvgIcons.userVisitor,
                              width: 16,
                              height: 16)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.displayName.replaceAll(' ', '\u00A0'),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyleHelper.subtitle1(),
                              ),
                              Obx(
                                () => userController.userTitle != null &&
                                        userController.userTitle.isNotEmpty
                                    ? Text(
                                        userController.userTitle
                                            .replaceAll(' ', '\u00A0'),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyleHelper.body2(
                                          color:
                                              Get.theme.colors().onBackground,
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (userController.selectionMode.value ==
                  UserSelectionMode.Multiple) {
                if (userController.isSelected.value == true) {
                  return SizedBox(
                      width: 72,
                      child: Icon(Icons.check_box,
                          color: Get.theme.colors().primary));
                } else {
                  return const SizedBox(
                      width: 72,
                      child: Icon(Icons.check_box_outline_blank_outlined));
                }
              } else {
                if (userController.isSelected.value == true) {
                  return SizedBox(
                    width: 72,
                    child: Icon(
                      Icons.check,
                      color: Get.theme.colors().primary,
                    ),
                  );
                } else {
                  return const SizedBox(width: 72);
                }
              }
            }),
          ],
        ),
      ),
    );
  }
}
