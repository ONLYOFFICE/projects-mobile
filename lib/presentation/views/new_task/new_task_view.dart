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
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';
import 'package:projects/presentation/views/new_task/tiles/description_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/due_date_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/milestone_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/priority_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/project_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/responsible_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/start_date_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/title_tile.dart';

class NewTaskView extends StatelessWidget {
  const NewTaskView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewTaskController>();

    return Scaffold(
      backgroundColor: Theme.of(context).customColors().backgroundColor,
      appBar: StyledAppBar(
        titleText: 'New task',
        actions: [
          IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: () => controller.confirm())
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              const SizedBox(height: 16),
              TitleTile(controller: controller),
              ProjectTile(controller: controller),
              if (controller.projectTileText.value != 'Select project')
                MilestoneTile(controller: controller),
              if (controller.projectTileText.value != 'Select project')
                ResponsibleTile(controller: controller),
              DescriptionTile(controller: controller),
              StartDateTile(controller: controller),
              DueDateTile(controller: controller),
              const SizedBox(height: 5),
              PriorityTile(controller: controller)
            ],
          ),
        ),
      ),
    );
  }
}

class NewTaskInfo extends StatelessWidget {
  final String icon;
  final Function() onTap;
  final String text;
  final TextStyle textStyle;
  final Color textColor;
  final bool enableBorder;
  const NewTaskInfo({
    Key key,
    this.icon,
    this.onTap,
    this.textStyle,
    this.textColor,
    this.enableBorder = true,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 56,
                child: icon != null
                    ? AppIcon(
                        icon: icon,
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.6))
                    : null,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(text,
                      style: textStyle ??
                          TextStyleHelper.subtitle1(
                              color: textColor ??
                                  Theme.of(context)
                                      .customColors()
                                      .onSurface
                                      .withOpacity(0.6))),
                ),
              ),
            ],
          ),
          if (enableBorder) const StyledDivider(leftPadding: 56.5),
        ],
      ),
    );
  }
}
