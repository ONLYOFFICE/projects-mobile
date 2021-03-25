import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/task.dart';

import 'package:projects/domain/controllers/task_item_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TaskCell extends StatelessWidget {
  final PortalTask task;
  const TaskCell({this.task});

  @override
  Widget build(BuildContext context) {

    // ignore: omit_local_variable_types
    TaskItemController itemController =
        Get.put(TaskItemController(task), tag: task.id.toString());

    return VisibilityDetector(
      key: Key('${task.id.toString()}_${task.title}'),
      onVisibilityChanged: itemController.handleVisibilityChanged,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.bottomSheet(BottomSheet(title: 'Select status')),
              child: TaskStatus(itemController: itemController)),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => Get.toNamed('TaskDetailedView'),
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
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {

  final String title;
  const BottomSheet({
    Key key,
    this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 464,
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 18.5),
              child: SizedBox(
                height: 4,
                width: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).customColors().onSurface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2)
                  ),
                ),
              ),
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: TextStyleHelper.h6,
              ),
            ),
          Divider(),
        ],
      ),
    );
  }
}

class TaskStatus extends StatelessWidget {

  final TaskItemController itemController;

  const TaskStatus({
    Key key,
    @required this.itemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xffD8D8D8)
      ),
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(0.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).customColors().background
        ),
        child: Obx(() {
          return (itemController.statusImageString.value == null ||
                itemController.statusImageString.value.isEmpty)
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(),
            )
          : Center(child: SVG.createSizedFromString(
                itemController.statusImageString.value, 16, 16, 
                itemController.status.value.color),
          );
        }),
      ),
    );
  }
}

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
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Flexible(
                child: Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.projectTitle,
                ),
              ),
              const SizedBox(width: 6),
              if (task.priority == 1)
              AppIcon(
                icon: SvgIcons.high_priority,
              )
            ],
          ),
          Row(
            children: [
              Obx(() {
                return (itemController.statusImageString.value == null ||
                        itemController.statusImageString.value.isEmpty)
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      itemController.status.value.title,
                      style: TextStyleHelper
                          .taskStatus(itemController.status.value.color.toColor()));
              }),
              Text(
                ' • ', 
                style: TextStyleHelper.projectResponsible),
              Text(
                task.createdBy.displayName, 
                style: TextStyleHelper.projectResponsible),
            ],
          ),
        ],
      ),
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

    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (task.deadline != null)
            Text(task.formatedDate(now: _now, stringDate: task.deadline), 
                style: TextStyleHelper.projectDate),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppIcon(icon: SvgIcons.subtasks, color: const Color(0xff666666)),
              const SizedBox(width: 5),
              Text(
                task.subtasks.length.toString(), 
                style: TextStyleHelper.projectCompleatedTasks
              ),
            ],
          ),
        ],
      ),
    );
  }
}
