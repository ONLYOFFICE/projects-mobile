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
import 'package:projects/domain/controllers/tasks/subtasks/new_subtask_controller.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_action_controller.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_controller.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_editing_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/views/new_task/tiles/responsible_tile.dart';

class CreatingAndEditingSubtaskView extends StatelessWidget {
  const CreatingAndEditingSubtaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forEditing = Get.arguments['forEditing'] as bool;

    SubtaskActionController controller;
    int? taskId;
    final projectId = Get.arguments['projectId'] as int?;

    if (forEditing) {
      final itemController = Get.arguments['itemController'] as SubtaskController;
      controller = Get.put(SubtaskEditingController(itemController));
      controller.init(subtask: itemController.subtask.value, projectId: projectId);
    } else {
      taskId = Get.arguments['taskId'] as int;
      controller = Get.put(NewSubtaskController());
      controller.init(projectId: projectId);
    }

    return WillPopScope(
      onWillPop: () async {
        controller.leavePage();
        return false;
      },
      child: Scaffold(
        appBar: StyledAppBar(
          titleText: forEditing ? tr('editSubtask') : tr('addSubtask'),
          onLeadingPressed: controller.leavePage,
          actions: [
            PlatformIconButton(
              icon: Icon(PlatformIcons(context).checkMark),
              onPressed: () =>
                  controller.confirm(context: context, taskId: taskId ?? -1), // TODO FIX
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
                        SizedBox(
                          width: 56,
                          child: Icon(
                            controller.status!.value == 1
                                ? Icons.check_box_outline_blank
                                : Icons.check_box,
                            color: const Color(0xFF666666),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Obx(() => TextField(
                                  controller: controller.titleController,
                                  maxLines: null,
                                  // focusNode = null if subtaskEditingController
                                  focusNode: controller.titleFocus,
                                  style: TextStyleHelper.subtitle1(
                                      color: Get.theme.colors().onBackground),
                                  decoration: InputDecoration.collapsed(
                                    hintText: tr('describeSubtask'),
                                    hintStyle: TextStyleHelper.subtitle1(
                                        color: controller.setTiltleError!.value == true
                                            ? Get.theme.colors().colorError
                                            : Get.theme.colors().onBackground.withOpacity(0.5)),
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
              Listener(
                onPointerDown: (_) {
                  if (!forEditing) {
                    if (controller.titleController.text.isNotEmpty &&
                        controller.titleFocus!.hasFocus) controller.titleFocus!.unfocus();
                  }
                },
                child: ResponsibleTile(
                  controller: controller,
                  enableUnderline: false,
                  suffixIcon: PlatformIconButton(
                    icon: Icon(PlatformIcons(context).clear,
                        size: 20, color: Get.theme.colors().onSurface.withOpacity(0.6)),
                    onPressed: controller.deleteResponsible,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
