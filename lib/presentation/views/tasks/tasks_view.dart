import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/tasks/task_cell.dart';

class TasksView extends StatelessWidget {
  const TasksView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<TasksController>();
    controller.loadTasks();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: Obx(() => AnimatedPadding(
          padding:
              EdgeInsets.only(bottom: controller.fabIsRaised.isTrue ? 48 : 0),
          duration: const Duration(milliseconds: 100),
          child: StyledFloatingActionButton(
              onPressed: () => Get.toNamed('NewTaskView',
                  arguments: {'projectDetailed': null}),
              child: const Icon(Icons.add_rounded)))),
      appBar: StyledAppBar(
        titleHeight: 101,
        bottomHeight: 0,
        showBackButton: false,
        titleText: tr('tasks'),
        elevation: 0,
        actions: [
          IconButton(
            icon: AppIcon(
              width: 24,
              height: 24,
              icon: SvgIcons.search,
              color: Theme.of(context).customColors().primary,
            ),
            onPressed: () => controller.showSearch(),
          ),
          IconButton(
            icon: FiltersButton(controler: controller),
            onPressed: () async => Get.toNamed('TasksFilterScreen',
                preventDuplicates: false,
                arguments: {'filterController': controller.filterController}),
          ),
          const SizedBox(width: 4),
        ],
        bottom: TasksHeader(),
      ),
      body: Obx(
        () => Column(children: [
          if (controller.needToShowDevider.value == true)
            const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
          if (controller.loaded.isFalse) const ListLoadingSkeleton(),
          if (controller.loaded.isTrue &&
              controller.paginationController.data.isEmpty &&
              !controller.filterController.hasFilters.value)
            Expanded(
              child: Center(
                child: EmptyScreen(
                    icon: AppIcon(icon: SvgIcons.task_not_created),
                    text: tr('noEntityCreated',
                        args: [tr('tasks').toLowerCase()])),
              ),
            ),
          if (controller.loaded.isTrue &&
              controller.paginationController.data.isEmpty &&
              controller.filterController.hasFilters.value)
            Expanded(
              child: Center(
                child: EmptyScreen(
                    icon: AppIcon(icon: SvgIcons.not_found),
                    text: tr('noEntityMatching',
                        args: [tr('tasks').toLowerCase()])),
              ),
            ),
          if (controller.loaded.isTrue &&
              controller.paginationController.data.isNotEmpty)
            Expanded(
              child: PaginationListView(
                paginationController: controller.paginationController,
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.paginationController.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TaskCell(
                        task: controller.paginationController.data[index]);
                  },
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

class TasksHeader extends StatelessWidget {
  TasksHeader({
    Key key,
  }) : super(key: key);

  final controller = Get.find<TasksController>();

  @override
  Widget build(BuildContext context) {
    var options = Column(
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
                onPressed: () => Get.bottomSheet(SortView(sortOptions: options),
                    isScrollControlled: true),
                child: Row(
                  children: [
                    Obx(
                      () => Text(
                        controller.sortController.currentSortTitle.value,
                        style: TextStyleHelper.projectsSorting,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => (controller.sortController.currentSortOrder ==
                              'ascending')
                          ? AppIcon(
                              icon: SvgIcons.sorting_4_ascend,
                              width: 20,
                              height: 20,
                            )
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationX(math.pi),
                              child: AppIcon(
                                icon: SvgIcons.sorting_4_ascend,
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
                  color: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
