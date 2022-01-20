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

import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/presentation/shared/mixins/show_popup_menu_mixin.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_widget.dart';
import 'package:projects/presentation/views/projects_view/project_filter/projects_filter.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';

class ProjectsView extends StatelessWidget {
  const ProjectsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProjectsController controller;

    controller = Get.isRegistered<ProjectsController>(tag: 'ProjectsView')
        ? Get.find<ProjectsController>(tag: 'ProjectsView')
        : Get.put(
            ProjectsController(
              Get.find<ProjectsFilterController>(),
              Get.find<PaginationController<ProjectDetailed>>(),
            ),
            tag: 'ProjectsView',
          );

    controller.setup(PresetProjectFilters.saved);
    controller.loadProjects();

    return Scaffold(
      backgroundColor: Get.theme.colors().backgroundColor,
      floatingActionButton: Obx(
        () => Visibility(
          visible: controller.fabIsVisible.value,
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
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            MainAppBar(
              materialTitle: Text(
                controller.screenName,
                style: TextStyleHelper.headerStyle(color: Get.theme.colors().onSurface),
              ),
              cupertinoTitle: Text(
                controller.screenName,
                style: TextStyle(color: Get.theme.colors().onSurface),
              ),
              actions: [
                PlatformIconButton(
                  onPressed: controller.showSearch,
                  cupertino: (_, __) {
                    return CupertinoIconButtonData(
                      icon: AppIcon(
                        icon: SvgIcons.search,
                        color: Get.theme.colors().primary,
                      ),
                      color: Get.theme.colors().background,
                      onPressed: controller.showSearch,
                      padding: EdgeInsets.zero,
                    );
                  },
                  materialIcon: AppIcon(
                    icon: SvgIcons.search,
                    color: Get.theme.colors().primary,
                  ),
                ),
                PlatformIconButton(
                  onPressed: () async => Get.find<NavigationController>().toScreen(
                      const ProjectsFilterScreen(),
                      preventDuplicates: false,
                      arguments: {'filterController': controller.filterController}),
                  cupertino: (_, __) {
                    return CupertinoIconButtonData(
                      icon: FiltersButton(controller: controller),
                      color: Get.theme.colors().background,
                      padding: EdgeInsets.zero,
                    );
                  },
                  materialIcon: FiltersButton(controller: controller),
                ),
                PlatformIconButton(
                  onPressed: () {},
                  cupertino: (_, __) {
                    return CupertinoIconButtonData(
                      icon: Icon(
                        CupertinoIcons.ellipsis_circle,
                        color: Get.theme.colors().primary,
                      ),
                      color: Get.theme.colors().background,
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    );
                  },
                  materialIcon: Icon(
                    Icons.more_vert,
                    color: Get.theme.colors().primary,
                  ),
                ),
              ],
            ),
          ];
        },
        body: Obx(
          () {
            if (controller.loaded.value == false) {
              return const ListLoadingSkeleton();
            }
            if (controller.loaded.value == true &&
                controller.paginationController.data.isEmpty &&
                !controller.filterController!.hasFilters.value) {
              return Center(
                child:
                    EmptyScreen(icon: SvgIcons.project_not_created, text: tr('noProjectsCreated')),
              );
            }
            if (controller.loaded.value == true &&
                controller.paginationController.data.isEmpty &&
                controller.filterController!.hasFilters.value) {
              return Center(
                child: EmptyScreen(icon: SvgIcons.not_found, text: tr('noProjectsMatching')),
              );
            }
            return PaginationListView(
              paginationController: controller.paginationController,
              child: ListView.builder(
                // controller: scrollController,
                itemBuilder: (c, i) =>
                    ProjectCell(projectDetails: controller.paginationController.data[i]),
                itemCount: controller.paginationController.data.length,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key, required this.controller}) : super(key: key);
  final ProjectsController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              controller.screenName,
              style: TextStyleHelper.headerStyle(color: Get.theme.colors().onSurface),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkResponse(
                onTap: controller.showSearch,
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
                  Get.find<NavigationController>().toScreen(const ProjectsFilterScreen(),
                      preventDuplicates: false,
                      arguments: {'filterController': controller.filterController})
                },
                child: FiltersButton(controller: controller),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Bottom extends StatelessWidget {
  const Bottom({Key? key, required this.controller}) : super(key: key);
  final ProjectsController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 4),
              child: _ProjectsSortButton(controller: controller),
            ),
            Obx(
              () => Text(
                tr('total', args: [controller.paginationController.total.value.toString()]),
                style: TextStyleHelper.body2(
                  color: Get.theme.colors().onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectsSortButton extends StatelessWidget with ShowPopupMenuMixin {
  const _ProjectsSortButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ProjectsController controller;

  List<SortTile> _getSortTile() {
    return [
      SortTile(
        sortParameter: 'create_on',
        sortController: controller.sortController,
      ),
      SortTile(
        sortParameter: 'title',
        sortController: controller.sortController,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      material: (_, __) => TextButton(
        onPressed: () async {
          if (Get.find<PlatformController>().isMobile) {
            final options = Column(
              children: [
                const SizedBox(height: 14.5),
                const Divider(height: 9, thickness: 1),
                ..._getSortTile(),
                const SizedBox(height: 20),
              ],
            );

            await Get.bottomSheet(
              SortView(sortOptions: options),
              isScrollControlled: true,
            );
          } else {
            await showPopupMenu(
              context: context,
              options: _getSortTile(),
              offset: const Offset(0, 40),
            );
          }
        },
        child: Row(
          children: <Widget>[
            Obx(
              () => Text(
                controller.sortController.currentSortTitle.value,
                style: TextStyleHelper.projectsSorting.copyWith(color: Get.theme.colors().primary),
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => (controller.sortController.currentSortOrder == 'ascending')
                  ? AppIcon(
                      icon: SvgIcons.sorting_4_ascend,
                      color: Get.theme.colors().primary,
                      width: 20,
                      height: 20,
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(math.pi),
                      child: AppIcon(
                        icon: SvgIcons.sorting_4_ascend,
                        color: Get.theme.colors().primary,
                        width: 20,
                        height: 20,
                      ),
                    ),
            ),
          ],
        ),
      ),
      cupertino: (_, __) => IconButton(
        onPressed: () async {
          if (Get.find<PlatformController>().isMobile) {
            final options = Column(
              children: [
                const SizedBox(height: 14.5),
                const Divider(height: 9, thickness: 1),
                ..._getSortTile(),
                const SizedBox(height: 20),
              ],
            );

            await Get.bottomSheet(
              SortView(sortOptions: options),
              isScrollControlled: true,
            );
          } else {
            await showPopupMenu(
              context: context,
              options: _getSortTile(),
              offset: const Offset(0, 40),
            );
          }
        },
        icon: AppIcon(
            width: 24, height: 24, icon: SvgIcons.ios_sort, color: Get.theme.colors().primary),
      ),
    );
  }
}
