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
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/tasks/task_statuses_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/status_tile.dart';
import 'package:projects/presentation/views/tasks/task_cell/task_cell.dart';

void showsStatusesBS(
    {required BuildContext context, TaskItemController? taskItemController}) async {
  final _statusesController = Get.find<TaskStatusesController>();
  showCustomBottomSheet(
    context: context,
    headerHeight: 60,
    initHeight: _getInitialSize(statusCount: _statusesController.statuses.length),
    // maxHeight: 0.7,
    decoration: BoxDecoration(
        color: Get.theme.colors().surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
    headerBuilder: (context, bottomSheetOffset) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18.5),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(tr('selectStatus'),
                style: TextStyleHelper.h6(color: Get.theme.colors().onSurface)),
          ),
          const SizedBox(height: 18.5),
        ],
      );
    },
    builder: (context, bottomSheetOffset) {
      return SliverChildListDelegate(
        [
          Obx(
            () => DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1, color: Get.theme.colors().outline.withOpacity(0.5)),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  for (var i = 0; i < _statusesController.statuses.length; i++)
                    InkWell(
                      onTap: () async {
                        await taskItemController!.tryChangingStatus(
                            id: taskItemController.task.value.id!,
                            newStatusId: _statusesController.statuses[i].id!,
                            newStatusType: _statusesController.statuses[i].statusType!);
                        Get.back();
                      },
                      child: StatusTile(
                          title: _statusesController.statuses[i].title,
                          icon: StatusIcon(
                            canEditTask: taskItemController!.task.value.canEdit,
                            status: _statusesController.statuses[i],
                          ),
                          selected: _statusesController.statuses[i].title ==
                              taskItemController.status.value.title),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showsStatusesPM(
    {required BuildContext context, required TaskItemController taskItemController}) async {
  final _statusesController = Get.find<TaskStatusesController>();
  final items = <PopupMenuEntry<dynamic>>[
    for (var i = 0; i < _statusesController.statuses.length; i++)
      PopupMenuItem(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        onTap: () async {
          await taskItemController.tryChangingStatus(
              id: taskItemController.task.value.id!,
              newStatusId: _statusesController.statuses[i].id!,
              newStatusType: _statusesController.statuses[i].statusType!);
          Get.back();
        },
        child: StatusTileTablet(
            title: _statusesController.statuses[i].title!,
            icon: StatusIcon(
              canEditTask: taskItemController.task.value.canEdit,
              status: _statusesController.statuses[i],
            ),
            selected:
                _statusesController.statuses[i].title == taskItemController.status.value.title),
      ),
  ];

// calculate the menu position, ofsset dy: 50
  const offset = Offset(0, 50);
  final button = context.findRenderObject() as RenderBox;
  final overlay = Get.overlayContext!.findRenderObject() as RenderBox;
  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(
        offset,
        ancestor: overlay,
      ),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero) + offset,
        ancestor: overlay,
      ),
    ),
    Offset.zero & overlay.size,
  );

  await showMenu(context: context, position: position, items: items);
}

double _getInitialSize({required int statusCount}) {
  final size = (statusCount * 50 + 65) / Get.height;
  return size > 0.7 ? 0.7 : size;
}
