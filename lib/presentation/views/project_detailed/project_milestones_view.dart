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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_data_source.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/views/project_detailed/milestones/filter/milestone_filter_screen.dart';
import 'package:projects/presentation/views/project_detailed/milestones/milestone_cell.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/views/project_detailed/milestones/new_milestone.dart';

class ProjectMilestonesScreen extends StatelessWidget {
  final ProjectDetailed projectDetailed;
  const ProjectMilestonesScreen({
    Key key,
    @required this.projectDetailed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<MilestonesDataSource>();
    controller.setup(projectDetailed: projectDetailed);
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
                  onPressed: () => Get.find<NavigationController>().to(
                      const NewMilestoneView(),
                      arguments: {'projectDetailed': projectDetailed}),
                  child: AppIcon(
                    icon: SvgIcons.fab_milestone,
                    color: Get.theme.colors().onPrimarySurface,
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
    Key key,
    @required this.controller,
  }) : super(key: key);

  final MilestonesDataSource controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Header(),
          if (controller.loaded.value == false) const ListLoadingSkeleton(),
          if (controller.loaded.value == true &&
              controller.paginationController.data.isEmpty &&
              !controller.filterController.hasFilters.value)
            Expanded(
              child: Center(
                child: EmptyScreen(
                    icon: SvgIcons.milestone_not_created,
                    text: tr('noMilestonesCreated')),
              ),
            ),
          if (controller.loaded.value == true &&
              controller.paginationController.data.isEmpty &&
              controller.filterController.hasFilters.value)
            Expanded(
              child: Center(
                child: EmptyScreen(
                    icon: SvgIcons.not_found, text: tr('noMilestonesMatching')),
              ),
            ),
          if (controller.loaded.value == true &&
              controller.paginationController.data.isNotEmpty)
            Expanded(
              child: PaginationListView(
                paginationController: controller.paginationController,
                child: ListView.builder(
                  itemBuilder: (c, i) => MilestoneCell(
                      milestone: controller.paginationController.data[i]),
                  itemExtent: 72.0,
                  itemCount: controller.paginationController.data.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  Header({
    Key key,
  }) : super(key: key);
  final controller = Get.find<MilestonesDataSource>();

  @override
  Widget build(BuildContext context) {
    var options = Column(
      children: [
        const SizedBox(height: 14.5),
        const Divider(height: 9, thickness: 1),
        SortTile(
            sortParameter: 'deadline',
            sortController: controller.sortController),
        SortTile(
            sortParameter: 'create_on',
            sortController: controller.sortController),
        SortTile(
            sortParameter: 'title', sortController: controller.sortController),
        const SizedBox(height: 20)
      ],
    );

    var sortButton = Container(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        onTap: () {
          Get.bottomSheet(SortView(sortOptions: options),
              isScrollControlled: true);
        },
        child: Row(
          children: <Widget>[
            Obx(
              () => Text(
                controller.sortController.currentSortTitle.value,
                style: TextStyleHelper.projectsSorting
                    .copyWith(color: Get.theme.colors().primary),
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

    return Visibility(
      visible: controller.itemList.isNotEmpty ||
          controller.filterController.hasFilters.value == true,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                sortButton,
                Container(
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () async => Get.find<NavigationController>()
                            .toScreen(const MilestoneFilterScreen()),
                        child: FiltersButton(controler: controller),
                      ),
                    ],
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
