import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/advanced_options.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/description.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/project_manager.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/tags.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/team_members.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/title.dart';

import 'package:projects/domain/controllers/projects/new_project/new_project_controller.dart';

class NewProject extends StatelessWidget {
  const NewProject({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewProjectController>();
    return WillPopScope(
      onWillPop: () async {
        controller.discardChanges();
        return false;
      },
      child: Scaffold(
        backgroundColor: Get.theme.backgroundColor,
        appBar: StyledAppBar(
          titleText: tr('project'),
          onLeadingPressed: controller.discardChanges,
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.check_outlined),
              onPressed: () => controller.confirm(context),
            )
          ],
        ),
        body: Listener(
          onPointerDown: (_) {
            if (controller.titleController.text.isNotEmpty &&
                controller.titleFocus.hasFocus) controller.titleFocus.unfocus();
          },
          child: ListView(
            children: [
              ProjectTitleTile(controller: controller),
              ProjectManagerTile(controller: controller),
              TeamMembersTile(controller: controller),
              ProjectDescriptionTile(controller: controller),
              TagsTile(controller: controller),
              AdvancedOptions(
                options: <Widget>[
                  OptionWithSwitch(
                    title: tr('notifyPM'),
                    switchValue: controller.notificationEnabled,
                    switchOnChanged: (value) {
                      controller.enableNotification(value);
                    },
                  ),
                  OptionWithSwitch(
                    title: tr('privateProject'),
                    switchValue: controller.isPrivate,
                    switchOnChanged: (value) {
                      controller.setPrivate(value);
                    },
                  ),
                  Obx(() {
                    if (controller.selfUserItem?.id ==
                        controller.selectedProjectManager.value?.id)
                      return OptionWithSwitch(
                        title: tr('followProject'),
                        switchValue: false.obs,
                        switchOnChanged: null,
                      );
                    else
                      return OptionWithSwitch(
                        title: tr('followProject'),
                        switchValue: controller.isFolowed,
                        switchOnChanged: (value) {
                          controller.folow(value);
                        },
                      );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
