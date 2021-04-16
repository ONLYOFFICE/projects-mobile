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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/sort_controller.dart';

import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/header_widget.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';
import 'package:projects/presentation/views/tasks/task_cell.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';

class TasksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var taskStatusesController = Get.find<TaskStatusesController>();
    taskStatusesController.getStatuses();
    var controller = Get.find<TasksController>();
    controller.getTasks();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: StyledFloatingActionButton(
        onPressed: () => Get.toNamed('NewTaskView'),
        child: Icon(Icons.add_rounded),
      ),
      body: Obx(
        () {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TasksHeader(),
              if (controller.loaded.isFalse) ListLoadingSkeleton(),
              if (controller.loaded.isTrue)
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    controller: controller.refreshController,
                    onRefresh: () => controller.onRefresh(),
                    child: ListView.builder(
                      itemCount: controller.tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskCell(task: controller.tasks[index]);
                      },
                    ),
                  ),
                ),
            ],
          );
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
        SizedBox(height: 14.5),
        Divider(height: 9, thickness: 1),
        SortTile(title: 'Deadline', sortController: sortController),
        SortTile(title: 'Priority', sortController: sortController),
        SortTile(title: 'Creation date', sortController: sortController),
        SortTile(title: 'Start date', sortController: sortController),
        SortTile(title: 'Title', sortController: sortController),
        SortTile(title: 'Order', sortController: sortController),
        SizedBox(height: 20)
      ],
    );

    var sortButton = Container(
      padding: EdgeInsets.only(right: 4),
      child: GestureDetector(
        onTap: () {
          Get.bottomSheet(SortView(sortOptions: options),
              isScrollControlled: true);
        },
        child: Row(
          children: <Widget>[
            Text(
              sortController.currentSortText.value,
              style: TextStyleHelper.projectsSorting,
            ),
            const SizedBox(width: 8),
            SVG.createSized(
                'lib/assets/images/icons/sorting_3_descend.svg', 20, 20),
          ],
        ),
      ),
    );

    return HeaderWidget(controller: controller, sortButton: sortButton);
  }
}
