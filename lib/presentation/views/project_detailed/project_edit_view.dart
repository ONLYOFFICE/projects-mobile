import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_edit_controller.dart';

import 'package:projects/presentation/shared/widgets/info_tile.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';

import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/project_detailed/project_overview.dart';
import 'package:projects/presentation/views/projects_view/new_project/new_project_view.dart';

class EditProjectView extends StatelessWidget {
  final ProjectDetailed projectDetailed;

  const EditProjectView({Key key, @required this.projectDetailed})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    var editProjectController =
        Get.put(ProjectEditController(Get.arguments['projectDetailed']));
    editProjectController.setupEditor();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: StyledAppBar(
        titleText: tr('editProject'),
        elevation: 2,
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
          if (editProjectController.loaded.isTrue) {
            return ListView(
              children: [
                const SizedBox(height: 26),
                Obx(() => InfoTile(
                      caption: tr('project').toUpperCase(),
                      subtitle: editProjectController.projectTitleText.value,
                      subtitleStyle: TextStyleHelper.headline7(
                          color: Theme.of(context).customColors().onBackground),
                    )),
                const SizedBox(height: 20),
                ProjectStatusButton(projectController: editProjectController),
                const SizedBox(height: 20),
                DescriptionTile(controller: editProjectController),
                InkWell(
                  onTap: () {
                    Get.toNamed('ProjectManagerSelectionView',
                        arguments: {'controller': editProjectController});
                  },
                  child: ProjectManager(
                    controller: editProjectController,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed('TeamMembersSelectionView',
                        arguments: {'controller': editProjectController});
                  },
                  child: TeamMembers(
                    controller: editProjectController,
                  ),
                ),
                // TODO add tag edit screen
                // Obx(() => InfoTile(
                //     icon: AppIcon(
                //         icon: SvgIcons.tag, color: const Color(0xff707070)),
                //     caption: tr('tags'),
                //     subtitle: editProjectController.tagsText.value)),
                AdvancedEditOptions(controller: editProjectController),
              ],
            );
          }
        },
      ),
    );
  }
}

class AdvancedEditOptions extends StatelessWidget {
  const AdvancedEditOptions({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    expandedAlignment: Alignment.topLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: AppIcon(
                              icon: SvgIcons.preferences,
                              height: 24,
                              width: 24,
                              color: Theme.of(context)
                                  .customColors()
                                  .onSurface
                                  .withOpacity(0.6)),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          tr('advancedOptions'),
                          style: TextStyleHelper.subtitle1(
                              color:
                                  Theme.of(context).customColors().onSurface),
                        ),
                      ],
                    ),
                    children: <Widget>[
                      OptionWithSwitch(
                        title: tr('privateProject'),
                        switchValue: controller.isPrivate,
                        switchOnChanged: (value) {
                          controller.setPrivate(value);
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 56,
                  endIndent: 0,
                  color: Color(0xffD8D8D8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
