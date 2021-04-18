import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';

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
              icon: Icon(Icons.check_rounded),
              onPressed: () => controller.confirm())
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 56, right: 16, top: 16),
                child: TextField(
                  autofocus: true,
                  maxLines: 2,
                  style: TextStyleHelper.headline6(
                      color: Theme.of(context).customColors().onBackground),
                  cursorColor: Theme.of(context)
                      .customColors()
                      .primary
                      .withOpacity(0.87),
                  decoration: InputDecoration(
                      hintText: 'Task title',
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      hintStyle: TextStyleHelper.headline6(
                          color: Theme.of(context)
                              .customColors()
                              .onSurface
                              .withOpacity(0.5)),
                      border: InputBorder.none),
                ),
              ),
              NewTaskInfo(
                text: controller.selectedProjectTitle.isEmpty
                    ? 'Select project'
                    : controller.selectedProjectTitle.value,
                icon: SvgIcons.project,
                textColor: controller.selectProjectError.isTrue
                    ? Theme.of(context).customColors().error
                    : null, //default color
                onTap: () => Get.toNamed('SelectProjectView'),
              ),
              if (controller.selectedProjectTitle.isNotEmpty)
                NewTaskInfo(
                  text: controller.selectedMilestoneTitle.isEmpty
                      ? 'Add milestone'
                      : controller.selectedMilestoneTitle.value,
                  icon: SvgIcons.milestone,
                  onTap: () => Get.toNamed('SelectMilestoneView'),
                ),
              if (controller.selectedProjectTitle.isNotEmpty)
                NewTaskInfo(text: 'Add responsible', icon: SvgIcons.person),
              NewTaskInfo(
                text: controller.description.value.isEmpty
                    ? 'Add description'
                    : controller.description.value,
                onTap: () => Get.toNamed('NewTaskDescription'),
              ),
              NewTaskInfo(icon: SvgIcons.start_date, text: 'Set start date'),
              NewTaskInfo(icon: SvgIcons.due_date, text: 'Set due date'),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 56),
                    child: Text('High priority',
                        style: TextStyleHelper.subtitle1(
                            color: Theme.of(context).customColors().onSurface)),
                  ),
                  Switch(
                    value: controller.highPriority.value,
                    onChanged: (value) => controller.changePriority(value),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewTaskInfo extends StatelessWidget {
  final String icon;
  final Function() onTap;
  final String text;
  final TextStyle textStyle;
  final Color textColor;
  final bool enableBorder;
  const NewTaskInfo({
    Key key,
    this.icon,
    this.onTap,
    this.textStyle,
    this.textColor,
    this.enableBorder = true,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(text,
                      style: textStyle ??
                          TextStyleHelper.subtitle1(
                              color: textColor ??
                                  Theme.of(context)
                                      .customColors()
                                      .onSurface
                                      .withOpacity(0.6))),
                ),
              ),
            ],
          ),
          if (enableBorder) StyledDivider(leftPadding: 56.5),
        ],
      ),
    );
  }
}
