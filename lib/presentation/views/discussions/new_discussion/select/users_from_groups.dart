import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/new_discussion_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/groups_data_source.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_selection.dart';

class UsersFromGroups extends StatelessWidget {
  const UsersFromGroups({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewDiscussionController controller = Get.arguments['controller'];

    var groupsDataSource = Get.find<GroupsDataSource>();
    groupsDataSource.getGroups();

    return Scaffold(
      appBar: StyledAppBar(
        titleText: 'Users from groups',
        actions: [
          IconButton(
            onPressed: controller.confirmGroupSelection,
            icon: const Icon(Icons.done),
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
