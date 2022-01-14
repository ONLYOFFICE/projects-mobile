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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';

class ProjectsDashboardMoreView extends StatelessWidget {
  const ProjectsDashboardMoreView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.arguments['controller'] as ProjectsController;

    return Scaffold(
      backgroundColor: Get.theme.colors().backgroundColor,
      floatingActionButton: Obx(
        () => Visibility(
          visible: controller.fabIsVisible.value,
          child: StyledFloatingActionButton(
            onPressed: controller.createNewProject,
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
              isCollapsed: true,
              cupertinoTitle: Text(
                controller.screenName,
                style: TextStyle(color: Get.theme.colors().onSurface),
              ),
              materialTitle: Text(
                controller.screenName,
                style: TextStyleHelper.headerStyle(color: Get.theme.colors().onSurface),
              ),
              actions: [
                _SearchButtonWidget(controller: controller),
                _MoreButtonWidget(controller: controller),
              ],
            ),
          ];
        },
        body: _DashboardMoreViewBodyWidget(controller: controller),
      ),
    );
  }
}

class _MoreButtonWidget extends StatelessWidget {
  const _MoreButtonWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ProjectsController controller;

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
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
    );
  }
}

class _SearchButtonWidget extends StatelessWidget {
  const _SearchButtonWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ProjectsController controller;

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
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
    );
  }
}

class _DashboardMoreViewBodyWidget extends StatelessWidget {
  const _DashboardMoreViewBodyWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ProjectsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.loaded.value == false) {
          return const ListLoadingSkeleton();
        }
        if (controller.loaded.value == true &&
            controller.paginationController.data.isEmpty &&
            !controller.filterController!.hasFilters.value) {
          return Center(
            child: EmptyScreen(icon: SvgIcons.project_not_created, text: tr('noProjectsCreated')),
          );
        }
        if (controller.loaded.value == true &&
            controller.paginationController.data.isEmpty &&
            controller.filterController!.hasFilters.value) {
          return Center(
            child: EmptyScreen(icon: SvgIcons.not_found, text: tr('noProjectsMatching')),
          );
        }
        return PaginationListView<ProjectDetailed>(
          paginationController: controller.paginationController,
          child: ListView.builder(
            itemBuilder: (c, i) =>
                ProjectCell(projectDetails: controller.paginationController.data[i]),
            itemCount: controller.paginationController.data.length,
          ),
        );
      },
    );
  }
}
