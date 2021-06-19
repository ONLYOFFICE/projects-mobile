import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';

import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/cell_atributed_title.dart';
import 'package:projects/presentation/shared/widgets/task_status_bottom_sheet.dart'
    as bottom_sheet;

class TaskCell extends StatelessWidget {
  final PortalTask task;
  const TaskCell({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: omit_local_variable_types
    TaskItemController itemController =
        Get.put(TaskItemController(task), tag: task.id.toString());

    return InkWell(
      onTap: () => Get.toNamed('TaskDetailedView',
          arguments: {'controller': itemController}),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () async => itemController.tryChangingStatus(context),
                child: TaskStatus(itemController: itemController)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SecondColumn(
                          task: task,
                          itemController: itemController,
                        ),
                        const SizedBox(width: 8),
                        ThirdColumn(
                          task: task,
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

// refactor
class TaskStatus extends StatelessWidget {
  final TaskItemController itemController;

  const TaskStatus({
    Key key,
    @required this.itemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DecoratedBox(
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Color(0xffD8D8D8)),
        child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(0.5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).customColors().background),
            child: Center(
              child: SVG.createSizedFromString(
                  itemController.statusImageString.value,
                  16,
                  16,
                  itemController.status.value.color),
            )),
      ),
    );
  }
}

// refactor
class SecondColumn extends StatelessWidget {
  final PortalTask task;
  final TaskItemController itemController;

  const SecondColumn({
    Key key,
    @required this.task,
    @required this.itemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CellAtributedTitle(
                text: task.title,
                style: TextStyleHelper.projectTitle,
                atributeIcon: AppIcon(icon: SvgIcons.high_priority),
                atributeIconVisible: task.priority == 1,
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      itemController.status.value.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleHelper.status(
                          color: itemController.status.value.color.toColor()),
                    ),
                  ),
                  Text(' • ',
                      style: TextStyleHelper.caption(
                          color: Theme.of(context)
                              .customColors()
                              .onSurface
                              .withOpacity(0.6))),
                  Flexible(
                    child: Text(task.createdBy.displayName,
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
      },
    );
  }
}

class ThirdColumn extends StatelessWidget {
  final PortalTask task;
  final TaskItemController controller;

  const ThirdColumn({
    Key key,
    @required this.task,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _now = DateTime.now();

    DateTime _deadline;
    if (task.deadline != null) _deadline = DateTime.parse(task.deadline);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_deadline != null)
          Text(formatedDateFromString(now: _now, stringDate: task.deadline),
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
            Text(task.subtasks.length.toString(),
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
