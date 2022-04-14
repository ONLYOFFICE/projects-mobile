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
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/detailed_project_controller.dart';
import 'package:projects/domain/controllers/projects/project_cell_controller.dart';
import 'package:projects/domain/controllers/projects/project_status_controller.dart';
import 'package:projects/internal/utils/name_formatter.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/cell_atributed_title.dart';
import 'package:projects/presentation/shared/widgets/custom_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/status_tile.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_popup_menu_item.dart';
import 'package:projects/presentation/views/project_detailed/project_detailed_view.dart';

class ProjectCell extends StatelessWidget {
  const ProjectCell({Key? key, required this.projectDetails}) : super(key: key);

  final ProjectDetailed projectDetails;

  @override
  Widget build(BuildContext context) {
    ProjectCellController itemController;
    if (Get.isRegistered<ProjectCellController>(tag: projectDetails.id.toString()))
      itemController = Get.find<ProjectCellController>(tag: projectDetails.id.toString());
    else {
      itemController = Get.put(
        ProjectCellController(),
        tag: projectDetails.id.toString(),
      );
    }
    itemController.setup(projectDetails);

    ProjectDetailsController projectController;
    if (Get.isRegistered<ProjectDetailsController>(tag: projectDetails.id.toString()))
      projectController = Get.find<ProjectDetailsController>(tag: projectDetails.id.toString());
    else {
      projectController = Get.put(
        ProjectDetailsController(),
        tag: projectDetails.id.toString(),
      );
    }
    projectController.fillProjectInfo(projectDetails);

    return InkWell(
      onTap: () {
        Get.find<NavigationController>().to(
          ProjectDetailedView(),
          arguments: {'projectController': projectController},
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 72,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProjectIcon(
              itemController: itemController,
            ),
            Expanded(
              child: _Content(
                itemController: itemController,
              ),
            ),
            const SizedBox(width: 24),
            _Suffix(
              projectController: projectController,
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectIcon extends StatelessWidget {
  const ProjectIcon({
    Key? key,
    required this.itemController,
  }) : super(key: key);

  final ProjectCellController itemController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: itemController.projectData.canEdit!
          ? () => showStatuses(context: context, itemController: itemController)
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 16),
          Obx(() {
            final color = itemController.canEdit.value == true
                ? Get.theme.colors().primary
                : Get.theme.colors().onBackground;
            final statusImage = itemController.statusImageString.value;
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Get.theme.colors().primary.withOpacity(0.1),
                      ),
                      color: Get.theme.colors().background,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: AppIcon(
                        icon: SvgIcons.project_icon,
                        color: Color(0xff666666),
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ),
                ),
                AppIcon(icon: statusImage, color: color),
              ],
            );
          }),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final ProjectCellController itemController;

  const _Content({
    Key? key,
    required this.itemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Obx(
          () {
            TextStyle style;
            if (itemController.status.value == 1) {
              style =
                  TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface.withOpacity(0.6))
                      .copyWith(decoration: TextDecoration.lineThrough);
            } else if (itemController.status.value == 2) {
              style =
                  TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface.withOpacity(0.6));
            } else {
              style = TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface);
            }
            return CellAtributedTitle(
              text: itemController.projectData.title,
              style: style,
              atributeIcon: const AppIcon(icon: SvgIcons.lock),
              atributeIconVisible: itemController.isPrivate.value == true,
            );
          },
        ),
        Row(
          children: [
            Obx(() {
              final color = itemController.canEdit.value == true
                  ? Get.theme.colors().primary
                  : Get.theme.colors().onBackground;
              final status = itemController.statusNameString.value;
              return Text(
                status,
                style: TextStyleHelper.status(color: color),
              );
            }),
            Text(' • ',
                style:
                    TextStyleHelper.caption(color: Get.theme.colors().onSurface.withOpacity(0.6))),
            Flexible(
              child: Text(NameFormatter.formateName(itemController.projectData.responsible!)!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.caption(
                      color: Get.theme.colors().onSurface.withOpacity(0.6))),
            ),
          ],
        ),
      ],
    );
  }
}

class _Suffix extends StatelessWidget {
  const _Suffix({
    Key? key,
    required this.projectController,
  }) : super(key: key);

  final ProjectDetailsController projectController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppIcon(icon: SvgIcons.check_square, color: Get.theme.colors().onSurface),
        const SizedBox(width: 3),
        SizedBox(
          width: 20,
          child: Obx(
            () => Text(
              projectController.taskCount.value.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyleHelper.body2(
                color: Get.theme.colors().onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16)
      ],
    );
  }
}

void showsStatusesBS(
    {required BuildContext context, required BaseProjectEditorController itemController}) {
  final _statusesController = Get.find<ProjectStatusesController>();
  showCustomBottomSheet(
    context: context,
    headerHeight: 60,
    initHeight: _getInitialSize(statusCount: _statusesController.statuses.length),
    decoration: BoxDecoration(
        color: Get.theme.colors().surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
    headerBuilder: (context, bottomSheetOffset) {
      return Container(
        decoration: BoxDecoration(
            color: Get.theme.colors().surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(tr('selectStatus'),
                  style: TextStyleHelper.headline6(color: Get.theme.colors().onSurface)),
            ),
          ],
        ),
      );
    },
    builder: (context, bottomSheetOffset) {
      return SliverChildListDelegate(
        [
          Obx(
            () => DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1, color: Get.theme.colors().outline.withOpacity(0.5)),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  for (var i = 0; i < _statusesController.statuses.length; i++)
                    InkWell(
                      onTap: () {
                        itemController.updateStatus(
                          newStatusId: _statusesController.statuses[i],
                        );

                        Get.back();
                      },
                      child: StatusTile(
                          title: _statusesController.getStatusName(i),
                          icon: AppIcon(
                              icon: _statusesController.getStatusImageString(i),
                              color: itemController.projectData!.canEdit!
                                  ? Get.theme.colors().primary
                                  : Get.theme.colors().onBackground),
                          selected: _statusesController.statuses[i] ==
                              itemController.projectData!.status!),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showStatuses(
    {required BuildContext context, required BaseProjectEditorController itemController}) {
  if (itemController.projectData!.canEdit!) {
    if (Get.find<PlatformController>().isMobile)
      showsStatusesBS(context: context, itemController: itemController);
    else
      showsStatusesPM(context: context, itemController: itemController);
  }
}

void showsStatusesPM(
    {required BuildContext context, required BaseProjectEditorController itemController}) {
  final _statusesController = Get.find<ProjectStatusesController>();

  showButtonMenu(
      context: context,
      itemBuilder: (_) {
        return [
          for (var i = 0; i < _statusesController.statuses.length; i++)
            PlatformPopupMenuItem(
              onTap: () {
                itemController.updateStatus(
                  newStatusId: _statusesController.statuses[i],
                );

                Get.back();
              },
              child: StatusTileTablet(
                  title: _statusesController.getStatusName(i),
                  icon: AppIcon(
                      icon: _statusesController.getStatusImageString(i),
                      color: itemController.projectData!.canEdit!
                          ? Get.theme.colors().primary
                          : Get.theme.colors().onBackground),
                  selected: _statusesController.statuses[i] == itemController.projectData!.status),
            ),
        ];
      });
}

double _getInitialSize({required int statusCount}) {
  final size = (statusCount * 50 + 65) / Get.height;
  return size > 0.7 ? 0.7 : size;
}
