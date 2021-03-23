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
            backgroundColor: AppColors.primarySurface,
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
