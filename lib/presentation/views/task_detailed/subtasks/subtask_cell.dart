import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class SubtaskCell extends StatelessWidget {
  final Subtask subtask;
  const SubtaskCell({
    Key key,
    @required this.subtask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var subtaskController = Get.put(SubtaskController(subtask: subtask),
        tag: subtask.id.toString());

    return InkWell(
      onTap: () => Get.toNamed('SubtaskDetailedView',
          arguments: {'controller': subtaskController}),
      child: Row(
        children: [
          SizedBox(
              width: 52,
              child: Icon(
                  subtask.status == 2
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_rounded,
                  color: const Color(0xFF666666))),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtask.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: subtask.status == 2
                        ? TextStyleHelper.subtitle1(
                                color: const Color(0xff9C9C9C))
                            .copyWith(decoration: TextDecoration.lineThrough)
                        : TextStyleHelper.subtitle1()),
                Text(subtask.responsible?.displayName ?? 'Nobody',
                    style: TextStyleHelper.caption(
                        color: subtask.status == 2
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
              onSelected: (value) {
                print(subtaskController.subtask.value.title);
                _onSelected(value, subtaskController);
              },
              itemBuilder: (context) {
                return [
                  if (subtask.canEdit)
                    PopupMenuItem(
                        value: 'Accept subtask',
                        child: Text('Accept subtask',
                            style: TextStyleHelper.subtitle1())),
                  PopupMenuItem(
                      value: 'Copy subtask',
                      child: Text('Copy subtask',
                          style: TextStyleHelper.subtitle1())),
                  PopupMenuItem(
                      value: 'Delete',
                      child: Text('Delete',
                          style: TextStyleHelper.subtitle1(
                              color: Theme.of(context).customColors().error))),
                ];
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _onSelected(value, SubtaskController controller) async {
  print(value);
  switch (value) {
    case 'Delete':
      controller.deleteSubtask(
          taskId: controller.subtask.value.taskId,
          subtaskId: controller.subtask.value.id);
      break;
    default:
  }
}
