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
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/views/tasks_filter.dart/select/select_group.dart';
import 'package:projects/presentation/views/tasks_filter.dart/select/select_milestone.dart';
import 'package:projects/presentation/views/tasks_filter.dart/select/select_project.dart';
import 'package:projects/presentation/views/tasks_filter.dart/select/select_tag.dart';
import 'package:projects/presentation/views/tasks_filter.dart/select/select_user.dart';

part 'filter_label.dart';
part 'filter_element.dart';
part 'filters/responsible.dart';
part 'filters/creator.dart';
part 'filters/project.dart';
part 'filters/milestone.dart';

class TasksFilter extends StatelessWidget {
  const TasksFilter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();
    return Container(
      height: Get.height - 40,
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 4,
                  width: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 16, top: 6),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              size: 26,
                              color: Theme.of(context).customColors().primary,
                            ),
                            onPressed: () => Get.back(),
                          ),
                          const SizedBox(width: 10),
                          Text('Filter',
                              style: TextStyleHelper.h6(
                                  color: Theme.of(context)
                                      .customColors()
                                      .onSurface))
                        ],
                      ),
                      TextButton(
                          onPressed: () async {
                            filterController.resetFilters();
                            var tasksC = Get.find<TasksController>();
                            tasksC.onRefresh();
                            Get.back();
                          },
                          child: Text('RESET',
                              style: TextStyleHelper.button(
                                  color: Theme.of(context)
                                      .customColors()
                                      .systemBlue)))
                    ])),
            const Divider(height: 18),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    children: [
                      const _Responsible(),
                      const _Creator(),
                      const _Project(),
                      const _Milestone(),
                      const SizedBox(height: 40)
                    ],
                  ),
                  if (filterController.suitableTasksCount.value != -1)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: TextButton(
                          onPressed: () async {
                            filterController.filter();
                            Get.back();
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.resolveWith<
                                      EdgeInsetsGeometry>(
                                  (_) => EdgeInsets.only(
                                      left: Get.width * 0.243,
                                      right: Get.width * 0.243,
                                      top: 10,
                                      bottom: 12)),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>((_) {
                                return Theme.of(context).customColors().primary;
                              }),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)))),
                          child: Text(
                              'SHOW ${filterController.suitableTasksCount.value} TASK',
                              style: TextStyleHelper.button(
                                  color: Theme.of(context)
                                      .customColors()
                                      .onPrimary)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
