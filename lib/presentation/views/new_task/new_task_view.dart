import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class NewTaskView extends StatelessWidget {
  const NewTaskView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _newTaskController = Get.find<NewTaskController>();

    return Scaffold(
      backgroundColor: Theme.of(context).customColors().backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).customColors().onPrimarySurface,
        iconTheme: IconThemeData(color: const Color(0xff1A73E9)),
        elevation: 1,
        actions: [
          IconButton(
              icon: Icon(Icons.check_rounded), onPressed: () => print('da'))
        ],
        title: Text('New task',
            style: TextStyleHelper.headline6(
                color: Theme.of(context).customColors().onSurface)),
      ),
      body: Obx(
        () => Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 56, right: 16),
              child: TextField(
                autofocus: true,
                maxLines: 2,
                style: TextStyleHelper.headline6(
                    color: Theme.of(context).customColors().onBackground),
                decoration: InputDecoration(
                    hintText: 'Task title',
                    hintStyle: TextStyleHelper.headline6(
                        color: Theme.of(context)
                            .customColors()
                            .onSurface
                            .withOpacity(0.5)),
                    border: InputBorder.none),
              ),
            ),
            NewTaskInfo(
                hintText: 'Select project',
                controller: _newTaskController.projectFieldC,
                onChanged: (value) =>
                    _newTaskController.projectSelected.value = true,
                icon: AppIcon(
                    icon: SvgIcons.project,
                    color: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.6))),
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
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: icon,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                  hintText: hintText,
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
      ),
    );
  }
}
