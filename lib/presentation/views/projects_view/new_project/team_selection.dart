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
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:projects/domain/controllers/projects/new_project/groups_data_source.dart';
import 'package:projects/domain/controllers/projects/new_project/new_project_controller.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_group_item.dart';

class GroupMembersSelectionView extends StatelessWidget {
  const GroupMembersSelectionView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller =
        Get.arguments['controller']; // Get.find<NewProjectController>();
    var groupsDataSource = Get.find<GroupsDataSource>();

    groupsDataSource.getGroups();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: StyledAppBar(
        titleText: tr('addMembersOf'),
        elevation: 2,
        actions: [
          IconButton(
              icon: const Icon(Icons.check_outlined),
              onPressed: () => controller.confirmGroupSelection)
        ],
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
          return const ListLoadingSkeleton();
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
      child: ListView.separated(
        itemCount: groupsDataSource.groupsList.length,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 22),
        separatorBuilder: (BuildContext c, int i) {
          return const SizedBox(height: 25);
        },
        itemBuilder: (BuildContext c, int i) {
          return PortalGroupItem(
              groupController: groupsDataSource.groupsList[i],
              onTapFunction: onTapFunction);
        },
      ),
    );
  }
}
