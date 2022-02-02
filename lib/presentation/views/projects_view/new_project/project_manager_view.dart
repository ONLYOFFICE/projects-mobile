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
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_smart_refresher.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';

import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';
import 'package:projects/presentation/views/projects_view/widgets/search_bar.dart';

class ProjectManagerSelectionView extends StatelessWidget {
  const ProjectManagerSelectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.arguments['controller'];

    final usersDataSource = Get.find<UsersDataSource>();

    controller.selectionMode = UserSelectionMode.Single;
    usersDataSource.selectionMode = UserSelectionMode.Single;
    controller.setupUsersSelection();

    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        titleText: tr('selectPM'),
        backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
        backButtonIcon: Get.put(PlatformController()).isMobile
            ? Icon(PlatformIcons(context).back)
            : Icon(PlatformIcons(context).clear),
        bottom: Container(
          height: 40,
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: UsersSearchBar(controller: usersDataSource),
        ),
      ),
      body: Obx(
        () {
          if (controller.usersLoaded.value as bool &&
              usersDataSource.usersWithoutVisitors.isNotEmpty &&
              !usersDataSource.isSearchResult.value) {
            return UsersDefault(
              selfUserItem: controller.selfUserItem as PortalUserItemController,
              usersDataSource: usersDataSource,
              onTapFunction: (v) => controller.changePMSelection(v),
              withoutGuests: true,
            );
          }
          if (usersDataSource.nothingFound.value == true) {
            return Column(children: const [NothingFound()]);
          }
          if (usersDataSource.loaded.value == true &&
              usersDataSource.usersWithoutVisitors.isNotEmpty &&
              usersDataSource.isSearchResult.value == true) {
            return UsersSearchResult(
              usersDataSource: usersDataSource,
              onTapFunction: (v) => controller.changePMSelection(v),
              withoutVisitors: true,
            );
          }
          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}

class UsersSearchResult extends StatelessWidget {
  const UsersSearchResult({
    Key? key,
    required this.usersDataSource,
    required this.onTapFunction,
    this.withoutVisitors = false,
  }) : super(key: key);
  final Function? onTapFunction;
  final UsersDataSource usersDataSource;
  final bool withoutVisitors;

  @override
  Widget build(BuildContext context) {
    final users =
        withoutVisitors ? usersDataSource.usersWithoutVisitors : usersDataSource.usersList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: StyledSmartRefresher(
            enablePullDown: false,
            enablePullUp: usersDataSource.pullUpEnabled,
            controller: usersDataSource.refreshController,
            onLoading: usersDataSource.onLoading,
            child: ListView.builder(
              itemBuilder: (c, i) => PortalUserItem(
                userController: users[i],
                onTapFunction: onTapFunction,
              ),
              itemExtent: 65,
              itemCount: users.length,
            ),
          ),
        )
      ],
    );
  }
}

class UsersDefault extends StatelessWidget {
  const UsersDefault({
    Key? key,
    required this.selfUserItem,
    required this.usersDataSource,
    required this.onTapFunction,
    this.withoutGuests = false,
  }) : super(key: key);
  final Function? onTapFunction;
  final PortalUserItemController? selfUserItem;
  final UsersDataSource usersDataSource;
  final bool withoutGuests;

  @override
  Widget build(BuildContext context) {
    final users = withoutGuests ? usersDataSource.usersWithoutVisitors : usersDataSource.usersList;
    return StyledSmartRefresher(
      enablePullDown: false,
      enablePullUp: usersDataSource.pullUpEnabled,
      controller: usersDataSource.refreshController,
      onLoading: usersDataSource.onLoading,
      child: ListView(
        children: <Widget>[
          Obx(() {
            if (usersDataSource.selfIsVisible.value == true)
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(tr('me'), style: TextStyleHelper.body2()),
                ),
                const SizedBox(height: 26),
                PortalUserItem(
                  onTapFunction: onTapFunction,
                  userController: selfUserItem,
                ),
                const SizedBox(height: 26),
              ]);
            else
              return const SizedBox();
          }),
          Container(
            padding: const EdgeInsets.only(left: 16),
            child: Text(tr('users'), style: TextStyleHelper.body2()),
          ),
          const SizedBox(height: 26),
          Column(children: [
            ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (c, i) =>
                  PortalUserItem(userController: users[i], onTapFunction: onTapFunction),
              itemExtent: 65,
              itemCount: users.length,
            )
          ]),
        ],
      ),
    );
  }
}
