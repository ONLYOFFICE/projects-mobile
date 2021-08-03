/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_edit_controller.dart';

import 'package:projects/presentation/shared/widgets/info_tile.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';

import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/project_detailed/project_overview.dart';
import 'package:projects/presentation/views/projects_view/new_project/new_project_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:projects/presentation/views/projects_view/new_project/team_members_view.dart';

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
      backgroundColor: Get.theme.backgroundColor,
      appBar: StyledAppBar(
        titleText: tr('editProject'),
        elevation: 1,
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
                Obx(() => InfoTile(
                      caption: tr('project').toUpperCase(),
                      subtitle: editProjectController.projectTitleText.value,
                      subtitleStyle: TextStyleHelper.headline7(
                          color: Get.theme.colors().onBackground),
                    )),
                const SizedBox(height: 20),
                ProjectStatusButton(projectController: editProjectController),
                const SizedBox(height: 20),
                DescriptionTile(controller: editProjectController),
                InkWell(
                  onTap: () {
                    Get.find<NavigationController>().showScreen(
                        const ProjectManagerSelectionView(),
                        arguments: {'controller': editProjectController});
                  },
                  child: ProjectManager(
                    controller: editProjectController,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.find<NavigationController>().showScreen(
                        const TeamMembersSelectionView(),
                        arguments: {'controller': editProjectController});
                  },
                  child: TeamMembers(
                    controller: editProjectController,
                  ),
                ),
                InkWell(
                  onTap: () {
                    editProjectController.showTags();
                  },
                  child: _Tags(
                    controller: editProjectController,
                  ),
                ),
                _AdvancedEditOptions(controller: editProjectController),
              ],
            );
          } else {
            return const ListLoadingSkeleton();
          }
        },
      ),
    );
  }
}

class _AdvancedEditOptions extends StatelessWidget {
  const _AdvancedEditOptions({
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
                  data: Get.theme.copyWith(dividerColor: Colors.transparent),
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
                              color: Get.theme
                                  .colors()
                                  .onSurface
                                  .withOpacity(0.6)),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          tr('advancedOptions'),
                          style: TextStyleHelper.subtitle1(
                              color: Get.theme.colors().onSurface),
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
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 56,
                  endIndent: 0,
                  color: Get.theme.colors().outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tags extends StatelessWidget {
  const _Tags({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 56,
            child: AppIcon(
                icon: SvgIcons.tag, color: Get.theme.colors().onSurface),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Obx(
                  () => controller.tags.isNotEmpty
                      ? NewProjectTile(
                          subtitle: controller.tagsText.value,
                          onTapFunction: () {
                            controller.showTags();
                          },
                          title: tr('tags'),
                          iconData: Icons.navigate_next)
                      : Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  controller.showTags();
                                },
                                child: Text(
                                  tr('addTag'),
                                  style: TextStyleHelper.subtitle1(
                                    color: Get.theme
                                        .colors()
                                        .onSurface
                                        .withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Get.theme.colors().outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
