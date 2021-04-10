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
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SubtasksView extends StatelessWidget {
  final TaskItemController controller;
  const SubtasksView({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _task = controller.task.value;
    return Obx(
      () {
        if (controller.loaded.isTrue) {
          return SmartRefresher(
            controller: controller.refreshController.value,
            onRefresh: () => controller.reloadTask(),
            child: ListView.separated(
              itemCount: _task.subtasks.length,
              padding: const EdgeInsets.symmetric(vertical: 6),
              separatorBuilder: (BuildContext context, int index) {
                return Divider(indent: 56, thickness: 1);
              },
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Row(
                    children: [
                      SizedBox(
                          width: 52,
                          child: Icon(
                              _task.subtasks[index].status == 2
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank_rounded,
                              color: Color(0xFF666666))),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_task.subtasks[index].title,
                                style: _task.subtasks[index].status == 2
                                    ? TextStyleHelper.subtitle1(
                                            color: const Color(0xff9C9C9C))
                                        .copyWith(
                                            decoration:
                                                TextDecoration.lineThrough)
                                    : TextStyleHelper.subtitle1()),
                            Text(
                                _task.subtasks[index].responsible
                                        ?.displayName ??
                                    'Nobody',
                                style: TextStyleHelper.caption(
                                    color: _task.subtasks[index].status == 2
                                        ? const Color(0xffc2c2c2)
                                        : Theme.of(context)
                                            .customColors()
                                            .onBackground
                                            .withOpacity(0.6))),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 52,
                        child: PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(child: Text('Accept task')),
                              PopupMenuItem(child: Text('Copy task')),
                              PopupMenuItem(child: Text('Delete task')),
                            ];
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}
