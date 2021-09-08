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
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/user_selection_tile.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/users_from_groups.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ManageDiscussionSubscribersScreen extends StatelessWidget {
  const ManageDiscussionSubscribersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var usersDataSource = Get.find<UsersDataSource>();
    DiscussionActionsController controller = Get.arguments['controller'];
    var onConfirm = Get.arguments['onConfirm'];

    final platformController = Get.find<PlatformController>();

    controller.setupSubscribersSelection();

    return Scaffold(
      backgroundColor:
          platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr('manageSubscribers')),
              if (controller.subscribers.isNotEmpty)
                Text(plural('selected', controller.subscribers.length),
                    style: TextStyleHelper.caption())
            ],
          ),
        ),
        onLeadingPressed: controller.leaveSubscribersSelectionView,
        backButtonIcon: Get.put(PlatformController()).isMobile
            ? const Icon(Icons.arrow_back_rounded)
            : const Icon(Icons.close),
        actions: [
          IconButton(
              onPressed: onConfirm ?? controller.confirmSubscribersSelection,
              icon: const Icon(Icons.done))
        ],
        // bottom: CustomSearchBar(controller: controller),
        bottom: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(() => Expanded(
                  child: SearchField(
                    hintText: tr('usersSearch'),
                    onSubmitted: (value) => usersDataSource.searchUsers(value),
                    showClearIcon: usersDataSource.isSearchResult.value == true,
                    onClearPressed: controller.clearUserSearch,
                    controller: controller.userSearchController,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.5, right: 16),
              child: InkResponse(
                onTap: () => Get.find<NavigationController>().to(
                    const UsersFromGroups(),
                    arguments: {'controller': controller}),
                child: AppIcon(icon: SvgIcons.preferences),
              ),
            )
          ],
        ),
      ),
      body: Obx(
        () {
          if (usersDataSource.loaded.value == true &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.value == false) {
            return SmartRefresher(
              enablePullDown: false,
              controller: usersDataSource.refreshController,
              onLoading: usersDataSource.onLoading,
              enablePullUp: usersDataSource.pullUpEnabled,
              child: CustomScrollView(
                slivers: <Widget>[
                  if (controller.subscribers.isNotEmpty)
                    _UsersCategoryText(text: tr('subscribed')),
                  if (controller.subscribers.isNotEmpty)
                    _SubscribedUsers(
                      controller: controller,
                      usersDataSource: usersDataSource,
                    ),
                  _UsersCategoryText(text: tr('allUsers')),
                  _AllUsers(
                    usersDataSource: usersDataSource,
                    controller: controller,
                  ),
                ],
              ),
            );
          }
          if (usersDataSource.nothingFound.value == true) {
            // NothingFound contains Expanded widget, that why it is needed
            // to use Column
            return Column(children: [const NothingFound()]);
          }
          if (usersDataSource.loaded.value == true &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.value == true) {
            return UsersSearchResult(
              usersDataSource: usersDataSource,
              onTapFunction: (user) =>
                  controller.addSubscriber(user, fromUsersDataSource: true),
            );
          }
          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}

class _UsersCategoryText extends StatelessWidget {
  const _UsersCategoryText({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 14),
        child: Text(
          text,
          style: TextStyleHelper.body2(
              color: Get.theme.colors().onSurface.withOpacity(0.6)),
        ),
      ),
    );
  }
}

class _AllUsers extends StatelessWidget {
  const _AllUsers({
    Key key,
    @required this.usersDataSource,
    @required this.controller,
  }) : super(key: key);

  final UsersDataSource usersDataSource;
  final DiscussionActionsController controller;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: const EdgeInsets.only(top: 24),
          child: UserSelectionTile(
            image: usersDataSource.usersList[index].portalUser.avatar ??
                usersDataSource.usersList[index].avatarMedium ??
                usersDataSource.usersList[index].portalUser.avatarSmall,
            value: usersDataSource.usersList[index].isSelected == true,
            onChanged: (value) {
              // controller.subscribers[index].onTap();
              controller.addSubscriber(usersDataSource.usersList[index],
                  fromUsersDataSource: false);
            },
            displayName: usersDataSource.usersList[index].displayName,
            caption: usersDataSource.usersList[index].portalUser.title,
          ),
        ),
        childCount: usersDataSource.usersList.length,
      ),
    );
  }
}

class _SubscribedUsers extends StatelessWidget {
  const _SubscribedUsers({
    Key key,
    @required this.controller,
    @required this.usersDataSource,
  }) : super(key: key);

  final DiscussionActionsController controller;
  final UsersDataSource usersDataSource;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: UserSelectionTile(
              image: controller.subscribers[index].portalUser.avatar ??
                  controller.subscribers[index].avatarMedium ??
                  controller.subscribers[index].portalUser.avatarSmall,
              value: controller.subscribers[index].isSelected == true,
              onChanged: (value) {
                // controller.subscribers[index].onTap();
                controller.addSubscriber(controller.subscribers[index],
                    fromUsersDataSource: false);
              },
              displayName: controller.subscribers[index].displayName,
              caption: controller.subscribers[index].portalUser.title,
            ),
          );
        },
        childCount: controller.subscribers.length,
      ),
    );
  }
}
