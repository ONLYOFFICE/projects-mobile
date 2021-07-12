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
                        Theme.of(context).customColors().inactiveTabTitle,
                    selectedItemColor:
                        Theme.of(context).customColors().activeTabTitle,
                    onTap: controller.changeTabIndex,
                    currentIndex:
                        controller.onMoreView || controller.tabIndex > 3
                            ? 3
                            : controller.tabIndex,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    type: BottomNavigationBarType.fixed,
                    backgroundColor:
                        Theme.of(context).customColors().primarySurface,
                    elevation: 0,
                    items: [
                      BottomNavigationBarItem(
                        icon: AppIcon(
                            icon: SvgIcons.tab_bar_dashboard,
                            color: Theme.of(context)
                                .customColors()
                                .onNavBar
                                .withOpacity(0.4),
                            height: _iconSize),
                        activeIcon: AppIcon(
                            icon: SvgIcons.tab_bar_dashboard,
                            color: Theme.of(context).customColors().onNavBar,
                            height: _iconSize),
                        label: tr('dashboard'),
                      ),
                      BottomNavigationBarItem(
                        icon: AppIcon(
                            icon: SvgIcons.tab_bar_tasks,
                            color: Theme.of(context)
                                .customColors()
                                .onNavBar
                                .withOpacity(0.4),
                            height: _iconSize),
                        activeIcon: AppIcon(
                            icon: SvgIcons.tab_bar_tasks,
                            color: Theme.of(context).customColors().onNavBar,
                            height: _iconSize),
                        label: tr('tasks'),
                      ),
                      BottomNavigationBarItem(
                        icon: AppIcon(
                            icon: SvgIcons.tab_bar_projects,
                            color: Theme.of(context)
                                .customColors()
                                .onNavBar
                                .withOpacity(0.4),
                            height: _iconSize),
                        activeIcon: AppIcon(
                            icon: SvgIcons.tab_bar_projects,
                            color: Theme.of(context).customColors().onNavBar,
                            height: _iconSize),
                        label: tr('projects'),
                      ),
                      BottomNavigationBarItem(
                        icon: AppIcon(
                            icon: SvgIcons.tab_bar_more,
                            color: Theme.of(context)
                                .customColors()
                                .onNavBar
                                .withOpacity(0.4),
                            height: _iconSize),
                        activeIcon: AppIcon(
                            icon: SvgIcons.tab_bar_more,
                            color: Theme.of(context).customColors().onNavBar,
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
                              color: Theme.of(context)
                                  .customColors()
                                  .onNavBar
                                  .withOpacity(0.4),
                              height: _iconSize),
                          selectedIcon: AppIcon(
                              icon: SvgIcons.tab_bar_dashboard,
                              color: Theme.of(context).customColors().onNavBar,
                              height: _iconSize),
                          label: Text(tr('dashboard'))),
                      NavigationRailDestination(
                          icon: AppIcon(
                              icon: SvgIcons.tab_bar_tasks,
                              color: Theme.of(context)
                                  .customColors()
                                  .onNavBar
                                  .withOpacity(0.4),
                              height: _iconSize),
                          selectedIcon: AppIcon(
                              icon: SvgIcons.tab_bar_tasks,
                              color: Theme.of(context).customColors().onNavBar,
                              height: _iconSize),
                          label: Text(tr('tasks'))),
                      NavigationRailDestination(
                          icon: AppIcon(
                              icon: SvgIcons.tab_bar_projects,
                              color: Theme.of(context)
                                  .customColors()
                                  .onNavBar
                                  .withOpacity(0.4),
                              height: _iconSize),
                          selectedIcon: AppIcon(
                              icon: SvgIcons.tab_bar_projects,
                              color: Theme.of(context).customColors().onNavBar,
                              height: _iconSize),
                          label: Text(tr('projects'))),
                      NavigationRailDestination(
                          icon: AppIcon(
                              icon: SvgIcons.tab_bar_more,
                              color: Theme.of(context)
                                  .customColors()
                                  .onNavBar
                                  .withOpacity(0.4),
                              height: _iconSize),
                          selectedIcon: AppIcon(
                              icon: SvgIcons.tab_bar_more,
                              color: Theme.of(context).customColors().onNavBar,
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
