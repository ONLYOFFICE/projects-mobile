import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/projects/new_project_controller.dart';
import 'package:projects/domain/controllers/projects/users_data_source.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/project_detailed/custom_appbar.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:projects/presentation/views/projects_view/widgets/header.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';
import 'package:projects/presentation/views/projects_view/widgets/search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TeamMembersSelectionView extends StatelessWidget {
  const TeamMembersSelectionView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewProjectController>();
    var usersDataSource = Get.find<UsersDataSource>();

    usersDataSource.multipleSelectionEnabled = true;
    controller.multipleSelectionEnabled = true;
    controller.setupUsersSelection();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
        title: CustomHeaderWithButton(
          function: controller.confirmTeamMembers,
          title: 'Add team membres',
        ),
        bottom: SearchBar(controller: usersDataSource),
      ),
      body: Obx(
        () {
          if (usersDataSource.loaded.isTrue &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.isFalse) {
            return UsersDefault(
              selfUserItem: controller.selfUserItem,
              usersDataSource: usersDataSource,
              onTapFunction: controller.selectTeamMember,
            );
          }
          if (usersDataSource.nothingFound.isTrue) {
            return NothingFound();
          }
          if (usersDataSource.loaded.isTrue &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.isTrue) {
            return UsersSearchResult(
              usersDataSource: usersDataSource,
              onTapFunction: controller.selectTeamMember,
            );
          }
          return ListLoadingSkeleton();
        },
      ),
    );
  }
}
