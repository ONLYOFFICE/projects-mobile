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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/dashboard_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_filter_controller.dart';
import 'package:projects/domain/controllers/documents/documents_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/profile_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/domain/controllers/tasks/tasks_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/views/dashboard/dashboard_view.dart';
import 'package:projects/presentation/views/discussions/discussions_view.dart';
import 'package:projects/presentation/views/documents/documents_view.dart';
import 'package:projects/presentation/views/more/more_view.dart';
import 'package:projects/presentation/views/profile/profile_screen.dart';
import 'package:projects/presentation/views/projects_view/projects_view.dart';
import 'package:projects/presentation/views/settings/settings_screen.dart';
import 'package:projects/presentation/views/tasks/tasks_view.dart';

class NavigationView extends StatelessWidget {
  NavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setupControllers();

    final platformController = Get.find<PlatformController>();

    return GetBuilder<NavigationController>(
      builder: (controller) {
        if (platformController.isMobile) {
          //TODO: navigation on more screen is brocken if return premade instance
          return MobileLayout();
        } else {
          return TabletLayout();
        }
      },
    );
  }

  void setupControllers() {
    Get.find<UserController>().updateData();

    if (!Get.isRegistered<PlatformController>()) Get.put(PlatformController(), permanent: true);

    if (!Get.isRegistered<DashboardController>(tag: 'DashboardController')) {
      Get.put(DashboardController(), tag: 'DashboardController')
        ..setup()
        ..loadContent();
    }

    if (!Get.isRegistered<TasksController>(tag: 'TasksView')) {
      Get.put(TasksController(), tag: 'TasksView')
        ..setup(PresetTaskFilters.saved)
        ..loadTasks();
    }

    if (!Get.isRegistered<ProjectsController>(tag: 'ProjectsView')) {
      Get.put(ProjectsController(), tag: 'ProjectsView')
        ..setup(PresetProjectFilters.saved)
        ..loadProjects();
    }

    if (!Get.isRegistered<DiscussionsController>(tag: 'DiscussionsView')) {
      Get.put(DiscussionsController(), tag: 'DiscussionsView')
          .loadDiscussions(preset: PresetDiscussionFilters.saved);
    }

    if (!Get.isRegistered<DocumentsController>(tag: 'DocumentsView')) {
      Get.put(DocumentsController(), tag: 'DocumentsView').initialSetup();
    }

    if (!Get.isRegistered<ProfileController>(tag: 'SelfProfileScreen')) {
      Get.put(ProfileController(), tag: 'SelfProfileScreen').setup();
    }
  }
}

class TabletLayout extends StatelessWidget {
  final Widget? contentView;

  TabletLayout({Key? key, this.contentView}) : super(key: key);

  final double _iconSize = 34;

  final _tabletPages = [
    const DashboardView(),
    const TasksView(),
    const ProjectsView(),
    const PortalDiscussionsView(),
    const PortalDocumentsView(),
    const SelfProfileScreen(),
    const SettingsScreen(),
    const MoreView(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          SafeArea(
            child: Container(
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
                                  color: Get.theme.colors().onNavBar.withOpacity(0.4),
                                  height: _iconSize),
                              selectedIcon: AppIcon(
                                  icon: SvgIcons.tab_bar_dashboard,
                                  color: Get.theme.colors().onNavBar,
                                  height: _iconSize),
                              label: Text(
                                tr('dashboard'),
                              )),
                          NavigationRailDestination(
                              icon: AppIcon(
                                  icon: SvgIcons.tab_bar_tasks,
                                  color: Get.theme.colors().onNavBar.withOpacity(0.4),
                                  height: _iconSize),
                              selectedIcon: AppIcon(
                                  icon: SvgIcons.tab_bar_tasks,
                                  color: Get.theme.colors().onNavBar,
                                  height: _iconSize),
                              label: Text(tr('tasks'))),
                          NavigationRailDestination(
                              icon: AppIcon(
                                  icon: SvgIcons.tab_bar_projects,
                                  color: Get.theme.colors().onNavBar.withOpacity(0.4),
                                  height: _iconSize),
                              selectedIcon: AppIcon(
                                  icon: SvgIcons.tab_bar_projects,
                                  color: Get.theme.colors().onNavBar,
                                  height: _iconSize),
                              label: Text(tr('projects'))),
                          NavigationRailDestination(
                              icon: AppIcon(
                                  icon: SvgIcons.discussions,
                                  color: Get.theme.colors().onNavBar.withOpacity(0.4),
                                  height: _iconSize),
                              selectedIcon: AppIcon(
                                  icon: SvgIcons.discussions,
                                  color: Get.theme.colors().onNavBar,
                                  height: _iconSize),
                              label: Text(tr('discussions'))),
                          NavigationRailDestination(
                              icon: AppIcon(
                                  icon: SvgIcons.documents,
                                  color: Get.theme.colors().onNavBar.withOpacity(0.4),
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
                        PlatformIconButton(
                          icon: SizedBox(
                              width: 72,
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Get.theme.colors().bgDescription,
                                  child: ClipOval(
                                    child: Obx(() {
                                      return controller.selfUserItem.value.avatar.value;
                                    }),
                                  ),
                                ),
                              )),
                          onPressed: () => controller.toScreen(const SelfProfileScreen(),
                              arguments: {'showBackButton': true, 'showSettingsButton': false}),
                        ),
                        PlatformIconButton(
                          icon: AppIcon(
                            icon: SvgIcons.settings,
                            width: 24,
                            height: 24,
                            color: Get.theme.colors().onNavBar.withOpacity(0.4),
                          ),
                          onPressed: () => controller.toScreen(const SettingsScreen()),
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
          ),
          Expanded(
            child: contentView ?? Obx(() => _tabletPages[controller.tabIndex.value]),
          ),
        ],
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  final double iconSize = 24;

  MobileLayout({
    Key? key,
  }) : super(key: key);

  final _pages = [
    const DashboardView(),
    const TasksView(),
    const ProjectsView(),
    const MoreView(),
    const SelfProfileScreen(),
    const PortalDiscussionsView(),
    const PortalDocumentsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.find<NavigationController>();

    final heightBottomNavigationBar =
        navigationController.onMoreView.value ? 300 : 56 + MediaQuery.of(context).padding.bottom;

    return Obx(
      () => Scaffold(
        body: Stack(
          children: [
            _pages[navigationController.tabIndex.value],
            if (navigationController.onMoreView.value)
              GestureDetector(
                onVerticalDragDown: (details) => Get.find<NavigationController>()
                    .changeTabIndex(navigationController.tabIndex.value),
                onTap: () => Get.find<NavigationController>()
                    .changeTabIndex(navigationController.tabIndex.value),
                child: Container(
                  padding: EdgeInsets.zero,
                  color: Colors.transparent,
                ),
              ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: heightBottomNavigationBar.toDouble(),
          child: Column(
            children: [
              if (navigationController.onMoreView.value) const Expanded(child: MoreView()),
              BottomNavigationBar(
                onTap: navigationController.changeTabIndex,
                currentIndex:
                    navigationController.onMoreView.value || navigationController.tabIndex.value > 3
                        ? 3
                        : navigationController.tabIndex.value,
                selectedFontSize: 12,
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
