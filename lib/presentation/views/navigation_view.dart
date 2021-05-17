import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/dashboard/dashboard_view.dart';

import 'package:projects/presentation/views/projects_view/projects_view.dart';
import 'package:projects/presentation/views/task_view.dart';
import 'package:projects/presentation/views/tasks/tasks_view.dart';

class NavigationView extends StatelessWidget {
  NavigationView({Key key}) : super(key: key);
  final NavigationController controller = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      builder: (controller) {
        var _pages = [
          const DashboardView(),
          const TasksView(),
          const ProjectsView(),
          TaskView(),
        ];

        // The equivalent of the "smallestWidth" qualifier on Android.
        var shortestSide = MediaQuery.of(context).size.shortestSide;

        // Determine if we should use mobile layout or not, 600 here is
        // a common breakpoint for a typical 7-inch tablet.
        final useMobileLayout = shortestSide < 600;

        if (useMobileLayout) {
          return Scaffold(
            body: SafeArea(child: _pages[controller.tabIndex]),
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor:
                  Theme.of(context).customColors().inactiveTabTitle,
              selectedItemColor:
                  Theme.of(context).customColors().activeTabTitle,
              onTap: controller.changeTabIndex,
              currentIndex: controller.tabIndex,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor:
                  Theme.of(context).customColors().tabbarBackground,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: SVG
                      .create('lib/assets/images/icons/tab_bar/dashboard.svg'),
                  activeIcon: SVG.create(
                      'lib/assets/images/icons/tab_bar/dashboard_active.svg'),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: SVG.create('lib/assets/images/icons/tab_bar/tasks.svg'),
                  activeIcon: SVG.create(
                      'lib/assets/images/icons/tab_bar/tasks_active.svg'),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: SVG
                      .create('lib/assets/images/icons/tab_bar/projects.svg'),
                  activeIcon: SVG.create(
                      'lib/assets/images/icons/tab_bar/projects_active.svg'),
                  label: 'Projects',
                ),
                BottomNavigationBarItem(
                  icon: SVG.create('lib/assets/images/icons/tab_bar/more.svg'),
                  activeIcon: SVG.create(
                      'lib/assets/images/icons/tab_bar/more_active.svg'),
                  label: 'More',
                ),
              ],
            ),
          );
        } else {
          const _iconSize = 34.0;
          return Scaffold(
            body: Stack(
              children: [
                SizedBox(
                  width: 80,
                  child: NavigationRail(
                    selectedIndex: controller.tabIndex,
                    onDestinationSelected: controller.changeTabIndex,
                    destinations: [
                      NavigationRailDestination(
                          icon: AppIcon(
                              icon: SvgIcons.tab_bar_dashboard,
                              height: _iconSize),
                          selectedIcon: AppIcon(
                              icon: SvgIcons.tab_bar_dashboard_active,
                              height: _iconSize),
                          label: const Text('Dashboard')),
                      NavigationRailDestination(
                          icon: AppIcon(
                              icon: SvgIcons.tab_bar_tasks, height: _iconSize),
                          selectedIcon: AppIcon(
                              icon: SvgIcons.tab_bar_tasks_active,
                              height: _iconSize),
                          label: const Text('Tasks')),
                      NavigationRailDestination(
                          icon: AppIcon(
                              icon: SvgIcons.tab_bar_projects,
                              height: _iconSize),
                          selectedIcon: AppIcon(
                              icon: SvgIcons.tab_bar_projects_active,
                              height: _iconSize),
                          label: const Text('Projects')),
                      NavigationRailDestination(
                          icon: AppIcon(
                              icon: SvgIcons.tab_bar_more, height: _iconSize),
                          selectedIcon: AppIcon(
                              icon: SvgIcons.tab_bar_more_active,
                              height: _iconSize),
                          label: const Text('More')),
                    ],
                  ),
                ),
                // const VerticalDivider(thickness: 1, width: 1),
                Padding(
                    padding: const EdgeInsets.only(left: 81),
                    child: _pages[controller.tabIndex])
                // Expanded(child: _pages[controller.tabIndex]),
              ],
            ),
          );
        }
      },
    );
  }
}
