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
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/dashboard/dashboard_view.dart';
import 'package:projects/presentation/views/discussions/discussions_view.dart';
import 'package:projects/presentation/views/documents/documents_view.dart';
import 'package:projects/presentation/views/more/more_view.dart';
import 'package:projects/presentation/views/profile/profile_screen.dart';

import 'package:projects/presentation/views/projects_view/projects_view.dart';
import 'package:projects/presentation/views/settings/settings_screen.dart';
import 'package:projects/presentation/views/tasks/tasks_view.dart';

class NavigationView extends StatelessWidget {
  NavigationView({Key key}) : super(key: key);

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

    var _tabletPages = [
      const DashboardView(),
      const TasksView(),
      const ProjectsView(),
      const PortalDiscussionsView(),
      const PortalDocumentsView(),
      const SelfProfileScreen(),
      const SettingsScreen(),
      const MoreView(),
    ];

    return GetBuilder<NavigationController>(
      builder: (controller) {
        if (Get.put(PlatformController()).isMobile) {
          const _iconSize = 24.0;
          return MobileLayout(
            controller: controller,
            pages: _pages,
            iconSize: _iconSize,
          );
        } else {
          return TabletLayout(contentView: _tabletPages[controller.tabIndex]);
        }
      },
    );
  }
}

class TabletLayout extends StatelessWidget {
  final Widget contentView;
  const TabletLayout({Key key, @required this.contentView}) : super(key: key);

  final double _iconSize = 34;

  @override
  Widget build(BuildContext context) {
    var navigationController = Get.find<NavigationController>();

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: NavigationRail(
                      selectedIndex: navigationController.tabIndex,
                      onDestinationSelected: (value) => {
                        if (Get.routing.current != '/' &&
                            Get.routing.current != '/NavigationView' &&
                            Get.routing.current != 'NavigationView')
                          Get.to(() => NavigationView(),
                              transition: Transition.noTransition),
                        Get.find<NavigationController>()
                            .changeTabletIndex(value),
                      },
                      destinations: [
                        NavigationRailDestination(
                            icon: AppIcon(
                                icon: SvgIcons.tab_bar_dashboard,
                                color: Get.theme
                                    .colors()
                                    .onNavBar
                                    .withOpacity(0.4),
                                height: _iconSize),
                            selectedIcon: AppIcon(
                                icon: SvgIcons.tab_bar_dashboard,
                                color: Get.theme.colors().onNavBar,
                                height: _iconSize),
                            label: Text(tr('dashboard'))),
                        NavigationRailDestination(
                            icon: AppIcon(
                                icon: SvgIcons.tab_bar_tasks,
                                color: Get.theme
                                    .colors()
                                    .onNavBar
                                    .withOpacity(0.4),
                                height: _iconSize),
                            selectedIcon: AppIcon(
                                icon: SvgIcons.tab_bar_tasks,
                                color: Get.theme.colors().onNavBar,
                                height: _iconSize),
                            label: Text(tr('tasks'))),
                        NavigationRailDestination(
                            icon: AppIcon(
                                icon: SvgIcons.tab_bar_projects,
                                color: Get.theme
                                    .colors()
                                    .onNavBar
                                    .withOpacity(0.4),
                                height: _iconSize),
                            selectedIcon: AppIcon(
                                icon: SvgIcons.tab_bar_projects,
                                color: Get.theme.colors().onNavBar,
                                height: _iconSize),
                            label: Text(tr('projects'))),
                        NavigationRailDestination(
                            icon: AppIcon(
                                icon: SvgIcons.discussions,
                                color: Get.theme
                                    .colors()
                                    .onNavBar
                                    .withOpacity(0.4),
                                height: _iconSize),
                            selectedIcon: AppIcon(
                                icon: SvgIcons.discussions,
                                color: Get.theme.colors().onNavBar,
                                height: _iconSize),
                            label: Text(tr('discussions'))),
                        NavigationRailDestination(
                            icon: AppIcon(
                                icon: SvgIcons.documents,
                                color: Get.theme
                                    .colors()
                                    .onNavBar
                                    .withOpacity(0.4),
                                height: _iconSize),
                            selectedIcon: AppIcon(
                                icon: SvgIcons.documents,
                                color: Get.theme.colors().onNavBar,
                                height: _iconSize),
                            label: Text(tr('documents'))),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    color: Get.theme.colors().primarySurface,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          iconSize: 64,
                          icon: AppIcon(
                            icon: SvgIcons.avatar,
                            width: 40,
                            height: 40,
                          ),
                          onPressed: () => Get.find<NavigationController>()
                              .showScreen(const SelfProfileScreen(),
                                  arguments: {
                                'showBackButton': true,
                                'showSettingsButton': false
                              }),
                        ),
                        IconButton(
                          iconSize: 64,
                          icon: AppIcon(
                            icon: SvgIcons.settings,
                            width: 24,
                            height: 24,
                            color: Get.theme.colors().onNavBar.withOpacity(0.4),
                          ),
                          onPressed: () => Get.find<NavigationController>()
                              .showScreen(const SettingsScreen()),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: contentView),
          ],
        ),
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  final controller;
  final List<StatelessWidget> pages;
  final double iconSize;
  final navigatorKey = GlobalKey<NavigatorState>();

  MobileLayout({
    Key key,
    @required this.pages,
    @required this.iconSize,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[controller.tabIndex],
      bottomNavigationBar: SizedBox(
        height: controller.onMoreView ? 300 : 56,
        child: Column(
          children: [
            if (controller.onMoreView) const Expanded(child: MoreView()),
            BottomNavigationBar(
              unselectedItemColor: Get.theme.colors().onNavBar.withOpacity(0.4),
              selectedItemColor: Get.theme.colors().onNavBar,
              onTap: controller.changeTabIndex,
              currentIndex: controller.onMoreView || controller.tabIndex > 3
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
                      height: iconSize),
                  activeIcon: AppIcon(
                      icon: SvgIcons.tab_bar_dashboard,
                      color: Get.theme.colors().onNavBar,
                      height: iconSize),
                  label: tr('dashboard'),
                ),
                BottomNavigationBarItem(
                  icon: AppIcon(
                      icon: SvgIcons.tab_bar_tasks,
                      color: Get.theme.colors().onNavBar.withOpacity(0.4),
                      height: iconSize),
                  activeIcon: AppIcon(
                      icon: SvgIcons.tab_bar_tasks,
                      color: Get.theme.colors().onNavBar,
                      height: iconSize),
                  label: tr('tasks'),
                ),
                BottomNavigationBarItem(
                  icon: AppIcon(
                      icon: SvgIcons.tab_bar_projects,
                      color: Get.theme.colors().onNavBar.withOpacity(0.4),
                      height: iconSize),
                  activeIcon: AppIcon(
                      icon: SvgIcons.tab_bar_projects,
                      color: Get.theme.colors().onNavBar,
                      height: iconSize),
                  label: tr('projects'),
                ),
                BottomNavigationBarItem(
                  icon: AppIcon(
                      icon: SvgIcons.tab_bar_more,
                      color: Get.theme.colors().onNavBar.withOpacity(0.4),
                      height: iconSize),
                  activeIcon: AppIcon(
                      icon: SvgIcons.tab_bar_more,
                      color: Get.theme.colors().onNavBar,
                      height: iconSize),
                  label: tr('more'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
