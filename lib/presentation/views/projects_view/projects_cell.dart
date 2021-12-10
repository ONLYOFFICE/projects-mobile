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
import 'package:event_hub/event_hub.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/projects/project_cell_controller.dart';
import 'package:projects/domain/controllers/projects/project_status_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/internal/utils/name_formatter.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/cell_atributed_title.dart';
import 'package:projects/presentation/shared/widgets/custom_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/status_tile.dart';
import 'package:projects/presentation/views/project_detailed/project_detailed_view.dart';

class ProjectCell extends StatelessWidget {
  final ProjectDetailed item;
  const ProjectCell({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemController = Get.find<ProjectCellController>();
    itemController.setup(item);

    return SizedBox(
      height: 72,
      child: InkWell(
        onTap: () => Get.find<NavigationController>()
            .to(ProjectDetailedView(), arguments: {'projectDetailed': itemController.projectData}),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (item.canEdit!)
              InkWell(
                onTap: () async =>
                    showsStatusesBS(context: context, itemController: itemController),
                child: ProjectIcon(itemController: itemController),
              )
            else
              ProjectIcon(itemController: itemController),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _Content(
                          item: item,
                          itemController: itemController,
                        ),
                        const SizedBox(width: 8),
                        _Suffix(
                          item: item,
                          controller: itemController,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Obx(() {
          final color = itemController.canEdit.value == true
              ? Get.theme.colors().primary
              : Get.theme.colors().onBackground;
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
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
              AppIcon(icon: itemController.statusImage, color: color),
            ],
          );
        }),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final ProjectDetailed? item;
  final ProjectCellController itemController;

  const _Content({
    Key? key,
    required this.item,
    required this.itemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Obx(
            () {
              TextStyle style;
              if (itemController.status.value == 1) {
                style = TextStyleHelper.projectTitle.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Get.theme.colors().onSurface.withOpacity(0.6));
              } else if (itemController.status.value == 2) {
                style = TextStyleHelper.projectTitle
                    .copyWith(color: Get.theme.colors().onSurface.withOpacity(0.6));
              } else {
                style = TextStyleHelper.projectTitle;
              }
              return CellAtributedTitle(
                text: item!.title,
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
                return Text(
                  itemController.statusName,
                  style: TextStyleHelper.status(color: color),
                );
              }),
              Text(' • ',
                  style: TextStyleHelper.caption(
                      color: Get.theme.colors().onSurface.withOpacity(0.6))),
              Flexible(
                child: Text(NameFormatter.formateName(item!.responsible!)!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleHelper.caption(
                        color: Get.theme.colors().onSurface.withOpacity(0.6))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Suffix extends StatelessWidget {
  const _Suffix({
    Key? key,
    required this.item,
    required this.controller,
  }) : super(key: key);

  final ProjectDetailed? item;
  final ProjectCellController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            AppIcon(icon: SvgIcons.check_square, color: Get.theme.colors().onSurface),
            const SizedBox(width: 3),
            Text(
              item!.taskCount.toString(),
              style: TextStyleHelper.projectCompleatedTasks.copyWith(
                color: Get.theme.colors().onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 16)
          ],
        ),
      ],
    );
  }
}

void showsStatusesBS({required BuildContext context, dynamic itemController}) async {
  final _statusesController = Get.find<ProjectStatusesController>();
  showCustomBottomSheet(
    context: context,
    headerHeight: 60,
    initHeight: _getInititalSize(statusCount: _statusesController.statuses.length),
    // maxHeight: 0.7,
    decoration: BoxDecoration(
        color: Get.theme.colors().surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
    headerBuilder: (context, bottomSheetOffset) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18.5),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(tr('selectStatus'),
                style: TextStyleHelper.h6(color: Get.theme.colors().onSurface)),
          ),
          const SizedBox(height: 18.5),
        ],
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
                      onTap: () async {
                        final success = await itemController.updateStatus(
                          newStatusId: _statusesController.statuses[i],
                        ) as bool;
                        if (success) {
                          locator<EventHub>()
                              .fire('needToRefreshProjects', ['all']);
                        }
                        Get.back();
                      },
                      child: StatusTile(
                          title: _statusesController.getStatusName(i),
                          icon: AppIcon(
                              icon: _statusesController.getStatusImageString(i),
                              color: itemController.projectData.canEdit as bool
                                  ? Get.theme.colors().primary
                                  : Get.theme.colors().onBackground),
                          selected:
                              _statusesController.statuses[i] == itemController.projectData.status),
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
    {required BuildContext context,
    required BaseProjectEditorController itemController}) async {
  if (Get.find<PlatformController>().isMobile) {
    showsStatusesBS(context: context, itemController: itemController);
  } else {
    showsStatusesPM(context: context, itemController: itemController);
  }
}

void showsStatusesPM(
    {required BuildContext context,
    required BaseProjectEditorController itemController}) async {
  final _statusesController = Get.find<ProjectStatusesController>();
  final items = <PopupMenuEntry<dynamic>>[
    for (var i = 0; i < _statusesController.statuses.length; i++)
      PopupMenuItem(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Expanded(
          child: InkWell(
            onTap: () async {
              final success = await itemController.updateStatus(
                newStatusId: _statusesController.statuses[i],
              );
              if (success) {
                locator<EventHub>().fire('needToRefreshProjects');
              }
              Get.back();
            },
            child: StatusTileTablet(
                title: _statusesController.getStatusName(i),
                icon: AppIcon(
                    icon: _statusesController.getStatusImageString(i),
                    color: itemController.projectData!.canEdit!
                        ? Get.theme.colors().primary
                        : Get.theme.colors().onBackground),
                selected: _statusesController.statuses[i] ==
                    itemController.projectData!.status),
          ),
        ),
      ),
  ];

// calculate the menu position, ofsset dy: 50
  final offset = const Offset(0, 50);
  final button = context.findRenderObject() as RenderBox;
  final overlay = Get.overlayContext!.findRenderObject() as RenderBox;
  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(
        offset,
        ancestor: overlay,
      ),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero) + offset,
        ancestor: overlay,
      ),
    ),
    Offset.zero & overlay.size,
  );

  await showMenu(context: context, position: position, items: items);
}


double _getInititalSize({required int statusCount}) {
  final size = (statusCount * 50 + 65) / Get.height;
  return size > 0.7 ? 0.7 : size;
}
