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
import 'package:projects/data/models/from_api/portal_task.dart';

import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/task_status_bottom_sheet.dart'
    as bottom_sheet;

class TaskCell extends StatelessWidget {
  final PortalTask task;
  const TaskCell({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: omit_local_variable_types
    TaskItemController itemController =
        Get.put(TaskItemController(task), tag: task.id.toString());

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () async {
                bottom_sheet.showsStatusesBS(
                    context: context, taskItemController: itemController);
              },
              child: TaskStatus(itemController: itemController)),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () => Get.toNamed('TaskDetailedView',
                  arguments: {'controller': itemController}),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SecondColumn(
                          task: task,
                          itemController: itemController,
                        ),
                        const SizedBox(width: 8),
                        ThirdColumn(
                          task: task,
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

// refactor
class TaskStatus extends StatelessWidget {
  final TaskItemController itemController;

  const TaskStatus({
    Key key,
    @required this.itemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DecoratedBox(
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Color(0xffD8D8D8)),
        child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(0.5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).customColors().background),
            child: Center(
              child: SVG.createSizedFromString(
                  itemController.statusImageString.value,
                  16,
                  16,
                  itemController.status.value.color),
            )),
      ),
    );
  }
}

// refactor
class SecondColumn extends StatelessWidget {
  final PortalTask task;
  final TaskItemController itemController;

  const SecondColumn({
    Key key,
    @required this.task,
    @required this.itemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Wrap(
                children: [
                  Text(
                    task.title,
                    maxLines: 2,
                    softWrap: true,
                    style: TextStyleHelper.projectTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (task.priority == 1) const SizedBox(width: 6),
                  if (task.priority == 1) AppIcon(icon: SvgIcons.high_priority)
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      itemController.status.value.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleHelper.status(
                          color: itemController.status.value.color.toColor()),
                    ),
                  ),
                  Text(' • ',
                      style: TextStyleHelper.caption(
                          color: Theme.of(context)
                              .customColors()
                              .onSurface
                              .withOpacity(0.6))),
                  Flexible(
                    child: Text(task.createdBy.displayName,
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
      },
    );
  }
}

class ThirdColumn extends StatelessWidget {
  final PortalTask task;
  final TaskItemController controller;

  const ThirdColumn({
    Key key,
    @required this.task,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _now = DateTime.now();

    DateTime _deadline;
    if (task.deadline != null) _deadline = DateTime.parse(task.deadline);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_deadline != null)
          Text(formatedDate(now: _now, stringDate: task.deadline),
              style: _deadline.isBefore(_now)
                  ? TextStyleHelper.caption(
                      color: Theme.of(context).customColors().error)
                  : TextStyleHelper.caption(
                      color: Theme.of(context).customColors().onSurface)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppIcon(icon: SvgIcons.subtasks, color: const Color(0xff666666)),
            const SizedBox(width: 5),
            Text(task.subtasks.length.toString(),
                style: TextStyleHelper.body2(
                    color: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.6))),
          ],
        ),
      ],
    );
  }
}
