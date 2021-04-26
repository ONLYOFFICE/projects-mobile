import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';
import 'package:projects/presentation/views/new_task/tiles/description_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/due_date_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/milestone_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/priority_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/project_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/responsible_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/start_date_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/task_title.dart';

class NewTaskView extends StatelessWidget {
  const NewTaskView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewTaskController>();

    return Scaffold(
      backgroundColor: Theme.of(context).customColors().backgroundColor,
      appBar: StyledAppBar(
        titleText: 'New task',
        actions: [
          IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: () => controller.confirm())
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              const SizedBox(height: 16),
              TaskTitle(controller: controller),
              ProjectTile(controller: controller),
              if (controller.slectedProjectTitle.value.isNotEmpty)
                MilestoneTile(controller: controller),
              if (controller.slectedProjectTitle.value.isNotEmpty)
                ResponsibleTile(controller: controller),
              DescriptionTile(controller: controller),
              StartDateTile(controller: controller),
              DueDateTile(controller: controller),
              const SizedBox(height: 5),
              PriorityTile(controller: controller)
            ],
          ),
        ),
      ),
    );
  }
}

class NewTaskInfo extends StatelessWidget {
  final int maxLines;
  final bool isSelected;
  final bool enableBorder;
  final TextStyle textStyle;
  final String text;
  final String icon;
  final String caption;
  final Function() onTap;
  final Color textColor;
  final Widget suffix;
  final EdgeInsetsGeometry suffixPadding;

  const NewTaskInfo({
    Key key,
    this.caption,
    this.enableBorder = true,
    this.icon,
    this.isSelected = false,
    this.maxLines,
    this.onTap,
    this.suffix,
    this.suffixPadding = const EdgeInsets.symmetric(horizontal: 25),
    this.textColor,
    this.textStyle,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 56,
                child: icon != null
                    ? AppIcon(
                        icon: icon,
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.6))
                    : null,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical:
                          caption != null && caption.isNotEmpty ? 10 : 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (caption != null && caption.isNotEmpty)
                        Text(caption,
                            style: TextStyleHelper.caption(
                                color: Theme.of(context)
                                    .customColors()
                                    .onBackground
                                    .withOpacity(0.75))),
                      Text(text,
                          maxLines: maxLines,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle ??
                              TextStyleHelper.subtitle1(
                                  color: textColor ?? isSelected
                                      ? Theme.of(context)
                                          .customColors()
                                          .onBackground
                                      : Theme.of(context)
                                          .customColors()
                                          .onSurface
                                          .withOpacity(0.6))),
                    ],
                  ),
                ),
              ),
              if (suffix != null)
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(padding: suffixPadding, child: suffix)),
            ],
          ),
          if (enableBorder) const StyledDivider(leftPadding: 56.5),
        ],
      ),
    );
  }
}
