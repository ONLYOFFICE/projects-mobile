import 'package:easy_localization/easy_localization.dart';
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

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: InkWell(
        onTap: () => Get.toNamed('SubtaskDetailedView',
            arguments: {'controller': subtaskController}),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 6),
            Obx(
              () => Row(
                children: [
                  SizedBox(
                    width: 52,
                    child: Checkbox(
                      value: subtaskController.subtask.value.status == 2,
                      activeColor: const Color(0xFF666666),
                      onChanged: (value) {
                        subtaskController.updateSubtaskStatus(
                          context: context,
                          taskId: subtaskController.subtask.value.taskId,
                          subtaskId: subtaskController.subtask.value.id,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(subtask.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: subtaskController.subtask.value.status == 2
                                ? TextStyleHelper.subtitle1(
                                        color: const Color(0xff9C9C9C))
                                    .copyWith(
                                        decoration: TextDecoration.lineThrough)
                                : TextStyleHelper.subtitle1()),
                        Text(
                            subtaskController
                                    .subtask.value.responsible?.displayName ??
                                tr('nobody'),
                            style: TextStyleHelper.caption(
                                color:
                                    subtaskController.subtask.value.status == 2
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
                      onSelected: (value) =>
                          _onSelected(context, value, subtaskController),
                      itemBuilder: (context) {
                        return [
                          if (subtask.canEdit && subtask.responsible == null)
                            PopupMenuItem(
                                value: 'acceptSubtask',
                                child: Text('acceptSubtask',
                                    style: TextStyleHelper.subtitle1())),
                          PopupMenuItem(
                              value: 'copySubtask',
                              child: Text('copySubtask',
                                  style: TextStyleHelper.subtitle1())),
                          if (subtask.canEdit)
                            PopupMenuItem(
                                value: 'delete',
                                child: Text('delete',
                                    style: TextStyleHelper.subtitle1(
                                        color: Theme.of(context)
                                            .customColors()
                                            .error))),
                        ];
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Divider(indent: 56, thickness: 1, height: 1)
          ],
        ),
      ),
    );
  }
}

void _onSelected(context, value, SubtaskController controller) async {
  print(value);
  switch (value) {
    case 'acceptSubtask':
      controller.acceptSubtask(context,
          taskId: controller.subtask.value.taskId,
          subtaskId: controller.subtask.value.id);
      break;
    case 'copySubtask':
      controller.copySubtask(context,
          taskId: controller.subtask.value.taskId,
          subtaskId: controller.subtask.value.id);
      break;
    case 'delete':
      controller.deleteSubtask(
          taskId: controller.subtask.value.taskId,
          subtaskId: controller.subtask.value.id);
      break;
    default:
  }
}
