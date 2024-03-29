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
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_data_source.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/views/project_detailed/milestones/filter/milestone_filter_screen.dart';
import 'package:projects/presentation/views/project_detailed/milestones/milestone_cell.dart';
import 'package:projects/presentation/views/project_detailed/milestones/new_milestone.dart';

class ProjectMilestonesScreen extends StatelessWidget {
  final MilestonesDataSource controller;
  const ProjectMilestonesScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _Content(controller: controller),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 24),
            child: Obx(
              () => Visibility(
                visible: controller.fabIsVisible.value,
                child: StyledFloatingActionButton(
                  onPressed: () => Get.find<NavigationController>().toScreen(
                    const NewMilestoneView(),
                    arguments: {'projectDetailed': controller.projectDetailed},
                    page: '/NewMilestoneView',
                  ),
                  child: AppIcon(
                    icon: SvgIcons.fab_milestone,
                    color: Theme.of(context).colors().onPrimarySurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final MilestonesDataSource controller;

  @override
  Widget build(BuildContext context) {
    final platformController = Get.find<PlatformController>();

    return Obx(
      () {
        if (!controller.loaded.value) return const ListLoadingSkeleton();

        final scrollController = ScrollController();
        return PaginationListView(
          scrollController: scrollController,
          paginationController: controller.paginationController,
          child: () {
            if (controller.loaded.value &&
                controller.paginationController.data.isEmpty &&
                !controller.filterController.hasFilters.value)
              return Center(
                child: EmptyScreen(
                  icon: SvgIcons.milestone_not_created,
                  text: tr('noMilestonesCreated'),
                ),
              );
            if (controller.loaded.value &&
                controller.paginationController.data.isEmpty &&
                controller.filterController.hasFilters.value)
              return Center(
                child: EmptyScreen(icon: SvgIcons.not_found, text: tr('noMilestonesMatching')),
              );
            if (controller.loaded.value && controller.paginationController.data.isNotEmpty)
              return ListView.separated(
                controller: scrollController,
                separatorBuilder: (_, i) => !platformController.isMobile
                    ? const StyledDivider(leftPadding: 72)
                    : const SizedBox(),
                itemBuilder: (c, i) => MilestoneCell(milestone: controller.itemList[i]),
                itemCount: controller.itemList.length,
              );
          }() as Widget,
        );
      },
    );
  }
}

class ProjectMilestonesFilterButton extends StatelessWidget {
  const ProjectMilestonesFilterButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final MilestonesDataSource controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.itemList.isNotEmpty || controller.filterController.hasFilters.value)
        return PlatformIconButton(
          icon: FiltersButton(controller: controller),
          padding: EdgeInsets.zero,
          onPressed: () async => Get.find<NavigationController>().toScreen(
            const MilestoneFilterScreen(),
            arguments: {'filterController': controller.filterController},
            transition: Transition.cupertinoDialog,
            fullscreenDialog: true,
            page: '/MilestoneFilterScreen',
          ),
          cupertino: (_, __) => CupertinoIconButtonData(minSize: 36),
        );
      return const SizedBox();
    });
  }
}
