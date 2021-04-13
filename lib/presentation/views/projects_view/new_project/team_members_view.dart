import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/projects/new_project_controller.dart';
import 'package:projects/domain/controllers/projects/users_data_source.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/project_detailed/custom_appbar.dart';
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('Me', style: TextStyleHelper.body2()),
                ),
                SizedBox(height: 26),
                PortalUserItem(
                  onTapFunction: controller.selectTeamMember,
                  userController: controller.selfUserItem,
                ),
                SizedBox(height: 26),
                Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('Users', style: TextStyleHelper.body2()),
                ),
                SizedBox(height: 26),
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: usersDataSource.pullUpEnabled,
                    controller: usersDataSource.refreshController,
                    onLoading: usersDataSource.onLoading,
                    child: ListView.builder(
                      itemBuilder: (c, i) => PortalUserItem(
                        userController: usersDataSource.usersList[i],
                        onTapFunction: controller.selectTeamMember,
                      ),
                      itemExtent: 65.0,
                      itemCount: usersDataSource.usersList.length,
                    ),
                  ),
                ),
              ],
            );
          }
          if (usersDataSource.nothingFound.isTrue) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Not found',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }
          if (usersDataSource.loaded.isTrue &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.isTrue) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (c, i) => PortalUserItem(
                      userController: usersDataSource.usersList[i],
                      onTapFunction: controller.selectTeamMember,
                    ),
                    itemExtent: 65.0,
                    itemCount: usersDataSource.usersList.length,
                  ),
                )
              ],
            );
          }
          return ListLoadingSkeleton();
        },
      ),
    );
  }
}
