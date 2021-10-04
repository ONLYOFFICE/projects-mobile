import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';

import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_selection.dart';
import 'package:projects/presentation/views/projects_view/widgets/search_bar.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class TeamMembersSelectionView extends StatelessWidget {
  const TeamMembersSelectionView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.arguments['controller'];
    var usersDataSource = Get.find<UsersDataSource>();

    usersDataSource.selectedProjectManager =
        controller.selectedProjectManager.value;
    controller.selectionMode = UserSelectionMode.Multiple;
    usersDataSource.selectionMode = UserSelectionMode.Multiple;

    controller.setupUsersSelection();

    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor:
          platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
        backButtonIcon: Get.put(PlatformController()).isMobile
            ? const Icon(Icons.arrow_back_rounded)
            : const Icon(Icons.close),
        title: TeamMembersSelectionHeader(
          controller: controller,
          title: tr('addTeamMembers'),
        ),
        titleHeight: 60,
        bottom: TeamMembersSearchBar(
          usersDataSource: usersDataSource,
          controller: controller,
        ),
      ),
      body: Obx(
        () {
          if (usersDataSource.loaded.value == true &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.value == false) {
            return UsersDefault(
              selfUserItem: controller.selfUserItem,
              usersDataSource: usersDataSource,
              onTapFunction: controller.selectTeamMember,
            );
          }
          if (usersDataSource.nothingFound.value == true) {
            return Column(children: [const NothingFound()]);
          }
          if (usersDataSource.loaded.value == true &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.value == true) {
            return UsersSearchResult(
              usersDataSource: usersDataSource,
              onTapFunction: controller.selectTeamMember,
            );
          }
          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}

class TeamMembersSelectionHeader extends StatelessWidget {
  const TeamMembersSelectionHeader({
    Key key,
    @required this.title,
    @required this.controller,
  }) : super(key: key);

  final String title;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Obx(
            () {
              if (controller.selectedTeamMembers.isNotEmpty) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyleHelper.headline6(
                              color: Get.theme.colors().onSurface),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          plural(
                              'person', controller.selectedTeamMembers.length),
                          style: TextStyleHelper.caption(
                              color: Get.theme.colors().onSurface),
                        ),
                      ),
                    ],
                  ),
                );
              } else
                return Expanded(
                  child: Text(
                    title,
                    style: TextStyleHelper.headline6(
                        color: Get.theme.colors().onSurface),
                  ),
                );
            },
          ),
          Obx(
            () {
              if (controller.selectedTeamMembers.isNotEmpty) {
                return InkWell(
                  onTap: () {
                    controller.confirmTeamMembers();
                  },
                  child: const Icon(Icons.check, color: Colors.blue),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

class TeamMembersSearchBar extends StatelessWidget {
  const TeamMembersSearchBar({
    Key key,
    @required this.controller,
    @required this.usersDataSource,
  }) : super(key: key);

  final UsersDataSource usersDataSource;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 16, right: 20, bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: UsersSearchBar(controller: usersDataSource)),
          const SizedBox(width: 20),
          Container(
            height: 24,
            width: 24,
            child: InkWell(
              onTap: () {
                Get.find<NavigationController>().toScreen(
                    const GroupMembersSelectionView(),
                    arguments: {'controller': controller});
              },
              child: AppIcon(
                icon: SvgIcons.preferences,
                color: Get.theme.colors().primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
