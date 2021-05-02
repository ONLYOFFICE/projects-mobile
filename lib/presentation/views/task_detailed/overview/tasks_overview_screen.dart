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
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/info_tile.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/task_status_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';

part 'task.dart';

class TasksOverviewScreen extends StatelessWidget {
  final TaskItemController taskController;

  const TasksOverviewScreen({Key key, @required this.taskController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (taskController.loaded.isTrue || taskController.firstReload.isTrue) {
          taskController.firstReload.value = false;
          var task = taskController.task.value;
          return SmartRefresher(
            controller: taskController.refreshController,
            onRefresh: taskController.reloadTask,
            child: ListView(
              children: [
                Task(taskController: taskController),
                if (task.description != null && task.description.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 21),
                      child: InfoTile(
                          caption: 'Description:',
                          icon: AppIcon(
                              icon: SvgIcons.description,
                              color: const Color(0xff707070)),
                          subtitleWidget: ReadMoreText(task.description,
                              trimLines: 3,
                              colorClickableText: Colors.pink,
                              style: TextStyleHelper.body1,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              moreStyle: TextStyleHelper.body2(
                                  color: Theme.of(context)
                                      .customColors()
                                      .links)))),
                InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.project, color: const Color(0xff707070)),
                  caption: 'Project:',
                  subtitle: task.projectOwner.title,
                  subtitleStyle: TextStyleHelper.subtitle1(
                      color: Theme.of(context).customColors().links),
                ),
                if (task.milestone != null) const SizedBox(height: 20),
                if (task.milestone != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.milestone,
                          color: const Color(0xff707070)),
                      caption: 'Milestone:',
                      subtitle: task.milestone.title,
                      subtitleStyle: TextStyleHelper.subtitle1(
                          color: Theme.of(context).customColors().links)),
                if (task.startDate != null) const SizedBox(height: 20),
                if (task.startDate != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.start_date,
                          color: const Color(0xff707070)),
                      caption: 'Start date:',
                      subtitle: task.startDate),
                if (task.deadline != null) const SizedBox(height: 20),
                if (task.deadline != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.due_date,
                          color: const Color(0xff707070)),
                      caption: 'Due date:',
                      subtitle: formatedDateFromString(
                          now: DateTime.now(), stringDate: task.deadline)),
                const SizedBox(height: 20),
                InfoTile(
                    icon: AppIcon(
                        icon: SvgIcons.priority,
                        color: const Color(0xff707070)),
                    caption: 'Priority:',
                    subtitle: task.priority == 1 ? 'High' : 'Normal'),
                if (task.responsibles != null && task.responsibles.isNotEmpty)
                  const SizedBox(height: 20),
                if (task.responsibles != null && task.responsibles.isNotEmpty)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.person,
                          color: const Color(0xff707070)),
                      caption: 'Assigned to:',
                      subtitle: task.responsibles.length >= 2
                          ? '${task.responsibles.length} responsibles'
                          : task.responsibles[0].displayName,
                      suffix: IconButton(
                          icon: Icon(Icons.arrow_forward_ios_rounded,
                              size: 20,
                              color: Theme.of(context)
                                  .customColors()
                                  .onSurface
                                  .withOpacity(0.6)),
                          onPressed: () {})),
                const SizedBox(height: 20),
                InfoTile(
                    caption: 'Created by:',
                    subtitle: task.createdBy.displayName),
                const SizedBox(height: 20),
                InfoTile(
                    caption: 'Creation date:',
                    subtitle: formatedDateFromString(
                        now: DateTime.now(), stringDate: task.created)),
                const SizedBox(height: 110)
              ],
            ),
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}
