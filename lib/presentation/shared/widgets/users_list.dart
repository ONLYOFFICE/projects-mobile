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
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';

class UsersSimpleList extends StatelessWidget {
  const UsersSimpleList({
    Key? key,
    required this.users,
    required this.onTapFunction,
  }) : super(key: key);
  final Function(PortalUserItemController) onTapFunction;
  final List<PortalUserItemController> users;

  @override
  Widget build(BuildContext context) {
    final platformController = Get.find<PlatformController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListView.separated(
            separatorBuilder: (_, i) => !platformController.isMobile
                ? const StyledDivider(leftPadding: 72)
                : const SizedBox(),
            itemBuilder: (c, i) => PortalUserItem(
              userController: users[i],
              onTapFunction: onTapFunction,
            ),
            itemCount: users.length,
          ),
        ),
      ],
    );
  }
}

class UsersStyledList extends StatelessWidget {
  const UsersStyledList({
    Key? key,
    required this.selfUserItem,
    required this.onTapFunction,
    required this.users,
  }) : super(key: key);
  final Function(PortalUserItemController) onTapFunction;
  final PortalUserItemController selfUserItem;
  final List<PortalUserItemController> users;

  @override
  Widget build(BuildContext context) {
    final platformController = Get.find<PlatformController>();

    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                tr('me'),
                style: TextStyleHelper.body2(
                  color: Theme.of(context).colors().onSurface.withOpacity(0.6),
                ),
              ),
            ),
            PortalUserItem(
              onTapFunction: onTapFunction,
              userController: selfUserItem,
            ),
            const SizedBox(height: 20),
          ],
        ),
        if (users.isNotEmpty)
          Container(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              tr('users'),
              style: TextStyleHelper.body2(
                color: Theme.of(context).colors().onSurface.withOpacity(0.6),
              ),
            ),
          ),
        if (users.isNotEmpty)
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, i) => !platformController.isMobile
                ? const StyledDivider(leftPadding: 72)
                : const SizedBox(),
            shrinkWrap: true,
            itemBuilder: (c, i) =>
                PortalUserItem(userController: users[i], onTapFunction: onTapFunction),
            itemCount: users.length,
          ),
      ],
    );
  }
}
