import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/project_cell_controller.dart';
import 'package:projects/domain/controllers/projects/project_status_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/internal/utils/name_formatter.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/cell_atributed_title.dart';
import 'package:projects/presentation/shared/widgets/customBottomSheet.dart';
import 'package:projects/presentation/shared/widgets/status_tile.dart';
import 'package:projects/presentation/views/project_detailed/project_detailed_view.dart';

class ProjectCell extends StatelessWidget {
  final ProjectDetailed item;
  const ProjectCell({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var itemController =
    //     Get.put(ProjectCellController(item), tag: item.id.toString());

    var itemController = Get.find<ProjectCellController>();
    itemController.setup(item);

    return Container(
      height: 72,
      child: InkWell(
        onTap: () => Get.find<NavigationController>().to(ProjectDetailedView(),
            arguments: {'projectDetailed': itemController.projectData}),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            item.canEdit
                ? InkWell(
                    onTap: () async => showsStatusesBS(
                        context: context, itemController: itemController),
                    child: ProjectIcon(itemController: itemController),
                  )
                : ProjectIcon(itemController: itemController),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _SecondColumn(
                          item: item,
                          itemController: itemController,
                        ),
                        const SizedBox(width: 8),
                        _ThirdColumn(
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
    Key key,
    @required this.itemController,
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
          var color = itemController.canEdit.value == true
              ? Get.theme.colors().primary
              : Get.theme.colors().onBackground;
          return Container(
            // width: 48,
            child: Stack(
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
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: AppIcon(
                        icon: SvgIcons.project_icon,
                        color: const Color(0xff666666),
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ),
                ),
                AppIcon(icon: itemController.statusImage, color: color),
              ],
            ),
          );
        }),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _SecondColumn extends StatelessWidget {
  final ProjectDetailed item;
  final ProjectCellController itemController;

  const _SecondColumn({
    Key key,
    @required this.item,
    @required this.itemController,
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
              var style;
              if (itemController.status.value == 1) {
                style = TextStyleHelper.projectTitle.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Get.theme.colors().onSurface.withOpacity(0.6));
              } else if (itemController.status.value == 2) {
                style = TextStyleHelper.projectTitle.copyWith(
                    color: Get.theme.colors().onSurface.withOpacity(0.6));
              } else {
                style = TextStyleHelper.projectTitle;
              }
              return CellAtributedTitle(
                text: item.title,
                style: style,
                atributeIcon: AppIcon(icon: SvgIcons.lock),
                atributeIconVisible: itemController.isPrivate.value == true,
              );
            },
          ),
          Row(
            children: [
              Obx(() {
                var color = itemController.canEdit.value == true
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
                child: Text(
                    NameFormatter.formateDisplayName(
                      item.responsible.displayName,
                    ),
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

class _ThirdColumn extends StatelessWidget {
  const _ThirdColumn({
    Key key,
    @required this.item,
    @required this.controller,
  }) : super(key: key);

  final ProjectDetailed item;
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
            AppIcon(
                icon: SvgIcons.check_square,
                color: Get.theme.colors().onSurface),
            const SizedBox(width: 3),
            Text(
              item.taskCount.toString(),
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

void showsStatusesBS({context, itemController}) async {
  var _statusesController = Get.find<ProjectStatusesController>();
  showCustomBottomSheet(
    context: context,
    headerHeight: 60,
    initHeight:
        _getInititalSize(statusCount: _statusesController.statuses.length),
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
                  top: BorderSide(
                      width: 1,
                      color: Get.theme.colors().outline.withOpacity(0.5)),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  for (var i = 0; i < _statusesController.statuses.length; i++)
                    InkWell(
                      onTap: () async {
                        await itemController.updateStatus(
                          newStatusId: _statusesController.statuses[i],
                        );
                        locator<EventHub>().fire('needToRefreshProjects');

                        Get.back();
                      },
                      child: StatusTile(
                          title: _statusesController.getStatusName(i),
                          icon: AppIcon(
                              icon: _statusesController.getStatusImageString(i),
                              color: itemController.projectData.canEdit
                                  ? Get.theme.colors().primary
                                  : Get.theme.colors().onBackground),
                          selected: _statusesController.statuses[i] ==
                              itemController.projectData.status),
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

double _getInititalSize({int statusCount}) {
  var size = ((statusCount * 75) + 16) / Get.height;
  return size > 0.7 ? 0.7 : size;
}
