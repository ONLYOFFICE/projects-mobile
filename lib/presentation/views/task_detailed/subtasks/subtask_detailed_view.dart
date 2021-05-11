import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';

class SubtaskDetailedView extends StatelessWidget {
  const SubtaskDetailedView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SubtaskController controller = Get.arguments['controller'];

    return Obx(
      () {
        var _subtask = controller.subtask.value;
        return Scaffold(
          appBar: StyledAppBar(
            actions: [
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, size: 26),
                offset: const Offset(0, 25),
                onSelected: (value) => _onSelected(context, value, controller),
                itemBuilder: (context) {
                  return [
                    if (_subtask.canEdit && _subtask.responsible == null)
                      const PopupMenuItem(
                          value: 'Accept', child: Text('Accept')),
                    if (_subtask.canEdit)
                      const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'Copy', child: Text('Copy')),
                    if (_subtask.canEdit)
                      const PopupMenuItem(
                          value: 'Delete', child: Text('Delete')),
                  ];
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          child: Checkbox(
                            value: _subtask.status == 2,
                            activeColor: const Color(0xFF666666),
                            onChanged: (value) {
                              controller.updateSubtaskStatus(
                                context: context,
                                taskId: _subtask.taskId,
                                subtaskId: _subtask.id,
                              );
                            },
                          ),
                        ),
                        Obx(() => Expanded(
                              child: Text(_subtask.title,
                                  style: controller.subtask.value.status == 2
                                      ? TextStyleHelper.subtitle1(
                                              color: const Color(0xff9C9C9C))
                                          .copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough)
                                      : TextStyleHelper.subtitle1()),
                            )),
                        const SizedBox(width: 4),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const StyledDivider(leftPadding: 56)
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                        width: 56,
                        child: AppIcon(
                            icon: SvgIcons.person,
                            color: Theme.of(context)
                                .customColors()
                                .onSurface
                                .withOpacity(0.6))),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Assigned to:',
                              style: TextStyleHelper.caption(
                                  color: Theme.of(context)
                                      .customColors()
                                      .onBackground
                                      .withOpacity(0.75))),
                          Text(
                            _subtask?.responsible?.displayName ??
                                'No responsible',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleHelper.subtitle1(
                                color:
                                    Theme.of(context).customColors().onSurface),
                          ),
                        ],
                      ),
                    ),
                    if (_subtask.responsible != null && _subtask.canEdit)
                      IconButton(
                        icon: Icon(Icons.clear_rounded,
                            color: Theme.of(context)
                                .customColors()
                                .onSurface
                                .withOpacity(0.6)),
                        onPressed: () => controller.deleteSubtaskResponsible(
                            taskId: _subtask.taskId, subtaskId: _subtask.id),
                      )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

void _onSelected(context, value, SubtaskController controller) {
  switch (value) {
    case 'Accept':
      controller.acceptSubtask(
        context,
        taskId: controller.subtask.value.taskId,
        subtaskId: controller.subtask.value.id,
      );
      break;
    case 'Edit':
      Get.toNamed('NewSubtaskView', arguments: {
        'taskId': controller.subtask.value.taskId,
        'forEditing': true,
        'subtask': controller.subtask.value,
      });
      break;
    case 'Copy':
      controller.copySubtask(
        context,
        taskId: controller.subtask.value.taskId,
        subtaskId: controller.subtask.value.id,
      );
      break;
    case 'Delete':
      controller.deleteSubtask(
        taskId: controller.subtask.value.taskId,
        subtaskId: controller.subtask.value.id,
        closePage: true,
      );
      break;
    default:
  }
}
