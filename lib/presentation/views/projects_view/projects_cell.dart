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

import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/data/models/item.dart';
import 'package:projects/domain/controllers/projects/project_cell_controller.dart';

import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:projects/presentation/shared/custom_theme.dart';

class ProjectCell extends StatelessWidget {
  final Item item;
  const ProjectCell({this.item});

  @override
  Widget build(BuildContext context) {
    var itemController =
        Get.put(ProjectCellController(item), tag: item.id.toString());

    return VisibilityDetector(
      key: Key('${item.id.toString()}_${item.title}'),
      onVisibilityChanged: itemController.handleVisibilityChanged,
      child: Container(
        child: GestureDetector(
          onTap: () => Get.toNamed('ProjectDetailedView',
              arguments: {'controller': itemController}),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProjectIcon(
                itemController: itemController,
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SecondColumn(
                            item: item,
                            itemController: itemController,
                          ),
                          const SizedBox(width: 16),
                          ThirdColumn(
                            item: item,
                            controller: itemController,
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
        Container(
          width: 48,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).customColors().primary.withOpacity(0.1),
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
                    padding: EdgeInsets.all(4),
                    child: AppIcon(
                      icon: SvgIcons.project_icon,
                      color: const Color(0xff666666),
                      width: 12,
                      height: 12,
                    ),
                  ),
                ),
              ),
              AppIcon(
                  icon: itemController.statusImage,
                  color: const Color(0xff666666)),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class SecondColumn extends StatelessWidget {
  const SecondColumn({
    Key key,
    @required this.item,
    @required this.itemController,
  }) : super(key: key);

  final Item item;
  final ProjectCellController itemController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: DropCapText(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.projectTitle,
                  dropCapPadding: EdgeInsets.only(top: 4),
                  dropCap: DropCap(
                    width: 12,
                    height: 12,
                    child: AppIcon(icon: SvgIcons.lock),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Text(
                itemController.statusName,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  '•',
                  style: TextStyleHelper.projectResponsible,
                ),
              ),
              Flexible(
                child: Text(
                  item.responsible.displayName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.projectResponsible,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ThirdColumn extends StatelessWidget {
  const ThirdColumn({
    Key key,
    @required this.item,
    @required this.controller,
  }) : super(key: key);

  final Item item;
  final ProjectCellController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SVG.createSized(
                  'lib/assets/images/icons/check_square.svg', 20, 20),
              Text(
                item.subCount.toString(),
                style: TextStyleHelper.projectCompleatedTasks,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
