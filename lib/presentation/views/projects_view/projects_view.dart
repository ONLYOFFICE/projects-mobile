import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/projects_view/project_filter/projects_filter.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';

import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class ProjectsView extends StatelessWidget {
  const ProjectsView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProjectsController controller;

    try {
      controller = Get.find<ProjectsController>(tag: 'ProjectsView');
    } catch (_) {
      controller = Get.put(
          ProjectsController(
            Get.put(ProjectsFilterController(), tag: 'ProjectsView'),
            Get.put(PaginationController(), tag: 'ProjectsView'),
          ),
          tag: 'ProjectsView');
    }

    controller.loadProjects();

    var scrollController = ScrollController();
    var elevation = ValueNotifier<double>(0);

    scrollController.addListener(
        () => elevation.value = scrollController.offset > 2 ? 1 : 0);

    return Scaffold(
      backgroundColor: Get.theme.colors().backgroundColor,
      floatingActionButton: Visibility(
        visible: controller.fabIsVisible(),
        child: StyledFloatingActionButton(
          onPressed: () => controller.createNewProject(),
          child: AppIcon(
            icon: SvgIcons.add_project,
            width: 32,
            height: 32,
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 101),
        child: ValueListenableBuilder(
          valueListenable: elevation,
          builder: (_, value, __) => StyledAppBar(
            title: _Title(controller: controller),
            bottom: _Bottom(controller: controller),
            showBackButton: false,
            elevation: value,
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
                  icon: AppIcon(icon: SvgIcons.project_not_created),
                  text: tr('noProjectsCreated',
                      args: [tr('projects').toLowerCase()])),
            );
          }
          if (controller.loaded.value == true &&
              controller.paginationController.data.isEmpty &&
              controller.filterController.hasFilters.value) {
            return Center(
              child: EmptyScreen(
                  icon: AppIcon(icon: SvgIcons.not_found),
                  text: tr('noProjectsMatching',
                      args: [tr('projects').toLowerCase()])),
            );
          }
          return PaginationListView(
            paginationController: controller.paginationController,
            child: ListView.builder(
              controller: scrollController,
              itemBuilder: (c, i) =>
                  ProjectCell(item: controller.paginationController.data[i]),
              itemCount: controller.paginationController.data.length,
            ),
          );
        },
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key key, @required this.controller}) : super(key: key);
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
            child: Text(
              controller.screenName,
              style: TextStyleHelper.headerStyle,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkResponse(
                onTap: () {
                  controller.showSearch();
                },
                child: AppIcon(
                  width: 24,
                  height: 24,
                  icon: SvgIcons.search,
                  color: Get.theme.colors().primary,
                ),
              ),
              const SizedBox(width: 24),
              InkResponse(
                onTap: () async => {
                  Get.find<NavigationController>()
                      .showScreen(const ProjectsFilterScreen())
                },
                child: FiltersButton(controler: controller),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  _Bottom({Key key, this.controller}) : super(key: key);
  final controller;
  @override
  Widget build(BuildContext context) {
    var options = Column(
      children: [
        const SizedBox(height: 14.5),
        const Divider(height: 9, thickness: 1),
        SortTile(
          sortParameter: 'create_on',
          sortController: controller.sortController,
        ),
        SortTile(
          sortParameter: 'title',
          sortController: controller.sortController,
        ),
        const SizedBox(height: 20),
      ],
    );

    var sortButton = Container(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        onTap: () {
          Get.bottomSheet(
            SortView(sortOptions: options),
            isScrollControlled: true,
          );
        },
        child: Row(
          children: <Widget>[
            Obx(
              () => Text(
                controller.sortController.currentSortTitle.value,
                style: TextStyleHelper.projectsSorting,
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => (controller.sortController.currentSortOrder == 'ascending')
                  ? AppIcon(
                      icon: SvgIcons.sorting_4_ascend,
                      width: 20,
                      height: 20,
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(math.pi),
                      child: AppIcon(
                        icon: SvgIcons.sorting_4_ascend,
                        width: 20,
                        height: 20,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          sortButton,
          Container(
            child: Row(
              children: <Widget>[
                Obx(
                  () => Text(
                    tr('total', args: [
                      controller.paginationController?.total?.value.toString()
                    ]),
                    style: TextStyleHelper.body2(
                      color: Get.theme.colors().onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
