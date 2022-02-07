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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/base_task_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/search_button.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_item.dart';
import 'package:projects/presentation/shared/wrappers/platform_widget.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';
import 'package:projects/presentation/views/project_detailed/project_detailed_view.dart';
import 'package:projects/presentation/views/tasks/tasks_shared.dart';

class TasksView extends StatelessWidget {
  const TasksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TasksController>(tag: 'TasksView');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Get.theme.backgroundColor,
      floatingActionButton: Obx(
        () => Visibility(
          visible: controller.fabIsVisible.value,
          child: StyledFloatingActionButton(
            onPressed: () => Get.find<NavigationController>().to(const NewTaskView(),
                arguments: {'projectDetailed': null},
                transition: Transition.cupertinoDialog,
                fullscreenDialog: true),
            child: AppIcon(
              icon: SvgIcons.add_fab,
              color: Get.theme.colors().onPrimarySurface,
            ),
          ),
        ),
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              MainAppBar(
                materialTitle: Text(
                  controller.screenName,
                  style: TextStyleHelper.headerStyle(color: Get.theme.colors().onSurface),
                ),
                cupertinoTitle: Text(
                  controller.screenName,
                  style: TextStyle(color: Get.theme.colors().onSurface),
                ),
                actions: [
                  SearchButton(controller: controller),
                  TasksFilterButton(controller: controller),
                  TasksMoreButtonWidget(controller: controller),
                ],
              ),
            ];
          },
          body: TasksContent(controller: controller)),
    );
  }
}

class TasksMoreButtonWidget extends StatelessWidget {
  const TasksMoreButtonWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return PlatformPopupMenuButton(
      padding: EdgeInsets.zero,
      icon: PlatformIconButton(
        padding: EdgeInsets.zero,
        cupertinoIcon: Icon(
          CupertinoIcons.ellipsis_circle,
          color: Get.theme.colors().primary,
        ),
        materialIcon: Icon(
          Icons.more_vert,
          color: Get.theme.colors().primary,
        ),
      ),
      onSelected: (String value) => _onSelected(value, controller, context),
      itemBuilder: (context) {
        return [
          PlatformPopupMenuItem(
            value: PopupMenuItemValue.sortTasks,
            child: TasksSortButton(controller: controller),
          ),
        ];
      },
    );
  }
}

Future<void> _onSelected(String value, BaseTasksController controller, BuildContext context) async {
  switch (value) {
    case PopupMenuItemValue.sortTasks:
      taskSortButtonOnPressed(controller, context);
      break;
  }
}
