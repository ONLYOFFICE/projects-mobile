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
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/status_button.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/info_tile.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_smart_refresher.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/views/task_detailed/task_team.dart';
import 'package:readmore/readmore.dart';

part 'task.dart';

class TaskOverviewScreen extends StatelessWidget {
  final TaskItemController? taskController;
  final TabController? tabController;

  const TaskOverviewScreen({
    Key? key,
    required this.taskController,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (taskController!.loaded.value || taskController!.firstReload.value) {
          final task = taskController!.task.value;
          return StyledSmartRefresher(
            controller: taskController!.refreshController,
            onRefresh: () => taskController!.reloadTask(showLoading: true),
            child: ListView(
              children: [
                _Task(taskController: taskController),
                if (task.description != null && task.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 21),
                    child: InfoTile(
                      caption: '${tr('description')}:',
                      icon: AppIcon(
                          icon: SvgIcons.description,
                          color: Get.theme.colors().onBackground.withOpacity(0.75)),
                      subtitleWidget: ReadMoreText(
                        task.description!,
                        trimLines: 3,
                        colorClickableText: Colors.pink,
                        style: TextStyleHelper.body1,
                        trimMode: TrimMode.Line,
                        delimiter: ' ',
                        trimCollapsedText: tr('showMore'),
                        trimExpandedText: tr('showLess'),
                        moreStyle: TextStyleHelper.body2(color: Get.theme.colors().links),
                        lessStyle: TextStyleHelper.body2(color: Get.theme.colors().links),
                      ),
                    ),
                  ),
                InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.project,
                      color: Get.theme.colors().onBackground.withOpacity(0.75)),
                  caption: '${tr('project')}:',
                  subtitle: task.projectOwner!.title,
                  subtitleStyle: TextStyleHelper.subtitle1(
                    color: Get.theme.colors().links,
                  ),
                  onTap: taskController!.toProjectOverview,
                ),
                if (task.milestone != null) const SizedBox(height: 20),
                if (task.milestone != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.milestone,
                          color: Get.theme.colors().onBackground.withOpacity(0.75)),
                      caption: '${tr('milestone')}:',
                      subtitle: task.milestone!.title,
                      subtitleStyle: TextStyleHelper.subtitle1()),
                if (task.startDate != null) const SizedBox(height: 20),
                if (task.startDate != null)
                  InfoTile(
                    icon: AppIcon(
                        icon: SvgIcons.start_date,
                        color: Get.theme.colors().onBackground.withOpacity(0.75)),
                    caption: '${tr('startDate')}:',
                    subtitle: formatedDateFromString(
                      now: DateTime.now(),
                      stringDate: task.startDate!,
                    ),
                  ),
                if (task.deadline != null) const SizedBox(height: 20),
                if (task.deadline != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.due_date,
                          color: Get.theme.colors().onBackground.withOpacity(0.75)),
                      caption: '${tr('dueDate')}:',
                      subtitle:
                          formatedDateFromString(now: DateTime.now(), stringDate: task.deadline!)),
                const SizedBox(height: 20),
                InfoTile(
                    icon: AppIcon(
                        icon: SvgIcons.priority,
                        color: task.priority == 1
                            ? Get.theme.colors().colorError.withOpacity(0.75)
                            : Get.theme.colors().onBackground.withOpacity(0.75)),
                    caption: '${tr('priority')}:',
                    subtitle: task.priority == 1 ? tr('high') : tr('normal')),
                if (task.responsibles != null && task.responsibles!.isNotEmpty)
                  const SizedBox(height: 20),
                if (task.responsibles != null && task.responsibles!.isNotEmpty)
                  InfoTile(
                      onTap: () {
                        Get.find<NavigationController>()
                            .toScreen(TaskTeamView(controller: taskController!));
                      },
                      icon: AppIcon(
                          icon: SvgIcons.person,
                          color: Get.theme.colors().onBackground.withOpacity(0.75)),
                      caption: '${tr('assignedTo')}:',
                      subtitle: task.responsibles!.length >= 2
                          ? plural('responsibles', task.responsibles!.length)
                          : task.responsibles![0]!.displayName,
                      suffix: PlatformIconButton(
                          icon: Icon(PlatformIcons(context).rightChevron,
                              size: 24, color: Get.theme.colors().onBackground.withOpacity(0.6)),
                          onPressed: () {
                            Get.find<NavigationController>()
                                .toScreen(TaskTeamView(controller: taskController!));
                          })),
                const SizedBox(height: 20),
                InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.calendar,
                      color: Get.theme.colors().onBackground.withOpacity(0.75)),
                  caption: '${tr('creationDate')}:',
                  subtitle: formatedDateFromString(
                    now: DateTime.now(),
                    stringDate: task.created!,
                  ),
                ),
                const SizedBox(height: 20),
                InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.person,
                      color: Get.theme.colors().onBackground.withOpacity(0.75)),
                  caption: '${tr('createdBy')}:',
                  subtitle: task.createdBy!.displayName,
                ),
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
