import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/domain/controllers/tasks/subtasks/new_subtask_controller.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_action_controller.dart';
import 'package:projects/domain/controllers/tasks/subtasks/subtask_editing_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';
import 'package:projects/presentation/views/new_task/tiles/responsible_tile.dart';

class CreatingAndEditingSubtaskView extends StatelessWidget {
  const CreatingAndEditingSubtaskView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool forEditing = Get.arguments['forEditing'];

    SubtaskActionController controller;
    int taskId;

    if (forEditing) {
      controller = Get.put(SubtaskEditingController());
      Subtask subtask = Get.arguments['subtask'];
      controller.init(subtask: subtask);
    } else {
      taskId = Get.arguments['taskId'];
      controller = Get.put(NewSubtaskController());
      controller.init();
    }

    return Scaffold(
      appBar: StyledAppBar(
        titleText: forEditing ? tr('editSubtask') : tr('addSubtask'),
        onLeadingPressed: controller.leavePage,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded),
            onPressed: () =>
                controller.confirm(context: context, taskId: taskId),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 6),
            Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 56),
                  child: Row(
                    children: [
                      const SizedBox(
                          width: 56,
                          child: Icon(Icons.check_box_outline_blank,
                              color: Color(0xFF666666))),
                      Expanded(
                        child: Center(
                          child: Obx(() => TextField(
                                controller: controller.titleController,
                                maxLines: null,
                                // focusNode = null if subtaskEditingController
                                focusNode: controller.titleFocus,
                                style: TextStyleHelper.subtitle1(
                                    color: Theme.of(context)
                                        .customColors()
                                        .onBackground),
                                decoration: InputDecoration.collapsed(
                                  hintText: tr('describeSubtask'),
                                  hintStyle: TextStyleHelper.subtitle1(
                                      color: controller.setTiltleError.isTrue
                                          ? Theme.of(context)
                                              .customColors()
                                              .error
                                          : Theme.of(context)
                                              .customColors()
                                              .onBackground
                                              .withOpacity(0.5)),
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const StyledDivider(leftPadding: 56)
              ],
            ),
            Listener(
              onPointerDown: (_) {
                if (!forEditing) {
                  if (controller.titleController.text.isNotEmpty &&
                      controller.titleFocus.hasFocus)
                    controller.titleFocus.unfocus();
                }
              },
              child: ResponsibleTile(
                controller: controller,
                enableUnderline: false,
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear_rounded,
                      size: 20,
                      color: Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.6)),
                  onPressed: controller.deleteResponsible,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
