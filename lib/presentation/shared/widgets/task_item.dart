import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/data/models/item.dart';
import 'package:projects/domain/controllers/project_item_controller.dart';

import 'package:projects/presentation/shared/custom_theme.dart';

import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TaskItem extends StatelessWidget {
  final Item item;
  const TaskItem({this.item});

  @override
  Widget build(BuildContext context) {
    // ignore: omit_local_variable_types
    ProjectItemController itemController =
        Get.put(ProjectItemController(item), tag: item.id.toString());

    return VisibilityDetector(
      key: Key('${item.id.toString()}_${item.title}'),
      onVisibilityChanged: itemController.handleVisibilityChanged,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TaskStatus(itemController: itemController),
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
                          item: item,
                          itemController: itemController,
                        ),
                        const SizedBox(width: 8),
                        ThirdColumn(
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

class TaskStatus extends StatelessWidget {
  final ProjectItemController itemController;

  const TaskStatus({
    Key key,
    @required this.itemController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: const Color(0xffD8D8D8)),
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(0.5),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).customColors().background),
        child: Obx(() {
          return (itemController.statusImageString.value == null ||
                  itemController.statusImageString.value.isEmpty)
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: SVG.createSizedFromString(
                      itemController.statusImageString.value, 16, 16),
                );
        }),
      ),
    );
  }
}

class SecondColumn extends StatelessWidget {
  const SecondColumn({
    Key key,
    @required this.item,
    @required this.itemController,
  }) : super(key: key);

  final Item item;
  final ProjectItemController itemController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              item.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyleHelper.projectTitle,
            ),
          ),
          // const SizedBox(height: 8),
          Row(
            children: [
              Obx(() {
                return (itemController.statusImageString.value == null ||
                        itemController.statusImageString.value.isEmpty)
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(),
                      )
                    : Text(_getStatus(item.status),
                        style: TextStyleHelper.projectStatus);
              }),
              Text(
                ' • ',
                style: TextStyleHelper.projectResponsible,
              ),
              Text(
                item.responsible.displayName,
                style: TextStyleHelper.projectResponsible,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _getStatus(int status) {
  if (status == 1) {
    return 'Open';
  }
  if (status == 2) {
    return 'Closed';
  }

  return 'FIXME';
}

class ThirdColumn extends StatelessWidget {
  const ThirdColumn({
    Key key,
    @required this.item,
    @required this.controller,
  }) : super(key: key);

  final Item item;
  final ProjectItemController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            item.date,
            style: TextStyleHelper.projectDate,
          ),
        ],
      ),
    );
  }
}
