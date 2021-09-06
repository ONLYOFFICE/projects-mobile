import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';
import 'package:projects/presentation/views/tasks/task_cell.dart';
import 'package:projects/presentation/views/tasks/tasks_view.dart';

class TasksDashboardMoreView extends StatelessWidget {
  const TasksDashboardMoreView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.arguments['controller'];

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
            showBackButton: true,
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
              const SizedBox(width: 4),
            ],
            bottom: TasksHeader(controller: controller),
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
