import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_tab.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/documents/entity_documents_view.dart';
import 'package:projects/presentation/views/task_detailed/comments/task_comments_view.dart';
import 'package:projects/presentation/views/task_detailed/overview/tasks_overview_screen.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtasks_view.dart';
import 'package:projects/presentation/views/task_editing_view/task_editing_view.dart';

part 'app_bar_menu.dart';

class TaskDetailedView extends StatefulWidget {
  TaskDetailedView({Key key}) : super(key: key);

  @override
  _TaskDetailedViewState createState() => _TaskDetailedViewState();
}

class _TaskDetailedViewState extends State<TaskDetailedView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  // ignore: prefer_final_fields
  var _activeIndex = 0.obs;
  TaskItemController controller;
  final documentsController = Get.find<DocumentsController>();

  @override
  void initState() {
    super.initState();
    controller = Get.arguments['controller'];
    controller.firstReload.value = true;
    // to get full info about task
    controller.reloadTask().then((value) => controller.setLoaded = true);
    _tabController = TabController(vsync: this, length: 4);

    documentsController.entityType = 'task';
    documentsController.setupFolder(
        folderId: controller.task.value.id,
        folderName: controller.task.value.title);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.addListener(() {
      if (_activeIndex.value == _tabController.index) return;

      _activeIndex.value = _tabController.index;
    });
    return Obx(
      () => Scaffold(
        appBar: StyledAppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Get.find<NavigationController>()
                  .to(TaskEditingView(task: controller.task.value)),
            ),
            _AppBarMenu(controller: controller)
          ],
          bottom: SizedBox(
            height: 40,
            child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicatorColor: Get.theme.colors().primary,
                labelColor: Get.theme.colors().onSurface,
                unselectedLabelColor:
                    Get.theme.colors().onSurface.withOpacity(0.6),
                labelStyle: TextStyleHelper.subtitle2(),
                tabs: [
                  Tab(text: tr('overview')),
                  CustomTab(
                      title: tr('subtasks'),
                      currentTab: _activeIndex.value == 1,
                      count: controller.task.value?.subtasks?.length),
                  CustomTab(
                      title: tr('documents'),
                      currentTab: _activeIndex.value == 2,
                      count: controller.task.value?.files?.length),
                  CustomTab(
                      title: tr('comments'),
                      currentTab: _activeIndex.value == 3,
                      count: controller.getActualCommentCount)
                ]),
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          TasksOverviewScreen(taskController: controller),
          SubtasksView(controller: controller),
          EntityDocumentsView(
            folderId: controller.task.value.id,
            folderName: controller.task.value.title,
            documentsController: documentsController,
          ),
          TaskCommentsView(controller: controller)
        ]),
      ),
    );
  }
}
