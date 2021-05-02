import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestone_cell_controller.dart';

import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

import 'package:projects/presentation/shared/widgets/app_icons.dart';

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
          GestureDetector(
              onTap: () async {
                // bottom_sheet.showsStatusesBS(
                //     context: context, taskItemController: itemController);
              },
              child: TaskStatus(itemController: itemController)),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () => Get.toNamed('TaskDetailedView',
                  arguments: {'controller': itemController}),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SecondColumn(
                          milestone: milestone,
                          itemController: itemController,
                        ),
                        const SizedBox(width: 8),
                        ThirdColumn(
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

// refactor
class TaskStatus extends StatelessWidget {
  final MilestoneCellController itemController;

  const TaskStatus({
    Key key,
    @required this.itemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Color(0xffD8D8D8)),
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(0.5),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).customColors().background),
        // child: Center(
        //   child: SVG.createSizedFromString(
        //       itemController.statusImageString.value,
        //       16,
        //       16,
        //       itemController.status.value.color),
        // ),
      ),
    );
  }
}

// refactor
class SecondColumn extends StatelessWidget {
  final Milestone milestone;
  final MilestoneCellController itemController;

  const SecondColumn({
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
          Wrap(
            children: [
              Text(
                milestone.title,
                maxLines: 2,
                softWrap: true,
                style: TextStyleHelper.projectTitle,
                overflow: TextOverflow.ellipsis,
              ),
              // if (milestone.priority == 1) const SizedBox(width: 6),
              // if (milestone.priority == 1) AppIcon(icon: SvgIcons.high_priority)
            ],
          ),
          Row(
            children: [
              // Flexible(
              // child: Text(
              //   itemController.status.value.title,
              //   maxLines: 1,
              //   overflow: TextOverflow.ellipsis,
              //   style: TextStyleHelper.status(
              //       color: itemController.status.value.color.toColor()),
              // ),
              // ),
              Text(' • ',
                  style: TextStyleHelper.caption(
                      color: Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.6))),
              Flexible(
                child: Text(milestone.createdBy.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleHelper.caption(
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.6))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ThirdColumn extends StatelessWidget {
  final Milestone milestone;
  final MilestoneCellController controller;

  const ThirdColumn({
    Key key,
    @required this.milestone,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _now = DateTime.now();

    DateTime _deadline;
    if (milestone.deadline != null) _deadline = milestone.deadline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_deadline != null)
          Text(formatedDate(milestone.deadline),
              style: _deadline.isBefore(_now)
                  ? TextStyleHelper.caption(
                      color: Theme.of(context).customColors().error)
                  : TextStyleHelper.caption(
                      color: Theme.of(context).customColors().onSurface)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppIcon(icon: SvgIcons.subtasks, color: const Color(0xff666666)),
            const SizedBox(width: 5),
            Text(milestone.activeTaskCount.toString(),
                style: TextStyleHelper.body2(
                    color: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.6))),
          ],
        ),
      ],
    );
  }
}
