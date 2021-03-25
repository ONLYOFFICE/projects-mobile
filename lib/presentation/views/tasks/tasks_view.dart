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

import 'package:projects/domain/controllers/tasks_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/header_widget.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/tasks/task_cell.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class TasksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TasksController());
    controller.getTasks();
    // var dtc = Get.put(DetailedTaskController());

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: StyledFloatingActionButton(
        child: Icon(Icons.add_rounded),
      ),
      body: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HeaderWidget(title: 'Tasks'),
              if (controller.loaded.isFalse)
                _TasksLoading(),
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


class _TasksLoading extends StatelessWidget {
  const _TasksLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var _decoration = BoxDecoration(
      color: Theme.of(context).customColors().bgDescription,
      borderRadius: BorderRadius.circular(2)
    );

    return Container(
      child: Column(
        children: [
          LinearProgressIndicator(
            minHeight: 4,
            backgroundColor: Theme.of(context).customColors().primary,
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xffb5c4d2)),
          ),
          Shimmer.fromColors(
            baseColor: Theme.of(context).customColors().bgDescription, 
            highlightColor: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 22),
                for (var i = 0; i < 4; i++)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).customColors().bgDescription
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 12,
                              decoration: _decoration
                            ),
                            Container(
                              height: 12,
                              margin: const EdgeInsets.only(top: 6),
                              width: Get.width / 3,
                              decoration: _decoration
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: 41,
                        height: 12,
                        decoration: _decoration
                      )
                    ],
                  )
              ],
            ), 
          )
        ],
      ),
    );
  }
}