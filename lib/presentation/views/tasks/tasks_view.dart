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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_sort_controller.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/tasks/task_cell.dart';
import 'package:projects/presentation/views/tasks/tasks_header_widget.dart';

class TasksView extends StatelessWidget {
  const TasksView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var taskStatusesController = Get.find<TaskStatusesController>();
    taskStatusesController.getStatuses();
    var controller = Get.find<TasksController>();
    controller.loadTasks();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: Obx(() => AnimatedPadding(
          padding:
              EdgeInsets.only(bottom: controller.fabIsRaised.isTrue ? 48 : 0),
          duration: const Duration(milliseconds: 100),
          child: StyledFloatingActionButton(
              onPressed: () => Get.toNamed('NewTaskView'),
              child: const Icon(Icons.add_rounded)))),
      appBar: StyledAppBar(
        bottom: TasksHeader(),
        titleHeight: 0,
        bottomHeight: 100,
      ),
      body: Obx(
        () {
          if (controller.loaded.isFalse)
            return const ListLoadingSkeleton();
          else {
            return PaginationListView(
              paginationController: controller.paginationController,
              child: ListView.builder(
                itemCount: controller.paginationController.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return TaskCell(
                      task: controller.paginationController.data[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class TasksHeader extends StatelessWidget {
  TasksHeader({
    Key key,
  }) : super(key: key);

  final controller = Get.find<TasksController>();
  final sortController = Get.find<TasksSortController>();

  @override
  Widget build(BuildContext context) {
    var options = Column(
      children: [
        const SizedBox(height: 14.5),
        const Divider(height: 9, thickness: 1),
        SortTile(sortParameter: 'deadline', sortController: sortController),
        SortTile(sortParameter: 'priority', sortController: sortController),
        SortTile(sortParameter: 'create_on', sortController: sortController),
        SortTile(sortParameter: 'start_date', sortController: sortController),
        SortTile(sortParameter: 'title', sortController: sortController),
        SortTile(sortParameter: 'sort_order', sortController: sortController),
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
                sortController.currentSortTitle.value,
                style: TextStyleHelper.projectsSorting,
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => (sortController.currentSortOrder == 'ascending')
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

    return TasksHeaderWidget(controller: controller, sortButton: sortButton);
  }
}
