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
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/task_detailed/comments/task_comments_view.dart';
import 'package:projects/presentation/views/task_detailed/detailed_task_app_bar.dart';
import 'package:projects/presentation/views/task_detailed/documents/documents_view.dart';
import 'package:projects/presentation/views/task_detailed/overview/overview_screen.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtasks_view.dart';

class TaskDetailedView extends StatelessWidget {
  const TaskDetailedView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TaskItemController controller = Get.arguments['controller'];

    controller.reloadTask();

    return Obx(() {
      // if (controller.loaded.isTrue) {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: DetailedTaskAppBar(
            bottom: SizedBox(
              height: 25,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TabBar(
                    isScrollable: true,
                    indicatorColor: Theme.of(context).customColors().primary,
                    labelColor: Theme.of(context).customColors().onSurface,
                    unselectedLabelColor: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.6),
                    labelStyle: TextStyleHelper.subtitle2(),
                    tabs: [
                      const Tab(text: 'Overview'),
                      _Tab(
                          title: 'Subtasks',
                          count: controller.task.value?.subtasks?.length),
                      _Tab(
                          title: 'Documents',
                          count: controller.task.value?.files?.length),
                      _Tab(
                          title: 'Comments',
                          count: controller.task.value?.comments?.length),
                    ]),
              ),
            ),
          ),
          body: TabBarView(children: [
            OverviewScreen(taskController: controller),
            SubtasksView(controller: controller),
            DocumentsView(controller: controller),
            TaskCommentsView(controller: controller)
          ]),
        ),
      );
      // } else {
      //   return const ListLoadingSkeleton();
      // }
    });
  }
}

class _Tab extends StatelessWidget {
  final String title;
  final int count;
  const _Tab({
    Key key,
    this.title,
    this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        if (count != null) const SizedBox(width: 8),
        if (count != null)
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).customColors().primary),
            child: Center(
              child: Text(count.toString(),
                  style: TextStyleHelper.subtitle2(
                      color: Theme.of(context).customColors().surface)),
            ),
          ),
      ],
    );
  }
}
