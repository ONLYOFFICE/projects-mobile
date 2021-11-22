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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_floating_action_button.dart';
import 'package:projects/presentation/views/new_task/new_task_view.dart';
import 'package:projects/presentation/views/tasks/task_cell/task_cell.dart';
import 'package:projects/presentation/views/tasks/tasks_view.dart';

class TasksDashboardMoreView extends StatelessWidget {
  const TasksDashboardMoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.arguments['controller'];

    var scrollController = ScrollController();
    var elevation = ValueNotifier<double>(0);

    scrollController.addListener(
        () => elevation.value = scrollController.offset > 2 ? 1 : 0);

    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      floatingActionButton: Obx(
        () => Visibility(
          visible: controller.fabIsVisible.value,
          child: StyledFloatingActionButton(
            onPressed: () => Get.find<NavigationController>()
                .to(const NewTaskView(), arguments: {'projectDetailed': null}),
            child: AppIcon(
              icon: SvgIcons.add_fab,
              color: Get.theme.colors().onPrimarySurface,
            ),
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 101),
        child: ValueListenableBuilder(
          valueListenable: elevation,
          builder: (_, dynamic value, __) => StyledAppBar(
            showBackButton: true,
            titleText: controller.screenName,
            elevation: value,
            actions: [
              IconButton(
                icon: AppIcon(
                  width: 24,
                  height: 24,
                  icon: SvgIcons.search,
                  color: Get.theme.colors().primary,
                ),
                onPressed: controller.showSearch,
              ),
              const SizedBox(width: 4),
            ],
            bottom: TasksHeader(controller: controller),
          ),
        ),
      ),
      body: Obx(
        () {
          if (controller.loaded.value == false)
            return const ListLoadingSkeleton();
          if (controller.loaded.value == true &&
              controller.paginationController.data.isEmpty &&
              !controller.filterController.hasFilters.value) {
            return Center(
                child: EmptyScreen(
                    icon: SvgIcons.task_not_created,
                    text: tr('noTasksCreated')));
          }
          if (controller.loaded.value == true &&
              controller.paginationController.data.isEmpty &&
              controller.filterController.hasFilters.value) {
            return Center(
              child: EmptyScreen(
                  icon: SvgIcons.not_found, text: tr('noTasksMatching')),
            );
          }
          return PaginationListView(
            paginationController: controller.paginationController,
            child: ListView.builder(
              // controller: controller.scrollController,
              controller: scrollController,
              itemCount: controller.paginationController.data.length,
              itemBuilder: (BuildContext context, int index) {
                return TaskCell(
                    task: controller.paginationController.data[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
