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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/context_menu/platform_context_menu_button.dart';
import 'package:projects/presentation/shared/widgets/context_menu/platform_context_menu_item.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/creating_and_editing_subtask_view.dart';
import 'package:projects/presentation/views/task_detailed/subtasks/subtask_checkbox.dart';

class SubtaskDetailedView extends StatelessWidget {
  const SubtaskDetailedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final controller = args['controller'] as SubtaskController;
    final previousPage = args['previousPage'] as String?;

    return Obx(
      () {
        final _subtask = controller.subtask.value!;
        return Scaffold(
          appBar: StyledAppBar(
            previousPageTitle: previousPage,
            actions: [
              if (_subtask.canEdit! || controller.canCreateSubtask)
                PlatformPopupMenuButton(
                  padding: GetPlatform.isIOS ? const EdgeInsets.only(right: 6) : EdgeInsets.zero,
                  icon: PlatformIconButton(
                    padding: EdgeInsets.zero,
                    cupertinoIcon: Icon(
                      CupertinoIcons.ellipsis_circle,
                      color: Theme.of(context).colors().primary,
                    ),
                    materialIcon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colors().primary,
                    ),
                  ),
                  onSelected: (dynamic value) => _onSelected(context, value, controller),
                  itemBuilder: (context) {
                    return [
                      if (controller.canEdit && _subtask.responsible == null)
                        PlatformPopupMenuItem(
                          value: 'accept',
                          child: Text(tr('acceptSubtask')),
                        ),
                      if (controller.canEdit)
                        PlatformPopupMenuItem(
                          value: 'edit',
                          child: Text(tr('edit')),
                        ),
                      if (controller.canCreateSubtask)
                        PlatformPopupMenuItem(
                          value: 'copy',
                          child: Text(tr('copy')),
                        ),
                      if (_subtask.canEdit!)
                        PlatformPopupMenuItem(
                          value: 'delete',
                          isDestructiveAction: true,
                          child: Text(
                            tr('delete'),
                            style: TextStyleHelper.subtitle1(
                                color: Theme.of(context).colors().colorError),
                          ),
                        ),
                    ];
                  },
                )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SubtaskCheckBox(subtaskController: controller),
                        Obx(() => Expanded(
                              child: Text(_subtask.title!,
                                  style: controller.subtask.value!.status == 2
                                      ? TextStyleHelper.subtitle1(color: const Color(0xff9C9C9C))
                                          .copyWith(decoration: TextDecoration.lineThrough)
                                      : TextStyleHelper.subtitle1()),
                            )),
                        const SizedBox(width: 4),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const StyledDivider(leftPadding: 72)
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                        width: 72,
                        child: AppIcon(
                            icon: SvgIcons.person,
                            color: Theme.of(context).colors().onSurface.withOpacity(0.6))),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tr('assignedTo'),
                              style: TextStyleHelper.caption(
                                  color:
                                      Theme.of(context).colors().onBackground.withOpacity(0.75))),
                          Text(
                            _subtask.responsible?.displayName ?? tr('noResponsible'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleHelper.subtitle1(
                                color: Theme.of(context).colors().onSurface),
                          ),
                        ],
                      ),
                    ),
                    if (_subtask.responsible != null && controller.canEdit && _subtask.status != 2)
                      PlatformIconButton(
                        icon: Icon(PlatformIcons(context).clear,
                            color: Theme.of(context).colors().onSurface.withOpacity(0.6)),
                        onPressed: () => controller.deleteSubtaskResponsible(
                            taskId: _subtask.taskId!, subtaskId: _subtask.id!),
                      )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

void _onSelected(BuildContext context, value, SubtaskController controller) {
  switch (value) {
    case 'accept':
      controller.acceptSubtask(
        taskId: controller.subtask.value!.taskId!,
        subtaskId: controller.subtask.value!.id!,
      );
      break;
    case 'edit':
      Get.find<NavigationController>().toScreen(
        const CreatingAndEditingSubtaskView(),
        arguments: {
          'taskId': controller.subtask.value!.taskId,
          'projectId': controller.parentTask.projectOwner!.id,
          'forEditing': true,
          'itemController': controller,
        },
        transition: Transition.cupertinoDialog,
        fullscreenDialog: true,
        page: '/CreatingAndEditingSubtaskView',
      );
      break;
    case 'copy':
      controller.copySubtask(
        context,
        taskId: controller.subtask.value!.taskId!,
        subtaskId: controller.subtask.value!.id!,
      );
      break;
    case 'delete':
      controller.deleteSubtask(
        context: context,
        taskId: controller.subtask.value!.taskId!,
        subtaskId: controller.subtask.value!.id!,
        closePage: true,
      );
      break;
    default:
  }
}
