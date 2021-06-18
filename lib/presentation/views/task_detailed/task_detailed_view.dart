import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_tab.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/documents/entity_documents_view.dart';
import 'package:projects/presentation/views/task_detailed/comments/task_comments_view.dart';
import 'package:projects/presentation/views/task_detailed/overview/tasks_overview_screen.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtasks_view.dart';

part 'app_bar_menu.dart';

class TaskDetailedView extends StatefulWidget {
  TaskDetailedView({Key key}) : super(key: key);

  @override
  _TaskDetailedViewState createState() => _TaskDetailedViewState();
}

class _TaskDetailedViewState extends State<TaskDetailedView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activeIndex = 0;
  TaskItemController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.arguments['controller'];
    controller.firstReload.value = true;
    controller.reloadTask();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _activeIndex = _tabController.index;
        });
      }
    });
    return Obx(
      () => Scaffold(
        appBar: StyledAppBar(
          actions: [
            IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => Get.toNamed('TaskEditingView',
                    arguments: {'task': controller.task.value})),
            _AppBarMenu(controller: controller)
          ],
          bottom: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 40,
              child: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  indicatorColor: Theme.of(context).customColors().primary,
                  labelColor: Theme.of(context).customColors().onSurface,
                  unselectedLabelColor: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.6),
                  labelStyle: TextStyleHelper.subtitle2(),
                  tabs: [
                    const Tab(text: 'Overview'),
                    CustomTab(
                        title: 'Subtasks',
                        currentTab: _activeIndex == 1,
                        count: controller.task.value?.subtasks?.length),
                    CustomTab(
                        title: 'Documents',
                        currentTab: _activeIndex == 2,
                        count: controller.task.value?.files?.length),
                    CustomTab(
                        title: 'Comments',
                        currentTab: _activeIndex == 3,
                        count: controller.task.value?.comments?.length)
                  ]),
            ),
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          TasksOverviewScreen(taskController: controller),
          SubtasksView(controller: controller),
          EntityDocumentsView(
            folderId: controller.task.value.id,
            folderName: controller.task.value.title,
            entityType: 'task',
          ),
          TaskCommentsView(controller: controller)
        ]),
      ),
    );
  }
}
