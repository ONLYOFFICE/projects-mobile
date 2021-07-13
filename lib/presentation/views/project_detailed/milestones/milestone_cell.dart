import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestone_cell_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/cell_atributed_title.dart';

class MilestoneCell extends StatelessWidget {
  final Milestone milestone;
  const MilestoneCell({Key key, this.milestone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var itemController = Get.put(MilestoneCellController(milestone),
        tag: milestone.id.toString());

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _MilestoneIcon(
            itemController: itemController,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () => {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _SecondColumn(
                          milestone: milestone,
                          itemController: itemController,
                        ),
                        const SizedBox(width: 8),
                        _ThirdColumn(
                          milestone: milestone,
                          controller: itemController,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondColumn extends StatelessWidget {
  final Milestone milestone;
  final MilestoneCellController itemController;

  const _SecondColumn({
    Key key,
    @required this.milestone,
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
          Obx(() {
            var style;
            if (itemController.milestone.value.status == 1) {
              style = TextStyleHelper.projectTitle.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Get.theme.colors().onSurface.withOpacity(0.6));
            } else if (itemController.milestone.value.status == 2) {
              style = TextStyleHelper.projectTitle.copyWith(
                  color: Get.theme.colors().onSurface.withOpacity(0.6));
            } else {
              style = TextStyleHelper.projectTitle;
            }
            return CellAtributedTitle(
              text: milestone.title,
              style: style,
              atributeIcon: AppIcon(icon: SvgIcons.atribute),
              atributeIconVisible: itemController.milestone.value.isKey,
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Obx(() {
                var color = itemController.milestone.value.canEdit
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
                    milestone.responsible.displayName.replaceAll(' ', '\u00A0'),
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
  final Milestone milestone;
  final MilestoneCellController controller;

  const _ThirdColumn({
    Key key,
    @required this.milestone,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (milestone.deadline != null)
          Text(
            formatedDate(milestone.deadline),
            style: milestone.deadline.isBefore(_now)
                ? TextStyleHelper.caption(color: Get.theme.colors().colorError)
                : TextStyleHelper.caption(color: Get.theme.colors().onSurface),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AppIcon(
              icon: SvgIcons.check_square,
              color: const Color(0xff666666),
              width: 20,
              height: 20,
            ),
            Text(
              milestone.activeTaskCount.toString(),
              style: TextStyleHelper.body2(
                color: Get.theme.colors().onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MilestoneIcon extends StatelessWidget {
  const _MilestoneIcon({
    Key key,
    @required this.itemController,
  }) : super(key: key);

  final MilestoneCellController itemController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          var color = itemController.milestone.value.canEdit
              ? Get.theme.colors().primary
              : Get.theme.colors().background;
          return Container(
            width: 48,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.05),
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
                        icon: SvgIcons.milestone,
                        color: Get.theme.colors().onBackground.withOpacity(0.6),
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ),
                AppIcon(icon: itemController.statusImage, color: color),
              ],
            ),
          );
        }),
      ],
    );
  }
}
