import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/projects/new_project_controller.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/project_detailed/custom_appbar.dart';
import 'package:projects/presentation/views/projects_view/widgets/header.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/views/projects_view/widgets/portal_user_item.dart';
import 'package:projects/presentation/views/projects_view/widgets/search_bar.dart';

class ProjectManagerSelectionView extends StatelessWidget {
  const ProjectManagerSelectionView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewProjectController>();

    controller.setupPMSelection();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
        title: CustomHeaderWithoutButton(
          title: 'Select project manager',
        ),
        bottom: SearchBar(controller: controller),
      ),
      body: Obx(
        () {
          if (controller.usersLoaded.isTrue &&
              controller.searchResult.isEmpty &&
              controller.nothingFound.isFalse) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('Me', style: TextStyleHelper.body2()),
                ),
                SizedBox(height: 26),
                PortalUserItem(
                  onTapFunction: controller.changePMSelection,
                  userController: controller.selfUserItem,
                ),
                SizedBox(height: 26),
                Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('Users', style: TextStyleHelper.body2()),
                ),
                SizedBox(height: 26),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (c, i) => PortalUserItem(
                        userController: controller.allUsers[i],
                        onTapFunction: controller.changePMSelection),
                    itemExtent: 65.0,
                    itemCount: controller.allUsers.length,
                  ),
                ),
              ],
            );
          }
          if (controller.nothingFound.isTrue) {
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
          if (controller.usersLoaded.isTrue &&
              controller.searchResult.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (c, i) => PortalUserItem(
                        userController: controller.searchResult[i],
                        onTapFunction: controller.changePMSelection),
                    itemExtent: 65.0,
                    itemCount: controller.searchResult.length,
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
