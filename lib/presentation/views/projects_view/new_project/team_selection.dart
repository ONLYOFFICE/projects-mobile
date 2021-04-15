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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/new_project/groups_data_source.dart';

import 'package:projects/domain/controllers/projects/new_project/new_project_controller.dart';

import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/project_detailed/custom_appbar.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:projects/presentation/views/projects_view/widgets/header.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_group_item.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';

import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GroupMembersSelectionView extends StatelessWidget {
  const GroupMembersSelectionView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewProjectController>();
    var groupsDataSource = Get.find<GroupsDataSource>();

    groupsDataSource.getGroups();
    // usersDataSource.multipleSelectionEnabled = true;
    // controller.multipleSelectionEnabled = true;
    // controller.setupUsersSelection();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
        title: CustomHeaderWithButton(
          function: controller.confirmGroupSelection,
          title: 'Add members of',
        ),
      ),
      body: Obx(
        () {
          if (groupsDataSource.loaded.isTrue &&
              groupsDataSource.groupsList.isNotEmpty) {
            return GroupsOverview(
              groupsDataSource: groupsDataSource,
              onTapFunction: controller.selectGroupMembers,
            );
          }
          return ListLoadingSkeleton();
        },
      ),
    );
  }
}

class GroupsOverview extends StatelessWidget {
  const GroupsOverview({
    Key key,
    @required this.groupsDataSource,
    @required this.onTapFunction,
  }) : super(key: key);
  final Function onTapFunction;
  final GroupsDataSource groupsDataSource;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: false,
      controller: groupsDataSource.refreshController,
      onLoading: groupsDataSource.onLoading,
      child: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (c, i) => PortalGroupItem(
            groupController: groupsDataSource.groupsList[i],
            onTapFunction: onTapFunction),
        itemExtent: 65.0,
        itemCount: groupsDataSource.groupsList.length,
      ),
    );
  }
}
