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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';
import 'package:projects/presentation/views/tasks/task_cell/task_cell.dart';
import 'package:projects/presentation/views/tasks/tasks_filter.dart/tasks_filter.dart';

class TasksView extends StatelessWidget {
  const TasksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<TasksController>(tag: 'TasksView')
        ? Get.find<TasksController>(tag: 'TasksView')
        : Get.put(
            TasksController(
              Get.find<TaskFilterController>(),
              Get.find<PaginationController<PortalTask>>(),
            ),
            tag: 'TasksView');

    controller.setup(PresetTaskFilters.saved);

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      controller.loadTasks();
    });

    final scrollController = ScrollController();
    final elevation = ValueNotifier<double>(0);

    scrollController.addListener(
        () => elevation.value = scrollController.offset > 2 ? 1 : 0);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Get.theme.backgroundColor,
      floatingActionButton: Obx(
        () => Visibility(
          visible: controller.fabIsVisible.value,
          child: StyledFloatingActionButton(
            onPressed: () => Get.find<NavigationController>()
                .to(const NewTaskView(), arguments: {'projectDetailed': null}),
            child: AppIcon(
              icon: SvgIcons.add_fab,
              color: Get.theme.colors().onPrimarySurface,
            ),
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 101),
        child: ValueListenableBuilder(
          valueListenable: elevation,
          builder: (_, double value, __) => StyledAppBar(
            showBackButton: false,
            titleText: controller.screenName,
            elevation: value,
            actions: [
              IconButton(
                icon: AppIcon(
                  width: 24,
                  height: 24,
                  icon: SvgIcons.search,
                  color: Get.theme.colors().primary,
                ),
                onPressed: controller.showSearch,
              ),
              IconButton(
                icon: FiltersButton(controler: controller),
                onPressed: () async => Get.find<NavigationController>()
                    .toScreen(const TasksFilterScreen(),
                        preventDuplicates: false,
                        arguments: {
                      'filterController': controller.filterController
                    }),
              ),
              const SizedBox(width: 4),
            ],
            bottom: TasksHeader(controller: controller),
          ),
        ),
      ),
      body: Obx(
        () {
          if (!controller.loaded.value || !controller.taskStatusesLoaded.value)
            return const ListLoadingSkeleton();
          if (controller.loaded.value &&
              controller.taskStatusesLoaded.value &&
              controller.paginationController.data.isEmpty &&
              !controller.filterController.hasFilters.value) {
            return Center(
                child: EmptyScreen(
                    icon: SvgIcons.task_not_created,
                    text: tr('noTasksCreated')));
          }
          if (controller.loaded.value &&
              controller.taskStatusesLoaded.value &&
              controller.paginationController.data.isEmpty &&
              controller.filterController.hasFilters.value) {
            return Center(
              child: EmptyScreen(
                  icon: SvgIcons.not_found, text: tr('noTasksMatching')),
            );
          }
          return PaginationListView(
            paginationController: controller.paginationController,
            child: ListView.builder(
              // controller: controller.scrollController,
              controller: scrollController,
              itemCount: controller.paginationController.data.length,
              itemBuilder: (BuildContext context, int index) {
                return TaskCell(
                    task: controller.paginationController.data[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class TasksHeader extends StatelessWidget {
  const TasksHeader({Key? key, required this.controller}) : super(key: key);

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    final options = Column(
      children: [
        const SizedBox(height: 14.5),
        const Divider(height: 9, thickness: 1),
        SortTile(
            sortParameter: 'deadline',
            sortController: controller.sortController),
        SortTile(
            sortParameter: 'priority',
            sortController: controller.sortController),
        SortTile(
            sortParameter: 'create_on',
            sortController: controller.sortController),
        SortTile(
            sortParameter: 'start_date',
            sortController: controller.sortController),
        SortTile(
            sortParameter: 'title', sortController: controller.sortController),
        SortTile(
            sortParameter: 'sort_order',
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
                        style: TextStyleHelper.projectsSorting
                            .copyWith(color: Get.theme.colors().primary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => (controller.sortController.currentSortOrder ==
                              'ascending')
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
                ),
              ),
            ),
            Obx(
              () => Text(
                tr('total', args: [
                  controller.paginationController.total.value.toString()
                ]),
                style: TextStyleHelper.body2(
                  color: Get.theme.colors().onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
