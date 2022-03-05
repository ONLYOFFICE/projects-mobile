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

import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestone_cell_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/cell_atributed_title.dart';

class MilestoneCell extends StatelessWidget {
  final Milestone? milestone;
  const MilestoneCell({Key? key, this.milestone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemController =
        Get.put(MilestoneCellController(milestone), tag: milestone!.id.toString());

    return InkWell(
      onTap: () => {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 72,
        child: Row(
          children: [
            _MilestoneIcon(itemController: itemController),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _SecondColumn(
                          milestone: milestone,
                          itemController: itemController,
                        ),
                        const SizedBox(width: 8),
                        _ThirdColumn(
                          milestone: milestone,
                          controller: itemController,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _SecondColumn extends StatelessWidget {
  final Milestone? milestone;
  final MilestoneCellController itemController;

  const _SecondColumn({
    Key? key,
    required this.milestone,
    required this.itemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Obx(() {
            TextStyle style;
            if (itemController.milestone.value!.status == 1) {
              style = TextStyleHelper.subtitle1().copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Get.theme.colors().onSurface.withOpacity(0.6));
            } else if (itemController.milestone.value!.status == 2) {
              style = TextStyleHelper.subtitle1()
                  .copyWith(color: Get.theme.colors().onSurface.withOpacity(0.6));
            } else {
              style = TextStyleHelper.subtitle1();
            }
            return CellAtributedTitle(
              text: milestone!.title,
              style: style,
              atributeIcon: const AppIcon(icon: SvgIcons.atribute),
              atributeIconVisible: itemController.milestone.value!.isKey,
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Obx(() {
                final color = itemController.milestone.value!.canEdit!
                    ? Get.theme.colors().primary
                    : Get.theme.colors().onBackground;
                return Text(
                  itemController.statusName,
                  style: TextStyleHelper.status(color: color),
                );
              }),
              Text(' • ',
                  style: TextStyleHelper.caption(
                      color: Get.theme.colors().onSurface.withOpacity(0.6))),
              Flexible(
                child: Text(milestone!.responsible!.displayName!.replaceAll(' ', '\u00A0'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleHelper.caption(
                        color: Get.theme.colors().onSurface.withOpacity(0.6))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThirdColumn extends StatelessWidget {
  final Milestone? milestone;
  final MilestoneCellController controller;

  const _ThirdColumn({
    Key? key,
    required this.milestone,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (milestone!.deadline != null)
          Text(
            formatedDate(milestone!.deadline!),
            style: milestone!.deadline!.isBefore(_now)
                ? TextStyleHelper.caption(color: Get.theme.colors().colorError)
                : TextStyleHelper.caption(color: Get.theme.colors().onSurface),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const AppIcon(
              icon: SvgIcons.check_square,
              color: Color(0xff666666),
              width: 20,
              height: 20,
            ),
            Text(
              milestone!.activeTaskCount.toString(),
              style: TextStyleHelper.body2(
                color: Get.theme.colors().onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MilestoneIcon extends StatelessWidget {
  const _MilestoneIcon({
    Key? key,
    required this.itemController,
  }) : super(key: key);

  final MilestoneCellController itemController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          final color = itemController.milestone.value!.canEdit!
              ? Get.theme.colors().primary
              : Get.theme.colors().onBackground;
          return SizedBox(
            width: 72,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 10,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Get.theme.colors().primary.withOpacity(0.1),
                      ),
                      color: Get.theme.colors().background,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: AppIcon(
                        icon: SvgIcons.milestone,
                        color: Get.theme.colors().onBackground.withOpacity(0.6),
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ),
                AppIcon(icon: itemController.statusImage, color: color),
              ],
            ),
          );
        }),
      ],
    );
  }
}
