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
import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_smart_refresher.dart';
import 'package:projects/domain/controllers/projects/new_project/groups_data_source.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/wrappers/platform_widget.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_group_item.dart';

class GroupMembersSelectionView extends StatelessWidget {
  const GroupMembersSelectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.arguments['controller'];

    final groupsDataSource = Get.find<GroupsDataSource>();

    void onActionPressed() => controller.confirmGroupSelection();

    groupsDataSource.getGroups();
    return Scaffold(
      //backgroundColor: Get.theme.backgroundColor,
      appBar: StyledAppBar(
        titleText: tr('addMembersOf'),
        centerTitle: GetPlatform.isIOS,
        leadingWidth: 65,
        leading: PlatformWidget(
          cupertino: (_, __) => CupertinoButton(
            padding: const EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            onPressed: Get.back,
            child: Text(
              tr('closeLowerCase'),
              style: TextStyleHelper.button(),
            ),
          ),
          material: (_, __) => IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.close),
          ),
        ),
        actions: [
          PlatformWidget(
            material: (platformContext, __) => IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: onActionPressed,
            ),
            cupertino: (platformContext, __) => CupertinoButton(
              onPressed: onActionPressed,
              padding: const EdgeInsets.only(right: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                tr('Done'),
                style: TextStyleHelper.headline7(),
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          if (groupsDataSource.loaded.value == true && groupsDataSource.groupsList.isNotEmpty) {
            return GroupsOverview(
              groupsDataSource: groupsDataSource,
              onTapFunction: controller.selectGroupMembers as Function(PortalGroupItemController),
            );
          } else if (groupsDataSource.loaded.value == true) {
            return Column(children: const [NothingFound()]);
          }
          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}

class GroupsOverview extends StatelessWidget {
  const GroupsOverview({
    Key? key,
    required this.groupsDataSource,
    required this.onTapFunction,
  }) : super(key: key);
  final Function(PortalGroupItemController)? onTapFunction;
  final GroupsDataSource groupsDataSource;

  @override
  Widget build(BuildContext context) {
    return StyledSmartRefresher(
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
              groupController: groupsDataSource.groupsList[i], onTapFunction: onTapFunction);
        },
      ),
    );
  }
}
