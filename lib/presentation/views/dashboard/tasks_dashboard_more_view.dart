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
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/search_button.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';
import 'package:projects/presentation/views/tasks/tasks_shared.dart';
import 'package:projects/presentation/views/tasks/tasks_view.dart';

class TasksDashboardMoreView extends StatelessWidget {
  const TasksDashboardMoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.arguments['controller'] as TasksController;

    return Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: Obx(
        () => Visibility(
          visible: controller.fabIsVisible.value,
          child: StyledFloatingActionButton(
            onPressed: () => Get.find<NavigationController>().toScreen(
              const NewTaskView(),
              arguments: {'projectDetailed': null},
              page: '/NewTaskView',
            ),
            child: AppIcon(
              icon: SvgIcons.add_fab,
              color: Theme.of(context).colors().onPrimarySurface,
            ),
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            MainAppBar(
              isCollapsed: true,
              cupertinoTitle: Text(
                controller.screenName,
                style: TextStyle(color: Theme.of(context).colors().onSurface),
              ),
              materialTitle: Text(
                controller.screenName,
                style: TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface),
              ),
              actions: [
                SearchButton(controller: controller),
                TasksMoreButtonWidget(controller: controller),
              ],
            ),
          ];
        },
        body: TasksContent(controller: controller),
      ),
    );
  }
}
