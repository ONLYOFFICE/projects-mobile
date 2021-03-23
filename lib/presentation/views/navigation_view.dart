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
import 'package:projects/presentation/shared/app_colors.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/views/dashboard/dashboard_view.dart';

import 'package:projects/presentation/views/projects_view/projects_view.dart';
import 'package:projects/presentation/views/task_view.dart';
import 'package:projects/presentation/views/tasks/tasks_view.dart';

class NavigationView extends StatelessWidget {
  final NavigationController controller = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: [
                DashboardView(),
                TasksView(),
                ProjectsView(),
                TaskView(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: AppColors.tabSecondary,
            selectedItemColor: AppColors.tabActive,
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.lightSecondary,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon:
                    SVG.create('lib/assets/images/icons/tab_bar/dashboard.svg'),
                activeIcon: SVG.create(
                    'lib/assets/images/icons/tab_bar/dashboard_active.svg'),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: SVG.create('lib/assets/images/icons/tab_bar/tasks.svg'),
                activeIcon: SVG
                    .create('lib/assets/images/icons/tab_bar/tasks_active.svg'),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon:
                    SVG.create('lib/assets/images/icons/tab_bar/projects.svg'),
                activeIcon: SVG.create(
                    'lib/assets/images/icons/tab_bar/projects_active.svg'),
                label: 'Projects',
              ),
              BottomNavigationBarItem(
                icon: SVG.create('lib/assets/images/icons/tab_bar/more.svg'),
                activeIcon: SVG
                    .create('lib/assets/images/icons/tab_bar/more_active.svg'),
                label: 'More',
              ),
            ],
          ),
        );
      },
    );
  }
}
