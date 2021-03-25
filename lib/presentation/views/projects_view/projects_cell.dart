import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/data/models/item.dart';
import 'package:projects/domain/controllers/project_item_controller.dart';

import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectCell extends StatelessWidget {
  final Item item;
  const ProjectCell({this.item});

  @override
  Widget build(BuildContext context) {
    var itemController =
        Get.put(ProjectItemController(item), tag: item.id.toString());

    return VisibilityDetector(
      key: Key('${item.id.toString()}_${item.title}'),
      onVisibilityChanged: itemController.handleVisibilityChanged,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProjectIcon(),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SecondColumn(
                          item: item,
                          itemController: itemController,
                        ),
                        const SizedBox(width: 16),
                        ThirdColumn(
                          item: item,
                          controller: itemController,
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.all(16),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SVG.createSized('lib/assets/images/icons/back_round.svg', 40, 40),
          Positioned(
            bottom: 0,
            right: 0,
            child: SVG.createSized(
                'lib/assets/images/icons/project_icon.svg', 16, 16),
          ),
          SVG.createSized(
              'lib/assets/images/icons/project_statuses/checkmark.svg', 16, 16),
        ],
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
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              // Obx(
              //   () => (itemController.statusImageString.value == null ||
              //           itemController.statusImageString.value.isEmpty)
              //       ? SizedBox(
              //           width: 16,
              //           height: 16,
              //           child: CircularProgressIndicator(),
              //         )
              //       :
              SVG.createSized(
                  'lib/assets/images/icons/project_statuses/checkmark.svg',
                  16,
                  16),
              // SVG.createSizedFromString(
              //           itemController.statusImageString.value, 16, 16),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  '•',
                  style: TextStyleHelper.projectResponsible(Theme.of(context)),
                ),
              ),
              Flexible(
                child: Text(
                  item.responsible.displayName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.projectResponsible(Theme.of(context)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SVG.createSized(
                  'lib/assets/images/icons/check_square.svg', 20, 20),
              Text(
                item.subCount.toString(),
                style: TextStyleHelper.projectCompleatedTasks,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
