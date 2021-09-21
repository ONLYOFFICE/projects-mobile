import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_edit_controller.dart';

import 'package:projects/data/models/from_api/project_detailed.dart';

import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/project_detailed/project_overview.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/advanced_options.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/description.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/project_manager.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/tags.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/team_members.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/title.dart';

class EditProjectView extends StatelessWidget {
  final ProjectDetailed projectDetailed;

  const EditProjectView({Key key, @required this.projectDetailed})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    var editProjectController = Get.find<ProjectEditController>();
    editProjectController.setupEditor(Get.arguments['projectDetailed']);

    return WillPopScope(
      onWillPop: () async {
        editProjectController.discardChanges();
        return false;
      },
      child: Scaffold(
        backgroundColor: Get.theme.backgroundColor,
        appBar: StyledAppBar(
          titleText: tr('editProject'),
          elevation: 1,
          onLeadingPressed: editProjectController.discardChanges,
          actions: [
            IconButton(
              icon: const Icon(Icons.check_outlined),
              onPressed: () => {
                editProjectController.confirmChanges(),
              },
            )
          ],
        ),
        body: Obx(
          () {
            if (editProjectController.loaded.value == true) {
              return ListView(
                children: [
                  const SizedBox(height: 26),
                  ProjectTitleTile(controller: editProjectController),
                  const SizedBox(height: 20),
                  ProjectStatusButton(projectController: editProjectController),
                  const SizedBox(height: 20),
                  ProjectDescriptionTile(controller: editProjectController),
                  ProjectManagerTile(controller: editProjectController),
                  TeamMembersTile(controller: editProjectController),
                  TagsTile(controller: editProjectController),
                  AdvancedOptions(
                    options: <Widget>[
                      OptionWithSwitch(
                        title: tr('privateProject'),
                        switchValue: editProjectController.isPrivate,
                        switchOnChanged: (value) {
                          editProjectController.setPrivate(value);
                        },
                      ),
                      OptionWithSwitch(
                        title: tr('notifyPM'),
                        switchValue: editProjectController.notificationEnabled,
                        switchOnChanged: (value) {
                          editProjectController.enableNotification(value);
                        },
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const ListLoadingSkeleton();
            }
          },
        ),
      ),
    );
  }
}
