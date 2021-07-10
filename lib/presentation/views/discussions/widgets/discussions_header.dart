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

import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';

class DiscussionsHeader extends StatelessWidget {
  DiscussionsHeader({
    Key key,
  }) : super(key: key);

  final controller = Get.find<DiscussionsController>();

  @override
  Widget build(BuildContext context) {
    var options = Column(
      children: [
        const SizedBox(height: 14.5),
        const Divider(height: 9, thickness: 1),
        SortTile(
            sortParameter: 'create_on',
            sortController: controller.sortController),
        SortTile(
            sortParameter: 'title', sortController: controller.sortController),
        SortTile(
            sortParameter: 'comments',
            sortController: controller.sortController),
        const SizedBox(height: 20)
      ],
    );
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 4),
              child: TextButton(
                onPressed: () => Get.bottomSheet(
                  SortView(sortOptions: options),
                  isScrollControlled: true,
                ),
                child: Row(
                  children: [
                    Obx(
                      () => Text(
                        controller.sortController.currentSortTitle.value,
                        style: TextStyleHelper.projectsSorting,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => (controller.sortController.currentSortOrder ==
                              'ascending')
                          ? AppIcon(
                              icon: SvgIcons.sorting_4_ascend,
                              width: 20,
                              height: 20,
                            )
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationX(math.pi),
                              child: AppIcon(
                                icon: SvgIcons.sorting_4_ascend,
                                width: 20,
                                height: 20,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Text(
                tr('total', args: [
                  controller.paginationController.total.value.toString()
                ]),
                style: TextStyleHelper.body2(
                  color: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}