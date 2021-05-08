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
import 'package:projects/domain/controllers/tasks/subtasks/new_subtask_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';
import 'package:projects/presentation/views/new_task/tiles/responsible_tile.dart';

class NewSubtaskView extends StatelessWidget {
  const NewSubtaskView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(NewSubtaskController());
    controller.init();

    int taskId = Get.arguments['taskId'];

    return Scaffold(
      appBar: StyledAppBar(
        titleText: 'Add subtask',
        onLeadingPressed: controller.leaveNewSubtaskPage,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded),
            onPressed: () =>
                controller.confirmSubtask(context: context, taskId: taskId),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 6),
            Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 56),
                  child: Row(
                    children: [
                      const SizedBox(
                          width: 56,
                          child: Icon(Icons.check_box_outline_blank,
                              color: Color(0xFF666666))),
                      Expanded(
                        child: Center(
                          child: Obx(() => TextField(
                                controller: controller.titleController,
                                maxLines: null,
                                autofocus: true,
                                style: TextStyleHelper.subtitle1(
                                    color: Theme.of(context)
                                        .customColors()
                                        .onBackground),
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Describe subtask...',
                                  hintStyle: TextStyleHelper.subtitle1(
                                      color: controller.setTiltleError.isTrue
                                          ? Theme.of(context)
                                              .customColors()
                                              .error
                                          : Theme.of(context)
                                              .customColors()
                                              .onBackground
                                              .withOpacity(0.5)),
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const StyledDivider(leftPadding: 56)
              ],
            ),
            ResponsibleTile(
              controller: controller,
              enableUnderline: false,
              suffixIcon: IconButton(
                icon: Icon(Icons.clear_rounded,
                    size: 20,
                    color: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.6)),
                onPressed: controller.clearResponsibles,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
