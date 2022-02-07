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
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_smart_refresher.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/creating_and_editing_subtask_view.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtask_cell.dart';

class SubtasksView extends StatelessWidget {
  final TaskItemController controller;

  const SubtasksView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.loaded.value == true) {
          return Stack(
            children: [
              StyledSmartRefresher(
                controller: controller.subtaskRefreshController,
                onRefresh: () => controller.reloadTask(showLoading: true),
                child: () {
                  if (controller.task.value.subtasks!.isEmpty)
                    return Center(
                      child: EmptyScreen(
                        icon: SvgIcons.task_not_created,
                        text: tr('noSubtasksCreated'),
                      ),
                    );

                  if (controller.task.value.subtasks!.isNotEmpty)
                    return ListView.builder(
                      itemCount: controller.task.value.subtasks!.length,
                      padding: const EdgeInsets.only(top: 6, bottom: 50),
                      itemBuilder: (BuildContext context, int index) {
                        return SubtaskCell(
                          subtask: controller.task.value.subtasks![index],
                          parentTask: controller.task.value,
                        );
                      },
                    );
                }(),
              ),
              if (controller.task.value.canCreateSubtask == true &&
                  controller.task.value.status != 2)
                _FAB(task: controller.task.value),
            ],
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}

class _FAB extends StatelessWidget {
  const _FAB({
    Key? key,
    required PortalTask task,
  })  : _task = task,
        super(key: key);

  final PortalTask _task;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 24,
      child: StyledFloatingActionButton(
        onPressed: () => Get.find<NavigationController>().to(const CreatingAndEditingSubtaskView(),
            arguments: {
              'taskId': _task.id,
              'projectId': _task.projectOwner!.id,
              'forEditing': false,
            },
            transition: Transition.cupertinoDialog,
            fullscreenDialog: true),
        child: AppIcon(
          icon: SvgIcons.add_fab,
          color: Get.theme.colors().onPrimarySurface,
        ),
      ),
    );
  }
}
