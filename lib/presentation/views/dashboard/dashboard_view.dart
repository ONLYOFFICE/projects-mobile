import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/dashboard_controller.dart';

import 'package:projects/domain/controllers/projects/projects_controller.dart';
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
    var dashboardController = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: Get.theme.colors().background,
      appBar: StyledAppBar(
        bgColor: Get.theme.colors().background,
        title: Title(controller: dashboardController),
        // titleHeight: 50,
        elevation: 0,
        showBackButton: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        controller: dashboardController.scrollController,
        children: <Widget>[
          DashboardCardView(
            title: tr('myTasks'),
            overline: tr('tasks'),
            controller: dashboardController.myTaskController,
          ),
          DashboardCardView(
            title: tr('upcomingTasks'),
            overline: tr('tasks'),
            controller: dashboardController.upcomingTaskscontroller,
          ),
          DashboardCardView(
            title: tr('myProjects'),
            overline: tr('projects'),
            controller: dashboardController.myProjectsController,
          ),
          DashboardCardView(
            title: tr('projectsIFolow'),
            overline: tr('projects'),
            controller: dashboardController.folowedProjectsController,
          ),
          DashboardCardView(
            title: tr('activeProjects'),
            overline: tr('projects'),
            controller: dashboardController.activeProjectsController,
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
        elevation: 1,
        color: Get.theme.colors().surface,
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () => {
                  controller.expandedCardView.value =
                      !controller.expandedCardView.value
                },
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                              color:
                                  Get.theme.colors().onSurface.withOpacity(0.6),
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
                          Container(
                            height: 28,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Get.theme.colors().bgDescription,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Obx(
                                () => Text(
                                  controller.paginationController.total.value
                                      .toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyleHelper.subtitle2(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              if (controller.expandedCardView.value)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
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
                            if (!controller.loaded.value)
                              Container(
                                height: 100,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            if (controller.loaded.value &&
                                controller.paginationController.total.value ==
                                    0)
                              Container(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      tr('dashboardNoActive',
                                          args: [overline.toLowerCase()]),
                                      style: TextStyleHelper.subtitle1(
                                        color: Get.theme
                                            .colors()
                                            .onSurface
                                            .withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            if (controller.loaded.value &&
                                controller.paginationController.total.value > 2)
                              Container(
                                height: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () => {
                                        controller.showAll.value =
                                            !controller.showAll.value
                                      },
                                      child: !controller.showAll.value
                                          ? Text(
                                              tr('viewAll').toUpperCase(),
                                              style: TextStyleHelper.button(
                                                color:
                                                    Get.theme.colors().primary,
                                              ),
                                            )
                                          : Text(
                                              tr('viewLess').toUpperCase(),
                                              style: TextStyleHelper.button(
                                                color:
                                                    Get.theme.colors().primary,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key key, @required this.controller}) : super(key: key);
  final controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Obx(
              () => Text(
                controller.screenName.value,
                style: TextStyleHelper.headerStyle,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const SizedBox(width: 24),
            ],
          ),
        ],
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
    return Obx(
      () => controller.showAll.isTrue
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (controller.loaded.value)
                  Column(children: [
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (c, i) => ProjectCell(
                          item: controller.paginationController.data[i]),
                      itemCount: controller.paginationController.data.length,
                    ),
                  ]),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (controller.loaded.value)
                  Column(children: [
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (c, i) => i < 2
                          ? ProjectCell(
                              item: controller.paginationController.data[i])
                          : const SizedBox(),
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
      () => controller.showAll.isTrue
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (controller.loaded.value)
                  Column(children: [
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (c, i) => TaskCell(
                          task: controller.paginationController.data[i]),
                      itemCount: controller.paginationController.data.length,
                    ),
                  ]),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (controller.loaded.value)
                  Column(children: [
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (c, i) => i < 2
                          ? TaskCell(
                              task: controller.paginationController.data[i])
                          : const SizedBox(),
                      itemCount: controller.paginationController.data.length,
                    ),
                  ]),
              ],
            ),
    );
  }
}
