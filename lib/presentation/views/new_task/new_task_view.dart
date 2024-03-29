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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/internal/utils/text_utils.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/views/new_task/tiles/description_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/due_date_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/milestone_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/new_task_project_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/notify_responsibles.dart';
import 'package:projects/presentation/views/new_task/tiles/priority_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/responsible_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/start_date_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/task_title.dart';

class NewTaskView extends StatelessWidget {
  const NewTaskView({Key? key}) : super(key: key);

  static String get pageName => tr('newTask');

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewTaskController>();
    final platformController = Get.find<PlatformController>();
    final projectDetailed = Get.arguments['projectDetailed'] as ProjectDetailed?;
    controller.init(projectDetailed);

    return WillPopScope(
      onWillPop: () async {
        controller.discardTask();
        return false;
      },
      child: Scaffold(
        backgroundColor: platformController.isMobile
            ? Theme.of(context).colors().backgroundColor
            : Theme.of(context).colors().surface,
        appBar: StyledAppBar(
          backgroundColor: platformController.isMobile
              ? Theme.of(context).colors().backgroundColor
              : Theme.of(context).colors().surface,
          titleText: tr('newTask'),
          leadingWidth: GetPlatform.isIOS
              ? TextUtils.getTextWidth(
                    tr('cancel').toLowerCase().capitalizeFirst!,
                    TextStyleHelper.button(),
                  ) +
                  16
              : null,
          centerTitle: GetPlatform.isIOS,
          actions: [
            PlatformIconButton(
              materialIcon: const Icon(Icons.check_rounded),
              cupertinoIcon: Text(
                tr('done'),
                style: TextStyleHelper.headline7(color: Theme.of(context).colors().primary),
              ),
              onPressed: controller.confirm,
            ),
          ],
          leading: PlatformIconButton(
            materialIcon: const Icon(Icons.close),
            cupertinoIcon: Text(
              tr('cancel').toLowerCase().capitalizeFirst!,
              style: TextStyleHelper.body1(color: Theme.of(context).colors().primary),
            ),
            onPressed: controller.discardTask,
            cupertino: (_, __) => CupertinoIconButtonData(
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                const SizedBox(height: 10),
                TaskTitle(controller: controller),
                const SizedBox(height: 10),
                const StyledDivider(leftPadding: 72.5),
                // unfocus title
                Listener(
                  onPointerDown: (_) {
                    if (controller.title.isNotEmpty && controller.titleFocus.hasFocus)
                      controller.titleFocus.unfocus();
                  },
                  child: Column(
                    children: [
                      NewTaskProjectTile(controller: controller),
                      if (controller.selectedProjectTitle.value.isNotEmpty)
                        MilestoneTile(controller: controller),
                      if (controller.selectedProjectTitle.value.isNotEmpty)
                        ResponsibleTile(controller: controller),
                      if (controller.responsibles.isNotEmpty)
                        NotifyResponsiblesTile(controller: controller),
                      DescriptionTile(controller: controller),
                      StartDateTile(controller: controller),
                      DueDateTile(controller: controller),
                      const SizedBox(height: 5),
                      PriorityTile(controller: controller)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
