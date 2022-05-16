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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_edit_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/option_with_switch.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/advanced_options.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/description.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/project_manager.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/tags.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/team_members.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/title.dart';

class EditProjectView extends StatelessWidget {
  const EditProjectView({Key? key}) : super(key: key);

  static String get pageName => tr('editProject');

  @override
  Widget build(BuildContext context) {
    final editProjectController = Get.find<ProjectEditController>();
    editProjectController.setupEditor(Get.arguments['projectDetailed'] as ProjectDetailed);
    final platformController = Get.find<PlatformController>();
    return WillPopScope(
      onWillPop: () async {
        editProjectController.discardChanges();
        return false;
      },
      child: Scaffold(
        backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
        appBar: StyledAppBar(
          backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
          titleText: tr('editProject'),
          centerTitle: !GetPlatform.isAndroid,
          leadingWidth: GetPlatform.isIOS ? 100 : null,
          leading: PlatformWidget(
            cupertino: (_, __) => CupertinoButton(
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              onPressed: editProjectController.discardChanges,
              child: Text(
                tr('cancel').toLowerCase().capitalizeFirst!,
                style: TextStyleHelper.button(),
              ),
            ),
            material: (_, __) => IconButton(
              onPressed: editProjectController.discardChanges,
              icon: const Icon(Icons.close),
            ),
          ),
          actions: [
            PlatformWidget(
              material: (platformContext, __) => IconButton(
                icon: const Icon(Icons.check_rounded),
                onPressed: editProjectController.confirmChanges,
              ),
              cupertino: (platformContext, __) => CupertinoButton(
                onPressed: editProjectController.confirmChanges,
                padding: const EdgeInsets.only(right: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  tr('done'),
                  style: TextStyleHelper.headline7(),
                ),
              ),
            ),
          ],
        ),
        body: Obx(
          () {
            if (editProjectController.loaded.value == true) {
              return ListView(
                children: [
                  ProjectTitleTile(
                    controller: editProjectController,
                    showCaption: true,
                  ),
                  const StyledDivider(leftPadding: 72),
                  ProjectDescriptionTile(controller: editProjectController),
                  ProjectManagerTile(controller: editProjectController),
                  TeamMembersTile(controller: editProjectController),
                  TagsTile(controller: editProjectController),
                  AdvancedOptions(
                    options: [
                      const StyledDivider(leftPadding: 72),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(72, 2, 16, 2),
                        child: OptionWithSwitch(
                          title: tr('privateProject'),
                          switchValue: editProjectController.isPrivate,
                          switchOnChanged: (bool value) {
                            editProjectController.setPrivate(value);
                          },
                        ),
                      ),
                      const StyledDivider(leftPadding: 72),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(72, 2, 16, 2),
                        child: OptionWithSwitch(
                          title: tr('notifyPM'),
                          switchValue: editProjectController.notificationEnabled,
                          switchOnChanged: (bool value) {
                            editProjectController.enableNotification(value);
                          },
                        ),
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
