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
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class SubtaskCell extends StatelessWidget {
  final Subtask subtask;
  const SubtaskCell({
    Key key,
    @required this.subtask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var subtaskController = Get.put(SubtaskController(subtask: subtask),
        tag: subtask.id.toString());

    return InkWell(
      onTap: () => Get.toNamed('SubtaskDetailedView',
          arguments: {'controller': subtaskController}),
      child: Row(
        children: [
          SizedBox(
              width: 52,
              child: Icon(
                  subtask.status == 2
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_rounded,
                  color: const Color(0xFF666666))),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtask.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: subtask.status == 2
                        ? TextStyleHelper.subtitle1(
                                color: const Color(0xff9C9C9C))
                            .copyWith(decoration: TextDecoration.lineThrough)
                        : TextStyleHelper.subtitle1()),
                Text(subtask.responsible?.displayName ?? 'Nobody',
                    style: TextStyleHelper.caption(
                        color: subtask.status == 2
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
              onSelected: (value) {
                print(subtaskController.subtask.value.title);
                _onSelected(value, subtaskController);
              },
              itemBuilder: (context) {
                return [
                  if (subtask.canEdit)
                    PopupMenuItem(
                        value: 'Accept subtask',
                        child: Text('Accept subtask',
                            style: TextStyleHelper.subtitle1())),
                  PopupMenuItem(
                      value: 'Copy subtask',
                      child: Text('Copy subtask',
                          style: TextStyleHelper.subtitle1())),
                  PopupMenuItem(
                      value: 'Delete',
                      child: Text('Delete',
                          style: TextStyleHelper.subtitle1(
                              color: Theme.of(context).customColors().error))),
                ];
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _onSelected(value, SubtaskController controller) async {
  print(value);
  switch (value) {
    case 'Delete':
      controller.deleteSubtask(
          taskId: controller.subtask.value.taskId,
          subtaskId: controller.subtask.value.id);
      break;
    default:
  }
}
