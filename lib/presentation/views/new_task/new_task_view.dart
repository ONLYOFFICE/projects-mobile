import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/new_task/styled_app_bar.dart';

class NewTaskView extends StatelessWidget {
  const NewTaskView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _newTaskController = Get.find<NewTaskController>();

    return Scaffold(
      backgroundColor: Theme.of(context).customColors().backgroundColor,
      appBar: StyledAppBar(),
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
              Row(
                children: [
                  SizedBox(width: 56),
                  TextButton(
                      onPressed: () => Get.toNamed('SelectProjectView'),
                      child: Text('Select project'))
                ],
              ),
              // NewTaskInfo(
              //     hintText: 'Select project',
              //     controller: _newTaskController.projectFieldC,
              //     onChanged: (value) =>
              //         _newTaskController.projectSelected.value = true,
              //     icon: AppIcon(
              //         icon: SvgIcons.project,
              //         color: Theme.of(context)
              //             .customColors()
              //             .onSurface
              //             .withOpacity(0.6))),
              if (_newTaskController.projectSelected.isTrue)
                NewTaskInfo(
                  hintText: 'Add milestone',
                  icon: AppIcon(
                      icon: SvgIcons.milestone,
                      color: Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.6)),
                ),
              if (_newTaskController.projectSelected.isTrue)
                NewTaskInfo(
                    hintText: 'Add responsible',
                    icon: AppIcon(
                        icon: SvgIcons.person,
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.6))),
              NewTaskInfo(hintText: 'Add description'),
              NewTaskInfo(
                  icon: AppIcon(
                      icon: SvgIcons.start_date,
                      color: Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.6)),
                  hintText: 'Set start date'),
              NewTaskInfo(
                icon: AppIcon(
                    icon: SvgIcons.due_date,
                    color: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.6)),
                hintText: 'Set due date',
              ),
              NewTaskInfo(
                hintText: 'High priority',
                hintTextStyle: TextStyleHelper.subtitle1(
                    color: Theme.of(context).customColors().onSurface),
                enableBorder: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewTaskInfo extends StatelessWidget {
  final Widget icon;
  final TextEditingController controller;
  final Function(String value) onChanged;
  final String hintText;
  final TextStyle hintTextStyle;
  final bool enableBorder;
  const NewTaskInfo(
      {Key key,
      this.icon,
      this.controller,
      this.onChanged,
      this.hintText,
      this.hintTextStyle,
      this.enableBorder = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 56,
          child: icon,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            cursorColor:
                Theme.of(context).customColors().primary.withOpacity(0.87),
            decoration: InputDecoration(
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                counterStyle: TextStyle(color: Colors.red),
                hintStyle: hintTextStyle ??
                    TextStyleHelper.subtitle1(
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.6)),
                suffixIcon: Icon(Icons.close),
                border: enableBorder
                    ? UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: const Color(0xffD8D8D8)))
                    : InputBorder.none),
          ),
        )
      ],
    );
  }
}
