import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    var controller = Get.arguments['controller'];

    var usersDataSource = Get.find<UsersDataSource>();

    controller.selectionMode = UserSelectionMode.Single;
    usersDataSource.selectionMode = UserSelectionMode.Single;
    controller.setupUsersSelection();

    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor:
          platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        titleText: tr('selectPM'),
        backgroundColor:
            platformController.isMobile ? null : Get.theme.colors().surface,
        backButtonIcon: Get.put(PlatformController()).isMobile
            ? const Icon(Icons.arrow_back_rounded)
            : const Icon(Icons.close),
        bottom: Container(
          height: 40,
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: UsersSearchBar(controller: usersDataSource),
        ),
      ),
      body: Obx(
        () {
          if (controller.usersLoaded.value &&
              usersDataSource.usersList.isNotEmpty &&
              !usersDataSource.isSearchResult.value) {
            return UsersDefault(
              selfUserItem: controller.selfUserItem,
              usersDataSource: usersDataSource,
              onTapFunction: controller.changePMSelection,
            );
          }
          if (usersDataSource.nothingFound.value == true) {
            return const NothingFound();
          }
          if (usersDataSource.loaded.value == true &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.value == true) {
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
  final usersDataSource;

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
                onTapFunction: onTapFunction,
              ),
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
  final usersDataSource;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: usersDataSource.pullUpEnabled,
      controller: usersDataSource.refreshController,
      onLoading: usersDataSource.onLoading,
      child: ListView(
        children: <Widget>[
          Obx(() {
            if (usersDataSource.selfIsVisible.value == true)
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
