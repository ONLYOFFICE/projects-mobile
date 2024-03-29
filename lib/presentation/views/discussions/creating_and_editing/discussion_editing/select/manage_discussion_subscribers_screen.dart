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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/actions/abstract_discussion_actions_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/internal/utils/text_utils.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_smart_refresher.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/common/users_from_groups.dart';
import 'package:projects/presentation/shared/widgets/users_list.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';

class ManageDiscussionSubscribersScreen extends StatelessWidget {
  const ManageDiscussionSubscribersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usersDataSource = Get.find<UsersDataSource>();
    final args = ModalRoute.of(context)!.settings.arguments ?? Get.arguments;
    final controller = args['controller'] as DiscussionActionsController;
    final onConfirm = args['onConfirm'] as Function()?;

    final platformController = Get.find<PlatformController>();

    controller.setupSubscribersSelection();

    return WillPopScope(
      onWillPop: () async {
        controller.leaveSubscribersSelectionView();
        return false;
      },
      child: Scaffold(
        backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
        appBar: StyledAppBar(
          backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
          title: _DiscussionSubscribersSelectionHeader(
            title: tr('manageSubscribers'),
            controller: controller,
          ),
          titleWidth: TextUtils.getTextWidth(
            tr('manageSubscribers'),
            TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface),
          ),
          previousPageTitle: tr('back').toLowerCase().capitalizeFirst,
          onLeadingPressed: controller.leaveSubscribersSelectionView,
          actions: [
            PlatformIconButton(
              padding: EdgeInsets.zero,
              onPressed: onConfirm ?? controller.confirmSubscribersSelection,
              icon: Icon(PlatformIcons(context).checkMark),
            )
          ],
          bottom: DiscussionSubscribersSearchBar(
            usersDataSource: usersDataSource,
            controller: controller,
          ),
        ),
        body: StyledSmartRefresher(
          enablePullDown: false,
          controller: usersDataSource.refreshController,
          onLoading: usersDataSource.onLoading,
          enablePullUp: usersDataSource.pullUpEnabled,
          child: Obx(
            () {
              if (usersDataSource.loaded.value == true &&
                  usersDataSource.usersList.isNotEmpty &&
                  usersDataSource.isSearchResult.value == false) {
                return CustomScrollView(
                  slivers: <Widget>[
                    if (controller.subscribers.isNotEmpty)
                      _UsersCategoryText(text: tr('subscribed')),
                    if (controller.subscribers.isNotEmpty)
                      _SubscribedUsers(
                        controller: controller,
                        usersDataSource: usersDataSource,
                      ),
                    _UsersCategoryText(text: tr('allUsers')),
                    _AllUsers(controller: controller),
                  ],
                );
              }
              if (usersDataSource.nothingFound.value == true) {
                return const NothingFound();
              }
              if (usersDataSource.loaded.value == true &&
                  usersDataSource.usersList.isNotEmpty &&
                  usersDataSource.isSearchResult.value == true) {
                return UsersSimpleList(
                    onTapFunction: (user) =>
                        controller.addSubscriber(user, fromUsersDataSource: true),
                    users: usersDataSource.usersList);
              }
              return const ListLoadingSkeleton();
            },
          ),
        ),
      ),
    );
  }
}

class DiscussionSubscribersSearchBar extends StatelessWidget {
  const DiscussionSubscribersSearchBar({
    Key? key,
    required this.usersDataSource,
    required this.controller,
  }) : super(key: key);

  final UsersDataSource usersDataSource;
  final DiscussionActionsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 0, bottom: 8, top: 8),
      child: Row(
        children: [
          Expanded(
            child: SearchField(
              hintText: tr('usersSearch'),
              textInputAction: TextInputAction.search,
              margin: EdgeInsets.zero,
              onSubmitted: usersDataSource.searchUsers,
              onChanged: usersDataSource.searchUsers,
              onClearPressed: controller.clearUserSearch,
              controller: controller.userSearchController,
            ),
          ),
          PlatformIconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Get.find<NavigationController>().toScreen(
              const UsersFromGroups(),
              arguments: {'controller': controller},
              transition: Transition.cupertinoDialog,
              fullscreenDialog: true,
              page: '/UsersFromGroups',
            ),
            icon: const AppIcon(icon: SvgIcons.preferences),
          )
        ],
      ),
    );
  }
}

class _DiscussionSubscribersSelectionHeader extends StatelessWidget {
  const _DiscussionSubscribersSelectionHeader({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  final DiscussionActionsController controller;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface),
          ),
          if (controller.subscribers.isNotEmpty)
            Text(plural('selected', controller.subscribers.length),
                style: TextStyleHelper.caption(color: Theme.of(context).colors().onSurface))
        ],
      ),
    );
  }
}

class _UsersCategoryText extends StatelessWidget {
  const _UsersCategoryText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 14),
        child: Text(
          text,
          style:
              TextStyleHelper.body2(color: Theme.of(context).colors().onSurface.withOpacity(0.6)),
        ),
      ),
    );
  }
}

class _AllUsers extends StatelessWidget {
  const _AllUsers({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final DiscussionActionsController controller;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => PortalUserItem(
          userController: controller.otherUsers[index],
          onTapFunction: (value) => {controller.addSubscriber(controller.otherUsers[index])},
        ),
        childCount: controller.otherUsers.length,
      ),
    );
  }
}

class _SubscribedUsers extends StatelessWidget {
  const _SubscribedUsers({
    Key? key,
    required this.controller,
    required this.usersDataSource,
  }) : super(key: key);

  final DiscussionActionsController controller;
  final UsersDataSource usersDataSource;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          return PortalUserItem(
            userController: controller.subscribers[index],
            onTapFunction: (value) => {
              controller.removeSubscriber(controller.subscribers[index]),
            },
          );
        },
        childCount: controller.subscribers.length,
      ),
    );
  }
}
