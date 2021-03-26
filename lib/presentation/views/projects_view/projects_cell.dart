import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/data/models/item.dart';
import 'package:projects/domain/controllers/projects/project_cell_controller.dart';

import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectCell extends StatelessWidget {
  final Item item;
  const ProjectCell({this.item});

  @override
  Widget build(BuildContext context) {
    var itemController =
        Get.put(ProjectCellController(item), tag: item.id.toString());

    return VisibilityDetector(
      key: Key('${item.id.toString()}_${item.title}'),
      onVisibilityChanged: itemController.handleVisibilityChanged,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProjectIcon(
              itemController: itemController,
            ),
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
    @required this.itemController,
  }) : super(key: key);

  final ProjectCellController itemController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.all(16),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AppIcon(icon: SvgIcons.subtasks, color: const Color(0xff666666)),
          AppIcon(
            icon: SvgIcons.back_round,
            // color: const Color(0xff666666),
            width: 40,
            height: 40,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: AppIcon(
              icon: SvgIcons.project_icon,
              // color: const Color(0xff666666),
              width: 16,
              height: 16,
            ),
          ),
          AppIcon(
              icon: itemController.statusImage, color: const Color(0xff666666)),
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
  final ProjectCellController itemController;

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
            children: <Widget>[
              Flexible(
                child: DropCapText(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.projectTitle,
                  dropCapPadding: EdgeInsets.only(top: 4),
                  dropCap: DropCap(
                    width: 12,
                    height: 12,
                    child: AppIcon(icon: SvgIcons.lock),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Text(
                itemController.statusName,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  '•',
                  style: TextStyleHelper.projectResponsible,
                ),
              ),
              Flexible(
                child: Text(
                  item.responsible.displayName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleHelper.projectResponsible,
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
  final ProjectCellController controller;

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
