import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectTeamResponsibleSelectionView extends StatelessWidget {
  const ProjectTeamResponsibleSelectionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.arguments['controller'];
    controller.setupResponsibleSelection();

    return Scaffold(
      appBar: StyledAppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr('selectResponsible')),
            ],
          ),
          bottom: SearchField(
            hintText: tr('usersSearch'),
            onSubmitted: (value) =>
                controller.teamController.searchUsers(value),
            onChanged: (value) => controller.teamController.searchUsers(value),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.check_rounded),
                onPressed: controller.confirmResponsiblesSelection)
          ],
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: controller.leaveResponsiblesSelectionView)),
      body: Obx(
        () {
          if (controller.teamController.loaded.value == true &&
              controller.teamController.usersList.isNotEmpty &&
              controller.teamController.isSearchResult.value == false) {
            return SmartRefresher(
              enablePullDown: false,
              enablePullUp: controller.teamController.pullUpEnabled,
              controller: controller.teamController.refreshController,
              onLoading: controller.teamController.onLoading,
              child: ListView(
                children: <Widget>[
                  Column(children: [
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (c, i) => PortalUserItem(
                          userController:
                              controller.teamController.usersList[i],
                          onTapFunction: controller.addResponsible),
                      itemExtent: 65.0,
                      itemCount: controller.teamController.usersList.length,
                    )
                  ]),
                ],
              ),
            );
          }
          if (controller.teamController.nothingFound.value == true) {
            return const NothingFound();
          }
          if (controller.teamController.loaded.value == true &&
              controller.teamController.searchResult.isNotEmpty &&
              controller.teamController.isSearchResult.value == true) {
            return SmartRefresher(
              enablePullDown: false,
              enablePullUp: controller.teamController.pullUpEnabled,
              controller: controller.teamController.refreshController,
              onLoading: controller.teamController.onLoading,
              child: ListView(
                children: <Widget>[
                  Column(children: [
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (c, i) => PortalUserItem(
                          userController:
                              controller.teamController.searchResult[i],
                          onTapFunction: controller.addResponsible),
                      itemExtent: 65.0,
                      itemCount: controller.teamController.searchResult.length,
                    )
                  ]),
                ],
              ),
            );
          }
          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}
