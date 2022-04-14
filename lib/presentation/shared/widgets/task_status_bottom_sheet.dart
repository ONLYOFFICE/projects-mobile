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
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_item.dart';
import 'package:projects/presentation/views/tasks/task_cell/task_cell.dart';

void showsStatusesBS({
  required BuildContext context,
  required TaskItemController taskItemController,
}) {
  final _statusesController = Get.find<TaskStatusesController>();
  showCustomBottomSheet(
    context: context,
    headerHeight: 60,
    initHeight: _getInitialSize(statusCount: _statusesController.statuses.length),
    decoration: BoxDecoration(
        color: Get.theme.colors().surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
    headerBuilder: (context, bottomSheetOffset) {
      return Container(
        decoration: BoxDecoration(
            color: Get.theme.colors().surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(tr('selectStatus'),
                  style: TextStyleHelper.headline6(color: Get.theme.colors().onSurface)),
            ),
          ],
        ),
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
                        await taskItemController.tryChangingStatus(
                            id: taskItemController.task.value.id!,
                            newStatusId: _statusesController.statuses[i].id!,
                            newStatusType: _statusesController.statuses[i].statusType!);
                        Get.back();
                      },
                      child: StatusTile(
                          title: _statusesController.statuses[i].title!,
                          icon: StatusIcon(
                            canEditTask: taskItemController.task.value.canEdit!,
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

void showsStatusesPM({
  required BuildContext context,
  required TaskItemController taskItemController,
}) {
  final _statusesController = Get.find<TaskStatusesController>();

  showButtonMenu(
      context: context,
      itemBuilder: (_) {
        return [
          for (var i = 0; i < _statusesController.statuses.length; i++)
            PlatformPopupMenuItem(
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
                    canEditTask: taskItemController.task.value.canEdit!,
                    status: _statusesController.statuses[i],
                  ),
                  selected: _statusesController.statuses[i].title ==
                      taskItemController.status.value.title),
            ),
        ];
      });
}

double _getInitialSize({required int statusCount}) {
  final size = (statusCount * 50 + 65) / Get.height;
  return size > 0.7 ? 0.7 : size;
}
