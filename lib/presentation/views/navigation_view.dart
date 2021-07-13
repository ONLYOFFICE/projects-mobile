import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/dashboard/dashboard_view.dart';
import 'package:projects/presentation/views/discussions/discussions_view.dart';
import 'package:projects/presentation/views/documents/documents_view.dart';
import 'package:projects/presentation/views/more/more_view.dart';
import 'package:projects/presentation/views/profile/profile_screen.dart';

import 'package:projects/presentation/views/projects_view/projects_view.dart';
import 'package:projects/presentation/views/tasks/tasks_view.dart';

class NavigationView extends StatelessWidget {
  NavigationView({Key key}) : super(key: key);
  final NavigationController controller = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    var _pages = [
      const DashboardView(),
      const TasksView(),
      const ProjectsView(),
      const MoreView(),
      const SelfProfileScreen(),
      const PortalDiscussionsView(),
      const PortalDocumentsView(),
    ];

    return GetBuilder<NavigationController>(
      builder: (controller) {
        // The equivalent of the "smallestWidth" qualifier on Android.
        var shortestSide = MediaQuery.of(context).size.shortestSide;

        // Determine if we should use mobile layout or not, 600 here is
        // a common breakpoint for a typical 7-inch tablet.
        final useMobileLayout = shortestSide < 600;

        if (useMobileLayout) {
          const _iconSize = 24.0;
          return Scaffold(
            body: _pages[controller.tabIndex],
            bottomNavigationBar: SizedBox(
              height: controller.onMoreView ? 300 : 56,
              child: Column(
                children: [
                  if (controller.onMoreView) const Expanded(child: MoreView()),
                  BottomNavigationBar(
                    unselectedItemColor:
                        Get.theme.colors().onNavBar.withOpacity(0.4),
                    selectedItemColor: Get.theme.colors().onNavBar,
                    onTap: controller.changeTabIndex,
                    currentIndex:
                        controller.onMoreView || controller.tabIndex > 3
                            ? 3
                            : controller.tabIndex,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Get.theme.colors().primarySurface,
                    elevation: 0,
                    items: [
                      BottomNavigationBarItem(
                        icon: AppIcon(
                            icon: SvgIcons.tab_bar_dashboard,
                            color: Get.theme.colors().onNavBar.withOpacity(0.4),
                            height: _iconSize),
                        activeIcon: AppIcon(
                            icon: SvgIcons.tab_bar_dashboard,
                            color: Get.theme.colors().onNavBar,
                            height: _iconSize),
                        label: tr('dashboard'),
                      ),
                      BottomNavigationBarItem(
                        icon: AppIcon(
                            icon: SvgIcons.tab_bar_tasks,
                            color: Get.theme.colors().onNavBar.withOpacity(0.4),
                            height: _iconSize),
                        activeIcon: AppIcon(
                            icon: SvgIcons.tab_bar_tasks,
                            color: Get.theme.colors().onNavBar,
                            height: _iconSize),
                        label: tr('tasks'),
                      ),
                      BottomNavigationBarItem(
                        icon: AppIcon(
                            icon: SvgIcons.tab_bar_projects,
                            color: Get.theme.colors().onNavBar.withOpacity(0.4),
                            height: _iconSize),
                        activeIcon: AppIcon(
                            icon: SvgIcons.tab_bar_projects,
                            color: Get.theme.colors().onNavBar,
                            height: _iconSize),
                        label: tr('projects'),
                      ),
                      BottomNavigationBarItem(
                        icon: AppIcon(
                            icon: SvgIcons.tab_bar_more,
                            color: Get.theme.colors().onNavBar.withOpacity(0.4),
                            height: _iconSize),
                        activeIcon: AppIcon(
                            icon: SvgIcons.tab_bar_more,
                            color: Get.theme.colors().onNavBar,
                            height: _iconSize),
                        label: tr('more'),
                      ),
                    ],
                  ),
                ],
              ),
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
                    selectedIndex:
                        controller.onMoreView || controller.tabIndex > 3
                            ? 3
                            : controller.tabIndex,
                    onDestinationSelected: controller.changeTabIndex,
                    destinations: [
                      NavigationRailDestination(
                          icon: AppIcon(
                              icon: SvgIcons.tab_bar_dashboard,
                              color:
                                  Get.theme.colors().onNavBar.withOpacity(0.4),
                              height: _iconSize),
                          selectedIcon: AppIcon(
                              icon: SvgIcons.tab_bar_dashboard,
                              color: Get.theme.colors().onNavBar,
                              height: _iconSize),
                          label: Text(tr('dashboard'))),
                      NavigationRailDestination(
                          icon: AppIcon(
                              icon: SvgIcons.tab_bar_tasks,
                              color:
                                  Get.theme.colors().onNavBar.withOpacity(0.4),
                              height: _iconSize),
                          selectedIcon: AppIcon(
                              icon: SvgIcons.tab_bar_tasks,
                              color: Get.theme.colors().onNavBar,
                              height: _iconSize),
                          label: Text(tr('tasks'))),
                      NavigationRailDestination(
                          icon: AppIcon(
                              icon: SvgIcons.tab_bar_projects,
                              color:
                                  Get.theme.colors().onNavBar.withOpacity(0.4),
                              height: _iconSize),
                          selectedIcon: AppIcon(
                              icon: SvgIcons.tab_bar_projects,
                              color: Get.theme.colors().onNavBar,
                              height: _iconSize),
                          label: Text(tr('projects'))),
                      NavigationRailDestination(
                          icon: AppIcon(
                              icon: SvgIcons.tab_bar_more,
                              color:
                                  Get.theme.colors().onNavBar.withOpacity(0.4),
                              height: _iconSize),
                          selectedIcon: AppIcon(
                              icon: SvgIcons.tab_bar_more,
                              color: Get.theme.colors().onNavBar,
                              height: _iconSize),
                          label: Text(tr('more'))),
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
