import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
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
import 'package:projects/presentation/views/tasks/task_cell.dart';
import 'package:projects/presentation/views/tasks/tasks_filter.dart/tasks_filter.dart';

class TasksView extends StatelessWidget {
  const TasksView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<TasksController>();
    controller.loadTasks(preset: PresetTaskFilters.saved);

    var scrollController = ScrollController();
    var elevation = ValueNotifier<double>(0);

    scrollController.addListener(
        () => elevation.value = scrollController.offset > 2 ? 1 : 0);

    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      floatingActionButton: Obx(() => AnimatedPadding(
          padding: EdgeInsets.only(
              bottom: controller.fabIsRaised.value == true ? 48 : 0),
          duration: const Duration(milliseconds: 100),
          child: StyledFloatingActionButton(
              onPressed: () => Get.find<NavigationController>().to(
                  const NewTaskView(),
                  arguments: {'projectDetailed': null}),
              child: AppIcon(icon: SvgIcons.add_fab)))),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 101),
        child: ValueListenableBuilder(
          valueListenable: elevation,
          builder: (_, value, __) => StyledAppBar(
            showBackButton: false,
            titleText: tr('tasks'),
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
            bottom: TasksHeader(),
          ),
        ),
      ),
      body: Obx(
        () {
          if (controller.loaded.value == false)
            return const ListLoadingSkeleton();
          if (controller.loaded.value == true &&
              controller.paginationController.data.isEmpty &&
              !controller.filterController.hasFilters.value) {
            return Center(
                child: EmptyScreen(
                    icon: AppIcon(icon: SvgIcons.task_not_created),
                    text: tr('noTasksCreated',
                        args: [tr('tasks').toLowerCase()])));
          }
          if (controller.loaded.value == true &&
              controller.paginationController.data.isEmpty &&
              controller.filterController.hasFilters.value) {
            return Center(
              child: EmptyScreen(
                  icon: AppIcon(icon: SvgIcons.not_found),
                  text:
                      tr('noTasksMatching', args: [tr('tasks').toLowerCase()])),
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
                onPressed: () => Get.bottomSheet(
                  SortView(sortOptions: options),
                  isScrollControlled: true,
                ),
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
                              color: Theme.of(context).colors().primary,
                            )
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationX(math.pi),
                              child: AppIcon(
                                icon: SvgIcons.sorting_4_ascend,
                                width: 20,
                                height: 20,
                                color: Theme.of(context).colors().primary,
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
