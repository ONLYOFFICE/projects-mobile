import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/projects/project_cell_controller.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class ProjectCell extends StatelessWidget {
  final ProjectDetailed item;
  const ProjectCell({this.item});

  @override
  Widget build(BuildContext context) {
    var itemController =
        Get.put(ProjectCellController(item), tag: item.id.toString());

    return Container(
      child: InkWell(
        onTap: () => Get.toNamed('ProjectDetailedView',
            arguments: {'controller': itemController}),
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
                        // const SizedBox(width: 16),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Container(
          width: 48,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).customColors().primary.withOpacity(0.1),
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
                      color: Theme.of(context)
                          .customColors()
                          .primary
                          .withOpacity(0.1),
                    ),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: AppIcon(
                      icon: SvgIcons.project_icon,
                      color: const Color(0xff666666),
                      width: 12,
                      height: 12,
                    ),
                  ),
                ),
              ),
              AppIcon(
                  icon: itemController.statusImage,
                  color: const Color(0xff666666)),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class SecondColumn extends StatelessWidget {
  const SecondColumn({
    Key key,
    @required this.item,
    @required this.itemController,
  }) : super(key: key);

  final ProjectDetailed item;
  final ProjectCellController itemController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DropCapText(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyleHelper.projectTitle,
            dropCapPadding: EdgeInsets.only(top: 4, right: 4),
            dropCap: DropCap(
              width: 12,
              height: 12,
              child: AppIcon(icon: SvgIcons.lock),
            ),
          ),
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
              Text(
                item.responsible.displayName,
                overflow: TextOverflow.ellipsis,
                style: TextStyleHelper.projectResponsible,
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
            SVG.createSized('lib/assets/images/icons/check_square.svg', 20, 20),
            Text(
              item.taskCount.toString(),
              style: TextStyleHelper.projectCompleatedTasks,
            ),
          ],
        ),
      ],
    );
  }
}
