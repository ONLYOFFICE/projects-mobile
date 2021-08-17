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
import 'package:projects/domain/controllers/tasks/task_editing_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/new_task/tiles/description_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/due_date_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/milestone_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/priority_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/responsible_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/start_date_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/task_title.dart';
import 'package:projects/presentation/views/task_editing_view/elements/status_selection_bottom_sheet.dart';

class TaskEditingView extends StatelessWidget {
  const TaskEditingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PortalTask task = Get.arguments['task'];

    var controller = Get.put(TaskEditingController(task: task));
    controller.init();
    return Scaffold(
      appBar: StyledAppBar(
        titleText: tr('editTask'),
        onLeadingPressed: controller.discardChanges,
        actions: [
          IconButton(
              icon: const Icon(Icons.done_rounded),
              onPressed: () => controller.confirm())
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            TaskTitle(
                controller: controller, showCaption: true, focusOnTitle: false),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.only(left: 72, right: 16),
              child: OutlinedButton(
                onPressed: () =>
                    statusSelectionBS(context: context, controller: controller),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((_) {
                    return const Color(0xff81C4FF).withOpacity(0.1);
                  }),
                  side: MaterialStateProperty.resolveWith((_) {
                    return const BorderSide(
                        color: Color(0xff0C76D5), width: 1.5);
                  }),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Obx(() => Text(
                                controller.newStatus.value.title,
                                style: TextStyleHelper.subtitle2())))),
                    const Icon(Icons.arrow_drop_down_sharp)
                  ],
                ),
              ),
            ),
            DescriptionTile(controller: controller),
            MilestoneTile(controller: controller),
            StartDateTile(controller: controller),
            DueDateTile(controller: controller),
            PriorityTile(controller: controller),
            ResponsibleTile(controller: controller, enableUnderline: false)
          ],
        ),
      ),
    );
  }
}
