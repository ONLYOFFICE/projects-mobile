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
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/wrappers/platform_icon_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_selection.dart';

class TeamMembersSelectionView extends StatelessWidget {
  const TeamMembersSelectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.arguments['controller'];
    final usersDataSource = Get.find<UsersDataSource>();

    usersDataSource.selectedProjectManager = controller.selectedProjectManager.value as PortalUser?;
    controller.selectionMode = UserSelectionMode.Multiple;
    usersDataSource.selectionMode = UserSelectionMode.Multiple;

    controller.setupUsersSelection();

    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
        backButtonIcon: Get.put(PlatformController()).isMobile
            ? Icon(PlatformIcons(context).back)
            : Icon(PlatformIcons(context).clear),
        title: TeamMembersSelectionHeader(
          controller: controller,
          title: tr('addTeamMembers'),
        ),
        actions: [
          _DoneButton(controller: controller),
        ],
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
              selfUserItem: controller.selfUserItem as PortalUserItemController?,
              usersDataSource: usersDataSource,
              onTapFunction: (v) => controller.selectTeamMember(v),
            );
          }
          if (usersDataSource.nothingFound.value == true) {
            return const NothingFound();
          }
          if (usersDataSource.loaded.value == true &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.value == true) {
            return UsersSearchResult(
              usersDataSource: usersDataSource,
              onTapFunction: controller.selectTeamMember as Function(PortalUserItemController),
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
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  final String title;
  final controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Obx(
            () {
              if (controller.selectedTeamMembers.isNotEmpty as bool) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyleHelper.headline6(color: Get.theme.colors().onSurface),
                      ),
                      Text(
                        plural('person', controller.selectedTeamMembers.length as int),
                        style: TextStyleHelper.caption(color: Get.theme.colors().onSurface),
                      ),
                    ],
                  ),
                );
              } else
                return Text(
                  title,
                  style: TextStyleHelper.headline6(color: Get.theme.colors().onSurface),
                );
            },
          ),
          // const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _DoneButton extends StatelessWidget {
  const _DoneButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () {
            if (controller.selectedTeamMembers.isNotEmpty as bool) {
              return PlatformIconButton(
                onPressed: () {
                  controller.confirmTeamMembers();
                },
                icon: Icon(PlatformIcons(context).checkMark),
                padding: EdgeInsets.zero,
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class TeamMembersSearchBar extends StatelessWidget {
  const TeamMembersSearchBar({
    Key? key,
    required this.controller,
    required this.usersDataSource,
  }) : super(key: key);

  final UsersDataSource usersDataSource;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SearchField(
              controller: usersDataSource.searchInputController,
              hintText: tr('usersSearch'),
              margin: EdgeInsets.zero,
              textInputAction: TextInputAction.search,
              showClearIcon: true,
              onClearPressed: usersDataSource.clearSearch,
              onChanged: usersDataSource.searchUsers,
              onSubmitted: usersDataSource.searchUsers,
            ),
          ),
          const SizedBox(width: 16),
          PlatformIconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.find<NavigationController>().toScreen(
                const GroupMembersSelectionView(),
                arguments: {'controller': controller},
                transition: Transition.cupertinoDialog,
                fullscreenDialog: true,
                isRootModalScreenView: false,
              );
            },
            icon: AppIcon(
              icon: SvgIcons.preferences,
              color: Get.theme.colors().primary,
            ),
          ),
        ],
      ),
    );
  }
}
