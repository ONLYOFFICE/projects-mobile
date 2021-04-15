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

import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';

import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/custom_theme.dart';

class PortalGroupItem extends StatelessWidget {
  const PortalGroupItem({
    Key key,
    @required this.onTapFunction,
    @required this.groupController,
  }) : super(key: key);

  final Function onTapFunction;
  final PortalGroupItemController groupController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        groupController.isSelected.value = !groupController.isSelected.value;
        onTapFunction(groupController);
      },
      child: Container(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Obx(
            // () => groupController.avatarImage.value == null
            // ?
            SizedBox(
              width: 72,
              child: AppIcon(
                  width: 40,
                  height: 40,
                  icon: SvgIcons.users,
                  color: Theme.of(context).customColors().onSurface),
            ),
            //       : SizedBox(
            //           width: 72,
            //           child: SizedBox(
            //             height: 40,
            //             width: 40,
            //             child: CircleAvatar(
            //               radius: 40.0,
            //               backgroundColor: Colors.white,
            //               child: ClipOval(
            //                 child: groupController.avatarImage.value,
            //               ),
            //             ),
            //           ),
            //         ),
            // ),
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
                                groupController.displayName,
                                // .replaceAll(' ', '\u00A0'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyleHelper.subtitle1(),
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
              // if (groupController.multipleSelectionEnabled.isTrue) {
              if (groupController.isSelected.isTrue) {
                return SizedBox(width: 72, child: Icon(Icons.check_box));
              } else {
                return SizedBox(
                    width: 72,
                    child: Icon(Icons.check_box_outline_blank_outlined));
              }
              // } else {
              //   if (groupController.isSelected.isTrue) {
              //     return SizedBox(
              //       width: 72,
              //       child: Icon(
              //         Icons.check,
              //         color: Theme.of(context).customColors().primary,
              //       ),
              //     );
              //   } else {
              //     return SizedBox(width: 72);
              //   }
              // }
            }),
          ],
        ),
      ),
    );
  }
}
