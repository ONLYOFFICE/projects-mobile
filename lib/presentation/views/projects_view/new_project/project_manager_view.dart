import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:projects/domain/controllers/projects/new_project/new_project_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';
import 'package:projects/presentation/views/projects_view/widgets/search_bar.dart';

class ProjectManagerSelectionView extends StatelessWidget {
  const ProjectManagerSelectionView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewProjectController>();
    var usersDataSource = Get.find<UsersDataSource>();

    controller.selectionMode = UserSelectionMode.Single;
    usersDataSource.selectionMode = UserSelectionMode.Single;
    controller.setupUsersSelection();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: StyledAppBar(
        titleText: 'Select project manager',
        bottom: Container(
          height: 40,
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: UsersSearchBar(controller: usersDataSource),
        ),
      ),
      body: Obx(
        () {
          if (controller.usersLoaded.isTrue &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.isFalse) {
            return UsersDefault(
              selfUserItem: controller.selfUserItem,
              usersDataSource: usersDataSource,
              onTapFunction: controller.changePMSelection,
            );
          }
          if (usersDataSource.nothingFound.isTrue) {
            return const NothingFound();
          }
          if (usersDataSource.loaded.isTrue &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.isTrue) {
            return UsersSearchResult(
              usersDataSource: usersDataSource,
              onTapFunction: controller.changePMSelection,
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
    Key key,
    @required this.usersDataSource,
    @required this.onTapFunction,
  }) : super(key: key);
  final Function onTapFunction;
  final UsersDataSource usersDataSource;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: usersDataSource.pullUpEnabled,
            controller: usersDataSource.refreshController,
            onLoading: usersDataSource.onLoading,
            child: ListView.builder(
              itemBuilder: (c, i) => PortalUserItem(
                  userController: usersDataSource.usersList[i],
                  onTapFunction: onTapFunction),
              itemExtent: 65.0,
              itemCount: usersDataSource.usersList.length,
            ),
          ),
        )
      ],
    );
  }
}

class UsersDefault extends StatelessWidget {
  const UsersDefault({
    Key key,
    @required this.selfUserItem,
    @required this.usersDataSource,
    @required this.onTapFunction,
  }) : super(key: key);
  final Function onTapFunction;
  final PortalUserItemController selfUserItem;
  final UsersDataSource usersDataSource;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: usersDataSource.pullUpEnabled,
      controller: usersDataSource.refreshController,
      onLoading: usersDataSource.onLoading,
      child: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 16),
            child: Text('Me', style: TextStyleHelper.body2()),
          ),
          const SizedBox(height: 26),
          PortalUserItem(
            onTapFunction: onTapFunction,
            userController: selfUserItem,
          ),
          const SizedBox(height: 26),
          Container(
            padding: const EdgeInsets.only(left: 16),
            child: Text('Users', style: TextStyleHelper.body2()),
          ),
          const SizedBox(height: 26),
          Column(children: [
            ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (c, i) => PortalUserItem(
                  userController: usersDataSource.usersList[i],
                  onTapFunction: onTapFunction),
              itemExtent: 65.0,
              itemCount: usersDataSource.usersList.length,
            )
          ]),
        ],
      ),
    );
  }
}
