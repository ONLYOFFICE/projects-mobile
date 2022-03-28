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
import 'package:get/get.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/new_project_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/shared/wrappers/platform_widget.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/advanced_options.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/description.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/project_manager.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/tags.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/team_members.dart';
import 'package:projects/presentation/views/projects_view/new_project/tiles/title.dart';

class NewProject extends StatelessWidget {
  const NewProject({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platformController = Get.find<PlatformController>();
    final controller = Get.find<NewProjectController>();
    return WillPopScope(
      onWillPop: () async {
        controller.discardChanges();
        return false;
      },
      child: Scaffold(
        backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
        appBar: StyledAppBar(
          backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
          titleText: tr('project'),
          leadingWidth: GetPlatform.isIOS ? 100 : null,
          centerTitle: GetPlatform.isIOS,
          actions: [
            PlatformWidget(
              material: (platformContext, __) => IconButton(
                icon: const Icon(Icons.check_rounded),
                onPressed: controller.confirm,
              ),
              cupertino: (platformContext, __) => CupertinoButton(
                onPressed: controller.confirm,
                padding: const EdgeInsets.only(right: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  tr('done'),
                  style: TextStyleHelper.headline7(),
                ),
              ),
            ),
          ],
          leading: PlatformWidget(
            cupertino: (_, __) => CupertinoButton(
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              onPressed: controller.discardChanges,
              child: Text(
                tr('cancel').toLowerCase().capitalizeFirst!,
                style: TextStyleHelper.button(),
              ),
            ),
            material: (_, __) => IconButton(
              onPressed: controller.discardChanges,
              icon: const Icon(Icons.close),
            ),
          ),
        ),
        body: Listener(
          onPointerDown: (_) {
            if (controller.titleController.text.isNotEmpty && controller.titleFocus.hasFocus)
              controller.titleFocus.unfocus();
          },
          child: ListView(
            children: [
              ProjectTitleTile(controller: controller),
              const StyledDivider(leftPadding: 72.5),
              ProjectManagerTile(controller: controller),
              TeamMembersTile(controller: controller),
              ProjectDescriptionTile(controller: controller),
              TagsTile(controller: controller),
              AdvancedOptions(
                options: [
                  const StyledDivider(
                    leftPadding: 72,
                    height: 1,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(72, 2, 16, 2),
                    child: Obx(
                      () => OptionWithSwitch(
                        title: tr('notifyPM'),
                        switchValue: controller.notificationEnabled,
                        switchOnChanged: controller.selectedProjectManager.value?.id !=
                                controller.selfUserItem.id!
                            ? controller.enableNotification
                            : null,
                      ),
                    ),
                  ),
                  const StyledDivider(
                    leftPadding: 72,
                    height: 1,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(72, 2, 16, 2),
                    child: OptionWithSwitch(
                      title: tr('privateProject'),
                      switchValue: controller.isPrivate,
                      switchOnChanged: controller.setPrivate,
                    ),
                  ),
                  const StyledDivider(
                    leftPadding: 72,
                    height: 1,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(72, 2, 16, 2),
                    child: Obx(
                      () => OptionWithSwitch(
                        title: tr('followProject'),
                        switchValue: controller.isFolowed,
                        switchOnChanged: controller.selfUserItem.id! ==
                                controller.selectedProjectManager.value?.id
                            ? null
                            : controller.folow,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
