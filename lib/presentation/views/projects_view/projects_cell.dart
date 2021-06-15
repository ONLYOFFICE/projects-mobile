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

import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/projects/project_cell_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/cell_atributed_title.dart';

class ProjectCell extends StatelessWidget {
  final ProjectDetailed item;
  const ProjectCell({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var itemController =
        Get.put(ProjectCellController(item), tag: item.id.toString());

    return Container(
      height: 72,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProjectIcon(
            itemController: itemController,
          ),
          Expanded(
            child: InkResponse(
              onTap: () => Get.toNamed('ProjectDetailedView',
                  arguments: {'projectDetailed': itemController.projectData}),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _SecondColumn(
                          item: item,
                          itemController: itemController,
                        ),
                        const SizedBox(width: 8),
                        _ThirdColumn(
                          item: item,
                          controller: itemController,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectIcon extends StatelessWidget {
  const ProjectIcon({
    Key key,
    @required this.itemController,
  }) : super(key: key);

  final ProjectCellController itemController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Obx(() {
          var color = itemController.canEdit.isTrue
              ? Theme.of(context).customColors().primary
              : Theme.of(context).customColors().onBackground;
          return Container(
            width: 48,
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
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context)
                            .customColors()
                            .primary
                            .withOpacity(0.1),
                      ),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: AppIcon(
                        icon: SvgIcons.project_icon,
                        color: const Color(0xff666666),
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ),
                ),
                AppIcon(icon: itemController.statusImage, color: color),
              ],
            ),
          );
        }),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _SecondColumn extends StatelessWidget {
  final ProjectDetailed item;
  final ProjectCellController itemController;

  const _SecondColumn({
    Key key,
    @required this.item,
    @required this.itemController,
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
          Obx(
            () {
              var style;
              if (itemController.status.value == 1) {
                style = TextStyleHelper.projectTitle.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.6));
              } else if (itemController.status.value == 2) {
                style = TextStyleHelper.projectTitle.copyWith(
                    color: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.6));
              } else {
                style = TextStyleHelper.projectTitle;
              }
              return CellAtributedTitle(
                text: item.title,
                style: style,
                atributeIcon: AppIcon(icon: SvgIcons.lock),
                atributeIconVisible: itemController.isPrivate.isTrue,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Obx(() {
                var color = itemController.canEdit.isTrue
                    ? Theme.of(context).customColors().primary
                    : Theme.of(context).customColors().onBackground;
                return Text(
                  itemController.statusName,
                  style: TextStyleHelper.status(color: color),
                );
              }),
              Text(' • ',
                  style: TextStyleHelper.caption(
                      color: Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.6))),
              Flexible(
                child: Text(
                    item.responsible.displayName.replaceAll(' ', '\u00A0'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleHelper.caption(
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.6))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThirdColumn extends StatelessWidget {
  const _ThirdColumn({
    Key key,
    @required this.item,
    @required this.controller,
  }) : super(key: key);

  final ProjectDetailed item;
  final ProjectCellController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            AppIcon(
                icon: SvgIcons.check_square, color: const Color(0xff666666)),
            Text(
              item.taskCount.toString(),
              style: TextStyleHelper.projectCompleatedTasks,
            ),
            const SizedBox(
              width: 16,
            )
          ],
        ),
      ],
    );
  }
}
