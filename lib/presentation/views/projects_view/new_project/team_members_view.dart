import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/projects/new_project_controller.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/projects_view/search_appbar.dart';
import 'package:projects/presentation/views/projects_view/widgets/header.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/custom_theme.dart';

class TeamMembersSelectionView extends StatelessWidget {
  const TeamMembersSelectionView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewProjectController>();

    controller.setupTeamMembers();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: SearchAppBar(
        title: CustomHeader(
          function: controller.confirmDescription,
          title: 'Add team membres',
        ),
      ),
      body: Obx(
        () {
          if (controller.usersLoaded.isTrue) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('Me', style: TextStyleHelper.body2()),
                ),
                SizedBox(height: 26),
                TeamMembersItem(
                  controller: controller,
                  user: controller.selfUserItem,
                ),
                SizedBox(height: 26),
                Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('Users', style: TextStyleHelper.body2()),
                ),
                SizedBox(height: 26),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (c, i) => TeamMembersItem(
                        user: controller.allUsers[i], controller: controller),
                    itemExtent: 65.0,
                    itemCount: controller.allUsers.length,
                  ),
                ),
              ],
            );
          } else {
            return ListLoadingSkeleton();
          }
        },
      ),
    );
  }
}

class TeamMembersItem extends StatelessWidget {
  const TeamMembersItem({
    Key key,
    @required this.controller,
    @required this.user,
  }) : super(key: key);

  final NewProjectController controller;
  final PortalUserItem user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        user.isSelected.value = !user.isSelected.value;
        controller.selectTeamMember(user);
      },
      child: Container(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 72,
              child: AppIcon(
                  width: 40,
                  height: 40,
                  icon: SvgIcons.avatar,
                  color: Theme.of(context).customColors().onSurface),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.portalUser.displayName,
                                style: TextStyleHelper.subtitle1(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (user.isSelected.isTrue) {
                return SizedBox(width: 72, child: Icon(Icons.check_box));
              } else {
                return SizedBox(
                    width: 72,
                    child: Icon(Icons.check_box_outline_blank_outlined));
              }
            }),
          ],
        ),
      ),
    );
  }
}
