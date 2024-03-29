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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/dashboard_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_smart_refresher.dart';
import 'package:projects/presentation/views/dashboard/dashboard_more_view.dart';
import 'package:projects/presentation/views/dashboard/tasks_dashboard_more_view.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';
import 'package:projects/presentation/views/tasks/task_cell/task_cell.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>(tag: 'DashboardController');

    return Scaffold(
      backgroundColor: Theme.of(context).colors().backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            MainAppBar(
              cupertinoTitle: Text(
                dashboardController.screenName,
                style: TextStyle(color: Theme.of(context).colors().onSurface),
              ),
              materialTitle: Title(
                controller: dashboardController,
              ),
            ),
          ];
        },
        body: _BodyDashboardWidget(dashboardController: dashboardController),
      ),
    );
  }
}

class _BodyDashboardWidget extends StatelessWidget {
  const _BodyDashboardWidget({
    Key? key,
    required this.dashboardController,
  }) : super(key: key);

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return StyledSmartRefresher(
      controller: dashboardController.refreshController,
      onLoading: dashboardController.onLoading,
      onRefresh: dashboardController.onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        // controller: dashboardController.scrollController,
        children: <Widget>[
          DashboardCardView(
            overline: GetPlatform.isIOS ? tr('tasks') : tr('tasks').toUpperCase(),
            controller: dashboardController.myTaskController,
          ),
          DashboardCardView(
            overline: GetPlatform.isIOS ? tr('tasks') : tr('tasks').toUpperCase(),
            controller: dashboardController.upcomingTaskscontroller,
          ),
          DashboardCardView(
            overline: GetPlatform.isIOS ? tr('projects') : tr('projects').toUpperCase(),
            controller: dashboardController.myProjectsController,
          ),
          DashboardCardView(
            overline: GetPlatform.isIOS ? tr('projects') : tr('projects').toUpperCase(),
            controller: dashboardController.folowedProjectsController,
          ),
          DashboardCardView(
            overline: GetPlatform.isIOS ? tr('projects') : tr('projects').toUpperCase(),
            controller: dashboardController.activeProjectsController,
          ),
        ],
      ),
    );
  }
}

class DashboardCardView extends StatelessWidget {
  final String overline;
  final dynamic controller;

  DashboardCardView({
    Key? key,
    required this.overline,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: double.maxFinite,
      child: Card(
        elevation: 1,
        color: Theme.of(context).colors().surface,
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () => {
                controller.expandedCardView.value = !(controller.expandedCardView.value as bool)
              },
              child: Container(
                constraints: const BoxConstraints(minHeight: 60),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            overline,
                            style: TextStyleHelper.overline(
                              color: Theme.of(context).colors().onSurface.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            controller.screenName as String,
                            style: TextStyleHelper.headline7(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 28,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colors().bgDescription,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Obx(
                          () => Text(
                            controller.paginationController.total.value.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyleHelper.subtitle2(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Obx(() {
              if (controller.expandedCardView.value as bool)
                return Column(
                  children: <Widget>[
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (controller.loaded.value as bool &&
                              controller.paginationController.total.value == 0)
                            SizedBox(
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    tr('dashboardNoActive', args: [overline.toLowerCase()]),
                                    style: TextStyleHelper.subtitle1(
                                      color: Theme.of(context).colors().onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (controller is ProjectsController &&
                              controller.loaded.value as bool &&
                              controller.paginationController.total.value as int > 0)
                            Expanded(
                              child: ProjectCardContent(
                                controller: controller as ProjectsController,
                              ),
                            ),
                          if (controller is TasksController &&
                              controller.loaded.value as bool &&
                              controller.paginationController.total.value as int > 0)
                            Expanded(
                              child: TaskCardContent(
                                controller: controller as TasksController,
                              ),
                            ),
                          if (!(controller.loaded.value as bool))
                            SizedBox(
                              height: 100,
                              child: Center(child: PlatformCircularProgressIndicator()),
                            ),
                        ],
                      ),
                    ),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (controller.loaded.value as bool &&
                              (controller.paginationController.total.value as int) > 2)
                            SizedBox(
                              height: 50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PlatformTextButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () => {
                                      Get.find<NavigationController>().to(
                                          controller is ProjectsController
                                              ? const ProjectsDashboardMoreView()
                                              : const TasksDashboardMoreView(),
                                          arguments: {'controller': controller}),
                                    },
                                    child: !(controller.showAll.value as bool)
                                        ? Text(
                                            GetPlatform.isIOS
                                                ? tr('viewAll')
                                                : tr('viewAll').toUpperCase(),
                                            style: TextStyleHelper.button(
                                              color: Theme.of(context).colors().primary,
                                            ),
                                          )
                                        : Text(
                                            GetPlatform.isIOS
                                                ? tr('viewLess')
                                                : tr('viewLess').toUpperCase(),
                                            style: TextStyleHelper.button(
                                              color: Theme.of(context).colors().primary,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key, required this.controller}) : super(key: key);
  final DashboardController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              controller.screenName,
              style: TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const <Widget>[
              SizedBox(width: 24),
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

  const ProjectCardContent({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (controller.loaded.value)
          ListView.builder(
            padding: EdgeInsets.zero,
            itemExtent: 72,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (c, i) => i < 2
                ? ProjectCell(projectDetails: controller.paginationController.data[i])
                : const SizedBox(),
            itemCount: controller.paginationController.data.length < 2
                ? controller.paginationController.data.length
                : 2,
          ),
      ],
    );
  }
}

//task content
class TaskCardContent extends StatelessWidget {
  final TasksController controller;

  const TaskCardContent({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (controller.loaded.value)
          ListView.builder(
            itemExtent: 72,
            padding: EdgeInsets.zero,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (c, i) =>
                i < 2 ? TaskCell(task: controller.paginationController.data[i]) : const SizedBox(),
            itemCount: controller.paginationController.data.length < 2
                ? controller.paginationController.data.length
                : 2,
          ),
      ],
    );
  }
}
