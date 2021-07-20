import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:projects/domain/controllers/projects/new_project/groups_data_source.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_group_item.dart';

class GroupMembersSelectionView extends StatelessWidget {
  const GroupMembersSelectionView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.arguments['controller'];
    // Get.find<NewProjectController>();
    var groupsDataSource = Get.find<GroupsDataSource>();

    groupsDataSource.getGroups();
    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      appBar: StyledAppBar(
        titleText: tr('addMembersOf'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_outlined),
            onPressed: () => controller.confirmGroupSelection(),
          )
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
