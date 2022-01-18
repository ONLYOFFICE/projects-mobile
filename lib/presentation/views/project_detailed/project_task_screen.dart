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
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_tasks_controller.dart';
import 'package:projects/domain/controllers/tasks/task_statuses_controller.dart';
import 'package:projects/presentation/shared/mixins/show_popup_menu_mixin.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';
import 'package:projects/presentation/views/tasks/task_cell/task_cell.dart';
import 'package:projects/presentation/views/tasks/tasks_filter.dart/tasks_filter.dart';

class ProjectTaskScreen extends StatelessWidget {
  final ProjectTasksController projectTasksController;

  const ProjectTaskScreen({Key? key, required this.projectTasksController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<TaskStatusesController>().getStatuses();

    return Stack(
      children: [
        _Content(controller: projectTasksController),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 24),
            child: Obx(
              () => Visibility(
                visible: projectTasksController.fabIsVisible.value,
                child: StyledFloatingActionButton(
                  onPressed: () => Get.find<NavigationController>().to(const NewTaskView(),
                      arguments: {'projectDetailed': projectTasksController.projectDetailed}),
                  child: AppIcon(
                    icon: SvgIcons.add_fab,
                    color: Get.theme.colors().onPrimarySurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ProjectTasksController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (() {
            if (!controller.loaded.value) return const ListLoadingSkeleton();

            return Expanded(
              child: PaginationListView(
                paginationController: controller.paginationController,
                child: () {
                  if (controller.loaded.value &&
                      controller.tasksList.isEmpty &&
                      !controller.filterController.hasFilters.value)
                    return Center(
                      child: EmptyScreen(
                        icon: SvgIcons.task_not_created,
                        text: tr('noTasksCreated'),
                      ),
                    );
                  if (controller.loaded.value &&
                      controller.tasksList.isEmpty &&
                      controller.filterController.hasFilters.value)
                    return Center(
                      child: EmptyScreen(icon: SvgIcons.not_found, text: tr('noTasksMatching')),
                    );
                  if (controller.loaded.value && controller.tasksList.isNotEmpty)
                    return ListView.builder(
                      itemBuilder: (c, i) => TaskCell(task: controller.tasksList[i]),
                      itemExtent: 72,
                      itemCount: controller.tasksList.length,
                    );
                }() as Widget,
              ),
            );
          }()),
        ],
      ),
    );
  }
}

class ProjectTasksFilterButton extends StatelessWidget {
  const ProjectTasksFilterButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ProjectTasksController controller;

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      icon: FiltersButton(controller: controller),
      onPressed: () async => Get.find<NavigationController>().toScreen(
        const TasksFilterScreen(),
        preventDuplicates: false,
        arguments: {'filterController': controller.filterController},
      ),
    );
  }
}

class ProjectTasksSortButton extends StatelessWidget {
  const ProjectTasksSortButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ProjectTasksController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Obx(
          () => Text(
            controller.sortController.currentSortTitle.value,
            style: TextStyleHelper.projectsSorting.copyWith(color: Get.theme.colors().primary),
          ),
        ),
        const SizedBox(width: 8),
        Obx(
          () => (controller.sortController.currentSortOrder == 'ascending')
              ? AppIcon(
                  icon: SvgIcons.sorting_4_ascend,
                  color: Get.theme.colors().primary,
                  width: 20,
                  height: 20,
                )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationX(math.pi),
                  child: AppIcon(
                    icon: SvgIcons.sorting_4_ascend,
                    color: Get.theme.colors().primary,
                    width: 20,
                    height: 20,
                  ),
                ),
        ),
      ],
    );
  }
}

void taskSortButtonOnPressed(ProjectTasksController controller, BuildContext context) async {
  List<SortTile> _getSortTile() {
    return [
      SortTile(sortParameter: 'deadline', sortController: controller.sortController),
      SortTile(sortParameter: 'priority', sortController: controller.sortController),
      SortTile(sortParameter: 'create_on', sortController: controller.sortController),
      SortTile(sortParameter: 'start_date', sortController: controller.sortController),
      SortTile(sortParameter: 'title', sortController: controller.sortController),
      SortTile(sortParameter: 'sort_order', sortController: controller.sortController),
    ];
  }

  if (Get.find<PlatformController>().isMobile) {
    final options = Column(
      children: [
        const SizedBox(height: 14.5),
        const Divider(height: 9, thickness: 1),
        ..._getSortTile(),
        const SizedBox(height: 20)
      ],
    );
    await Get.bottomSheet(SortView(sortOptions: options), isScrollControlled: true);
  } else {
    await showPopupMenu(
      context: context,
      options: _getSortTile(),
      offset: const Offset(0, 30),
    );
  }
}
