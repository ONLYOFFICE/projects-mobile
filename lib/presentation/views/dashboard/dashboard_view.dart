import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';

import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';
import 'package:projects/presentation/views/tasks/task_cell.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';

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
          const MyTasksCard(
            title: 'My Tasks',
            overline: 'Tasks',
          ),
          const UpcommingCard(
            title: 'Upcoming',
            overline: 'Tasks',
          ),
          const MyProjectsCard(
            title: 'My Projects',
            overline: 'Projects',
          ),
          const MyFollowedProjectsCard(
            title: 'Projects I Folow',
            overline: 'Projects',
          ),
          const ActiveProjectsCard(
            title: 'Active Projects',
            overline: 'Projects',
          ),
        ],
      ),
    );
  }
}

class DashboardCardView extends StatelessWidget {
  final String overline;
  final String title;
  final controller;

  DashboardCardView({
    Key key,
    this.title,
    this.overline,
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
                        style: TextStyleHelper.overline(
                          color: Theme.of(context)
                              .customColors()
                              .onSurface
                              .withOpacity(0.6),
                        ),
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
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (!controller.loaded.value)
                      Container(
                        height: 100,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    if (controller.loaded.value &&
                        controller.paginationController.total.value == 0)
                      Container(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'There are no active ${overline.toLowerCase()}',
                              style: TextStyleHelper.subtitle1(
                                color: Theme.of(context)
                                    .customColors()
                                    .onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (controller is ProjectsController &&
                        controller.loaded.value)
                      Expanded(
                        child: ProjectCardContent(
                          controller: controller,
                        ),
                      ),
                    if (controller is TasksController &&
                        controller.loaded.value)
                      Expanded(
                        child: TaskCardContent(
                          controller: controller,
                        ),
                      ),
                  ],
                ),
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
class MyTasksCard extends StatelessWidget {
  final String overline;
  final String title;

  const MyTasksCard({
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

    var controller = Get.put(
      TasksController(
        _filterController,
        Get.put(PaginationController(), tag: 'MyTasksContent'),
      ),
      tag: 'MyTasksContent',
    );
    _filterController
        .setupPreset('myTasks')
        .then((value) => controller.loadTasks());

    return DashboardCardView(
      title: title,
      overline: overline,
      controller: controller,
    );
  }
}

//task card
class UpcommingCard extends StatelessWidget {
  final String overline;
  final String title;

  const UpcommingCard({
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

    var controller = Get.put(
      TasksController(
        _filterController,
        Get.put(PaginationController(), tag: 'UpcommingContent'),
      ),
      tag: 'UpcommingContent',
    );
    _filterController
        .setupPreset('upcomming')
        .then((value) => controller.loadTasks());
    return DashboardCardView(
      title: title,
      overline: overline,
      controller: controller,
    );
  }
}

//project card
class MyProjectsCard extends StatelessWidget {
  final String overline;
  final String title;

  const MyProjectsCard({
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

    var controller = Get.put(
      ProjectsController(
        _filterController,
        Get.put(PaginationController(), tag: 'myProjects'),
      ),
      tag: 'myProjects',
    );

    _filterController
        .setupPreset('myProjects')
        .then((value) => controller.loadProjects());

    return DashboardCardView(
      title: title,
      overline: overline,
      controller: controller,
    );
  }
}

//project card
class MyFollowedProjectsCard extends StatelessWidget {
  final String overline;
  final String title;

  const MyFollowedProjectsCard({
    Key key,
    this.title,
    this.overline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _filterController =
        Get.put(ProjectsFilterController(), tag: 'myFollowedProjects');

    var controller = Get.put(
        ProjectsController(
          _filterController,
          Get.put(PaginationController(), tag: 'myFollowedProjects'),
        ),
        tag: 'myFollowedProjects');
    _filterController
        .setupPreset('myFollowedProjects')
        .then((value) => controller.loadProjects());

    return DashboardCardView(
      title: title,
      overline: overline,
      controller: controller,
    );
  }
}

//project card
class ActiveProjectsCard extends StatelessWidget {
  final String overline;
  final String title;

  const ActiveProjectsCard({
    Key key,
    this.title,
    this.overline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _filterController =
        Get.put(ProjectsFilterController(), tag: 'active');

    var controller = Get.put(
        ProjectsController(
          _filterController,
          Get.put(PaginationController(), tag: 'active'),
        ),
        tag: 'active');
    _filterController
        .setupPreset('active')
        .then((value) => controller.loadProjects());
    return DashboardCardView(
      title: title,
      overline: overline,
      controller: controller,
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
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
