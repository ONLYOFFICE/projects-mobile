import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';

class SubtasksView extends StatelessWidget {
  final TaskItemController controller;
  const SubtasksView({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _task = controller.task.value;
    return ListView.separated(
      itemCount: _task.subtasks.length,
      padding: const EdgeInsets.symmetric(vertical: 6),
      separatorBuilder: (BuildContext context, int index) {
        return Divider(indent: 56, thickness: 1);
      },
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Row(
            children: [
              SizedBox(
                  width: 52,
                  child: Icon(
                      _task.subtasks[index].status == 2
                          ? Icons.check_box
                          : Icons.check_box_outline_blank_rounded,
                      color: Color(0xFF666666))),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_task.subtasks[index].title,
                        style: _task.subtasks[index].status == 2
                            ? TextStyleHelper.subtitle1(
                                    color: const Color(0xff9C9C9C))
                                .copyWith(
                                    decoration: TextDecoration.lineThrough)
                            : TextStyleHelper.subtitle1()),
                    Text(_task.subtasks[index].responsible.displayName,
                        style: TextStyleHelper.caption(
                            color: _task.subtasks[index].status == 2
                                ? const Color(0xffc2c2c2)
                                : Theme.of(context)
                                    .customColors()
                                    .onBackground
                                    .withOpacity(0.6))),
                  ],
                ),
              ),
              SizedBox(
                width: 52,
                child: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(child: Text('Accept task')),
                      PopupMenuItem(child: Text('Copy task')),
                      PopupMenuItem(child: Text('Delete task')),
                    ];
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
