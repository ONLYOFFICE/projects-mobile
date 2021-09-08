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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/dashboard_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';

import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/dashboard/dashboard_more_view.dart';
import 'package:projects/presentation/views/dashboard/tasks_dashboard_more_view.dart';
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
        backgroundColor: Get.theme.colors().background,
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
            overline: tr('tasks'),
            controller: dashboardController.myTaskController,
          ),
          DashboardCardView(
            overline: tr('tasks'),
            controller: dashboardController.upcomingTaskscontroller,
          ),
          DashboardCardView(
            overline: tr('projects'),
            controller: dashboardController.myProjectsController,
          ),
          DashboardCardView(
            overline: tr('projects'),
            controller: dashboardController.folowedProjectsController,
          ),
          DashboardCardView(
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
  final controller;

  DashboardCardView({
    Key key,
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
                            controller.screenName,
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
                                        Get.find<NavigationController>().to(
                                            controller is ProjectsController
                                                ? const ProjectsDashboardMoreView()
                                                : const TasksDashboardMoreView(),
                                            arguments: {
                                              'controller': controller
                                            }),
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
      () => controller.showAll.value == true
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
      () => controller.showAll.value == true
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
