import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';

import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';
import 'package:projects/presentation/views/tasks/task_cell.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: StyledAppBar(
        bottom: const DashboardHeader(),
        titleHeight: 0,
        bottomHeight: 100,
        showBackButton: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        children: <Widget>[
          MyTasksContent(
            title: 'My Tasks',
            overline: 'Tasks',
          ),
          UpcommingContent(
            title: 'Upcoming',
            overline: 'Tasks',
          ),
          MyProjectsContent(
            title: 'My Projects',
            overline: 'Projects',
          ),
          MyFollowedProjectsContent(
            title: 'Projects I Folow',
            overline: 'Projects',
          ),
          ActiveProjectsContent(
            title: 'Active Projects',
            overline: 'Projects',
          ),
        ],
      ),
    );
  }
}

class DashboardCardView extends StatelessWidget {
  final Widget content;
  final String overline;
  final String title;
  final controller;

  DashboardCardView({
    Key key,
    this.title,
    this.overline,
    this.content = const SizedBox(),
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        overline.toUpperCase(),
                        style: TextStyleHelper.overline,
                      ),
                      Text(
                        title,
                        style: TextStyleHelper.headline7(),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Obx(
                        () => Text(
                          controller.paginationController.total.value
                              .toString(),
                          style: TextStyleHelper.subtitle2(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: content,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 38),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Dashboard',
                style: TextStyleHelper.headerStyle,
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          indent: 0,
          endIndent: 0,
        ),
      ],
    );
  }
}

//task card
class MyTasksContent extends StatelessWidget {
  final String overline;
  final String title;

  const MyTasksContent({
    Key key,
    this.title,
    this.overline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _filterController = Get.put(
      TaskFilterController(),
      tag: 'MyTasksContent',
    );
    _filterController.setupPreset('myTasks');

    var controller = Get.put(
      TasksController(
        _filterController,
        Get.put(PaginationController(), tag: 'MyTasksContent'),
      ),
      tag: 'MyTasksContent',
    );

    return DashboardCardView(
      title: title,
      overline: overline,
      controller: controller,
      content: TaskCardContent(
        controller: controller,
      ),
    );
  }
}

//task card
class UpcommingContent extends StatelessWidget {
  final String overline;
  final String title;

  const UpcommingContent({
    Key key,
    this.title,
    this.overline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _filterController = Get.put(
      TaskFilterController(),
      tag: 'UpcommingContent',
    );
    _filterController.setupPreset('upcomming');

    var controller = Get.put(
      TasksController(
        _filterController,
        Get.put(PaginationController(), tag: 'UpcommingContent'),
      ),
      tag: 'UpcommingContent',
    );

    return DashboardCardView(
      title: title,
      overline: overline,
      controller: controller,
      content: TaskCardContent(
        controller: controller,
      ),
    );
  }
}

//project card
class MyProjectsContent extends StatelessWidget {
  final String overline;
  final String title;

  const MyProjectsContent({
    Key key,
    this.title,
    this.overline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _filterController = Get.put(
      ProjectsFilterController(),
      tag: 'myProjects',
    );
    _filterController.setupPreset('myProjects');

    var controller = Get.put(
      ProjectsController(
        _filterController,
        Get.put(PaginationController(), tag: 'myProjects'),
      ),
      tag: 'myProjects',
    );

    return DashboardCardView(
      title: title,
      overline: overline,
      controller: controller,
      content: ProjectCardContent(
        controller: controller,
      ),
    );
  }
}

//project card
class MyFollowedProjectsContent extends StatelessWidget {
  final String overline;
  final String title;

  const MyFollowedProjectsContent({
    Key key,
    this.title,
    this.overline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _filterController =
        Get.put(ProjectsFilterController(), tag: 'myFollowedProjects');
    _filterController.setupPreset('myFollowedProjects');
    var controller = Get.put(
        ProjectsController(
          _filterController,
          Get.put(PaginationController(), tag: 'myFollowedProjects'),
        ),
        tag: 'myFollowedProjects');

    return DashboardCardView(
      title: title,
      overline: overline,
      controller: controller,
      content: ProjectCardContent(
        controller: controller,
      ),
    );
  }
}

//project card
class ActiveProjectsContent extends StatelessWidget {
  final String overline;
  final String title;

  const ActiveProjectsContent({
    Key key,
    this.title,
    this.overline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _filterController =
        Get.put(ProjectsFilterController(), tag: 'active');
    _filterController.setupPreset('active');
    var controller = Get.put(
        ProjectsController(
          _filterController,
          Get.put(PaginationController(), tag: 'active'),
        ),
        tag: 'active');

    return DashboardCardView(
      title: title,
      overline: overline,
      controller: controller,
      content: ProjectCardContent(
        controller: controller,
      ),
    );
  }
}

//project content
class ProjectCardContent extends StatelessWidget {
  final ProjectsController controller;

  ProjectCardContent({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.loadProjects();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (controller.loaded.value)
            Column(children: [
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (c, i) => i < 2
                    ? ProjectCell(item: controller.paginationController.data[i])
                    : const SizedBox(),
                // itemExtent: 72.0,
                itemCount: controller.paginationController.data.length,
              ),
            ]),
        ],
      ),
    );
  }
}

//task content
class TaskCardContent extends StatelessWidget {
  final TasksController controller;

  TaskCardContent({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.loadTasks();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (controller.loaded.value)
            Column(children: [
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (c, i) => i < 2
                    ? TaskCell(task: controller.paginationController.data[i])
                    : const SizedBox(),
                // itemExtent: 72.0,
                itemCount: controller.paginationController.data.length,
              ),
            ]),
        ],
      ),
    );
  }
}
