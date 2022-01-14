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
import 'package:projects/domain/controllers/tasks/subtasks/subtask_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_item.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtask_checkbox.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtask_detailed_view.dart';

class SubtaskCell extends StatelessWidget {
  final Subtask subtask;
  final PortalTask? parentTask;
  const SubtaskCell({
    Key? key,
    required this.subtask,
    required this.parentTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subtaskController = Get.put(
      SubtaskController(subtask: subtask, parentTask: parentTask),
      tag: subtask.hashCode.toString(),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: InkWell(
        onTap: () => Get.find<NavigationController>()
            .to(const SubtaskDetailedView(), arguments: {'controller': subtaskController}),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 6),
            Obx(
              () => Row(
                children: [
                  SubtaskCheckBox(subtaskController: subtaskController),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(subtask.title!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: subtaskController.subtask.value!.status == SubtaskStatus.CLOSED
                                ? TextStyleHelper.subtitle1(color: const Color(0xff9C9C9C))
                                    .copyWith(decoration: TextDecoration.lineThrough)
                                : TextStyleHelper.subtitle1()),
                        Text(
                            subtaskController.subtask.value!.responsible?.displayName ??
                                tr('nobody'),
                            style: TextStyleHelper.caption(
                                color:
                                    subtaskController.subtask.value!.status == SubtaskStatus.CLOSED
                                        ? const Color(0xffc2c2c2)
                                        : Get.theme.colors().onBackground.withOpacity(0.6))),
                      ],
                    ),
                  ),
                  if (subtaskController.subtask.value!.canEdit! ||
                      subtaskController.canCreateSubtask)
                    PlatformPopupMenuButton(
                      onSelected: (dynamic value) => _onSelected(context, value, subtaskController),
                      icon: Icon(PlatformIcons(context).ellipsis,
                          color: Get.theme.colors().onSurface.withOpacity(0.5)),
                      itemBuilder: (context) {
                        return [
                          if (subtaskController.canEdit &&
                              subtaskController.subtask.value!.responsible == null)
                            PlatformPopupMenuItem(
                                value: 'acceptSubtask',
                                child:
                                    Text(tr('acceptSubtask'), style: TextStyleHelper.subtitle1())),
                          if (subtaskController.canCreateSubtask &&
                              subtaskController.subtask.value!.status == SubtaskStatus.OPEN)
                            PlatformPopupMenuItem(
                                value: 'copySubtask',
                                child: Text(tr('copySubtask'), style: TextStyleHelper.subtitle1())),
                          if (subtask.canEdit!)
                            PlatformPopupMenuItem(
                              value: 'delete',
                              isDestructiveAction: true,
                              textStyle:
                                  TextStyleHelper.subtitle1(color: Get.theme.colors().colorError),
                              child: Text(tr('delete')),
                            )
                        ];
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Divider(indent: 72, thickness: 1, height: 1)
          ],
        ),
      ),
    );
  }
}

void _onSelected(BuildContext context, value, SubtaskController controller) async {
  print(value);
  switch (value) {
    case 'acceptSubtask':
      controller.acceptSubtask(
          taskId: controller.subtask.value!.taskId!, subtaskId: controller.subtask.value!.id!);
      break;
    case 'copySubtask':
      controller.copySubtask(context,
          taskId: controller.subtask.value!.taskId!, subtaskId: controller.subtask.value!.id!);
      break;
    case 'delete':
      controller.deleteSubtask(
        context: context,
        taskId: controller.subtask.value!.taskId!,
        subtaskId: controller.subtask.value!.id!,
      );
      break;
    default:
  }
}
