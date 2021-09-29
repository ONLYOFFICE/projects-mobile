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
        PlatformController platformController;

        try {
          platformController = Get.find<PlatformController>();
        } catch (e) {
          platformController = Get.put(PlatformController(), permanent: true);
        }

        if (platformController.isMobile) {
          return MobileLayout(pages: _pages);
        } else {
          return TabletLayout(tabletPages: _tabletPages);
        }
      },
    );
  }
}

class TabletLayout extends StatelessWidget {
  final Widget contentView;
  final tabletPages;
  const TabletLayout({Key key, this.contentView, this.tabletPages})
      : super(key: key);

  final double _iconSize = 34;

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NavigationController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          Container(
            color: Get.theme.colors().primarySurface,
            width: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 10),
                Obx(
                  () => Flexible(
                    child: NavigationRail(
                      selectedIndex: controller.tabIndex.value,
                      onDestinationSelected: (value) => {
                        if (controller.treeLength > 0)
                          {
                            for (var i = controller.treeLength; i > 0; i--)
                              {
                                Get.back(),
                              },
                            controller.treeLength = 0,
                          },
                        controller.changeTabletIndex(value),
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
                ),
                Container(
                  width: 80,
                  color: Get.theme.colors().primarySurface,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        iconSize: 64,
                        icon: SizedBox(
                            width: 72,
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: CircleAvatar(
                                radius: 40.0,
                                backgroundColor:
                                    Get.theme.colors().bgDescription,
                                child: ClipOval(
                                  child: Obx(() {
                                    return controller
                                        .selfUserItem.value.avatar.value;
                                  }),
                                ),
                              ),
                            )),
                        onPressed: () => controller
                            .toScreen(const SelfProfileScreen(), arguments: {
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
                        onPressed: () =>
                            controller.toScreen(const SettingsScreen()),
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
          Expanded(
            child: contentView ??
                Obx(() => tabletPages[controller.tabIndex.value]),
          ),
        ],
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  final pages;
  final double iconSize = 24;

  MobileLayout({
    Key key,
    @required this.pages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigationController = Get.find<NavigationController>();
    return Obx(
      () => Scaffold(
        body: pages[navigationController.tabIndex.value],
        bottomNavigationBar: SizedBox(
          height: navigationController.onMoreView ? 300 : 56,
          child: Column(
            children: [
              if (navigationController.onMoreView)
                const Expanded(child: MoreView()),
              BottomNavigationBar(
                unselectedItemColor:
                    Get.theme.colors().onNavBar.withOpacity(0.4),
                selectedItemColor: Get.theme.colors().onNavBar,
                onTap: navigationController.changeTabIndex,
                currentIndex: navigationController.onMoreView ||
                        navigationController.tabIndex.value > 3
                    ? 3
                    : navigationController.tabIndex.value,
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
      ),
    );
  }
}
