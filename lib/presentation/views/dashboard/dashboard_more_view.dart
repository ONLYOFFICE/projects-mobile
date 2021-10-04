import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/views/projects_view/projects_view.dart';

class ProjectsDashboardMoreView extends StatelessWidget {
  const ProjectsDashboardMoreView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProjectsController controller = Get.arguments['controller'];

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
            icon: SvgIcons.fab_project,
            width: 32,
            height: 32,
            color: Get.theme.colors().onPrimarySurface,
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 101),
        child: ValueListenableBuilder(
          valueListenable: elevation,
          builder: (_, value, __) => StyledAppBar(
            title: _Title(controller: controller),
            bottom: Bottom(controller: controller),
            showBackButton: true,
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
                  icon: SvgIcons.project_not_created,
                  text: tr('noProjectsCreated',
                      args: [tr('projects').toLowerCase()])),
            );
          }
          if (controller.loaded.value == true &&
              controller.paginationController.data.isEmpty &&
              controller.filterController.hasFilters.value) {
            return Center(
              child: EmptyScreen(
                  icon: SvgIcons.not_found,
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
            ],
          ),
        ],
      ),
    );
  }
}
