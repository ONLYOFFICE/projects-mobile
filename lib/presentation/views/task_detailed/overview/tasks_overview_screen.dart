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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
import 'package:projects/presentation/views/task_detailed/task_team.dart';
import 'package:readmore/readmore.dart';

part 'task.dart';

class TaskOverviewScreen extends StatelessWidget {
  final TaskItemController taskController;
  final TabController tabController;

  const TaskOverviewScreen({
    Key? key,
    required this.taskController,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (taskController.loaded.value || taskController.firstReload.value) {
          final scrollController = ScrollController();
          final task = taskController.task.value;
          return StyledSmartRefresher(
            scrollController: scrollController,
            controller: taskController.refreshController,
            onRefresh: () => taskController.reloadTask(showLoading: true),
            child: ListView(
              controller: scrollController,
              children: [
                _Task(taskController: taskController),
                InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.project,
                      color: Theme.of(context).colors().onBackground.withOpacity(0.75)),
                  caption: '${tr('project')}:',
                  captionStyle: TextStyleHelper.caption(
                      color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                  subtitle: task.projectOwner!.title,
                  subtitleStyle: TextStyleHelper.subtitle1(
                    color: Theme.of(context).colors().links,
                  ),
                  onTap: taskController.toProjectOverview,
                ),
                if (task.description != null && task.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 21),
                    child: InfoTile(
                      caption: '${tr('description')}:',
                      captionStyle: TextStyleHelper.caption(
                          color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                      icon: AppIcon(
                          icon: SvgIcons.description,
                          color: Theme.of(context).colors().onBackground.withOpacity(0.75)),
                      subtitleWidget: ReadMoreText(
                        task.description!,
                        trimLines: 3,
                        colorClickableText: Colors.pink,
                        style: TextStyleHelper.body1(),
                        trimMode: TrimMode.Line,
                        delimiter: '\n',
                        trimCollapsedText: tr('showMore'),
                        trimExpandedText: tr('showLess'),
                        moreStyle: TextStyleHelper.body2(color: Theme.of(context).colors().links),
                        lessStyle: TextStyleHelper.body2(color: Theme.of(context).colors().links),
                      ),
                    ),
                  ),
                if (task.milestone != null) const SizedBox(height: 20),
                if (task.milestone != null)
                  InfoTile(
                      icon: AppIcon(
                          icon: SvgIcons.milestone,
                          color: Theme.of(context).colors().onBackground.withOpacity(0.75)),
                      caption: '${tr('milestone')}:',
                      captionStyle: TextStyleHelper.caption(
                          color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                      subtitle: task.milestone!.title,
                      subtitleStyle: TextStyleHelper.subtitle1()),
                if (task.startDate != null) const SizedBox(height: 20),
                if (task.startDate != null)
                  InfoTile(
                    icon: AppIcon(
                        icon: SvgIcons.start_date,
                        color: Theme.of(context).colors().onBackground.withOpacity(0.75)),
                    caption: '${tr('startDate')}:',
                    captionStyle: TextStyleHelper.caption(
                        color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
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
                          color: Theme.of(context).colors().onBackground.withOpacity(0.75)),
                      caption: '${tr('dueDate')}:',
                      captionStyle: TextStyleHelper.caption(
                          color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                      subtitle:
                          formatedDateFromString(now: DateTime.now(), stringDate: task.deadline!),
                      subtitleStyle: DateTime.parse(task.deadline!).isBefore(DateTime.now())
                          ? TextStyleHelper.subtitle1(color: Theme.of(context).colors().colorError)
                          : TextStyleHelper.subtitle1(color: Theme.of(context).colors().onSurface)),
                const SizedBox(height: 20),
                InfoTile(
                    icon: AppIcon(
                        icon: SvgIcons.priority,
                        color: task.priority == 1
                            ? Theme.of(context).colors().colorError.withOpacity(0.75)
                            : Theme.of(context).colors().onBackground.withOpacity(0.75)),
                    caption: '${tr('priority')}:',
                    captionStyle: TextStyleHelper.caption(
                        color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                    subtitle: task.priority == 1 ? tr('high') : tr('normal')),
                if (task.responsibles != null && task.responsibles!.isNotEmpty)
                  const SizedBox(height: 20),
                if (task.responsibles != null && task.responsibles!.isNotEmpty)
                  InfoTile(
                      onTap: () {
                        Get.find<NavigationController>().toScreen(
                          const TaskTeamView(),
                          page: '/TaskTeamView',
                          arguments: {
                            'controller': taskController,
                          },
                        );
                      },
                      icon: AppIcon(
                          icon: SvgIcons.person,
                          color: Theme.of(context).colors().onBackground.withOpacity(0.75)),
                      caption: '${tr('assignedTo')}:',
                      captionStyle: TextStyleHelper.caption(
                          color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                      subtitle: task.responsibles!.length >= 2
                          ? plural('responsibles', task.responsibles!.length)
                          : task.responsibles![0]!.displayName,
                      suffix: PlatformIconButton(
                          icon: Icon(PlatformIcons(context).rightChevron,
                              size: 24,
                              color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                          onPressed: () {
                            Get.find<NavigationController>().toScreen(
                              const TaskTeamView(),
                              page: '/TaskTeamView',
                              arguments: {
                                'controller': taskController,
                              },
                            );
                          })),
                const SizedBox(height: 20),
                InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.calendar,
                      color: Theme.of(context).colors().onBackground.withOpacity(0.75)),
                  caption: '${tr('creationDate')}:',
                  captionStyle: TextStyleHelper.caption(
                      color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
                  subtitle: formatedDateFromString(
                    now: DateTime.now(),
                    stringDate: task.created!,
                  ),
                ),
                const SizedBox(height: 20),
                InfoTile(
                  icon: AppIcon(
                      icon: SvgIcons.person,
                      color: Theme.of(context).colors().onBackground.withOpacity(0.75)),
                  caption: '${tr('createdBy')}:',
                  captionStyle: TextStyleHelper.caption(
                      color: Theme.of(context).colors().onBackground.withOpacity(0.6)),
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
