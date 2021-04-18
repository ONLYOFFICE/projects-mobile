import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/task_detailed/comments/task_comments_view.dart';
import 'package:projects/presentation/views/task_detailed/documents/documents_view.dart';
import 'package:projects/presentation/views/task_detailed/overview/overview_screen.dart';
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
    controller.reloadTask();
    _tabController = TabController(
      vsync: this,
      length: 4,
    );
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
              icon: Icon(Icons.edit_outlined),
              onPressed: () => print('da'),
            ),
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
                    _Tab(
                        title: 'Subtasks',
                        currentTab: _activeIndex == 1,
                        count: controller.task.value?.subtasks?.length),
                    _Tab(
                        title: 'Documents',
                        currentTab: _activeIndex == 2,
                        count: controller.task.value?.files?.length),
                    _Tab(
                        title: 'Comments',
                        currentTab: _activeIndex == 3,
                        count: controller.task.value?.comments?.length),
                  ]),
            ),
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          OverviewScreen(taskController: controller),
          SubtasksView(controller: controller),
          DocumentsView(controller: controller),
          TaskCommentsView(controller: controller)
        ]),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String title;
  final int count;
  final bool currentTab;
  const _Tab({
    Key key,
    this.title,
    this.count,
    this.currentTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        if (count != null) const SizedBox(width: 8),
        if (count != null)
          Container(
            constraints: BoxConstraints(minHeight: 25, minWidth: 25),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentTab
                    ? Theme.of(context).customColors().primary
                    : Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.3)),
            child: Center(
                child: Text(count.toString(),
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).customColors().surface,
                        letterSpacing: 0.1))),
          ),
      ],
    );
  }
}
