import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/subtasks/new_subtask_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';
import 'package:projects/presentation/views/new_task/tiles/responsible_tile.dart';

class NewSubtaskView extends StatelessWidget {
  const NewSubtaskView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(NewSubtaskController());
    controller.init();

    int taskId = Get.arguments['taskId'];

    return Scaffold(
      appBar: StyledAppBar(
        titleText: 'Add subtask',
        onLeadingPressed: controller.leaveNewSubtaskPage,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded),
            onPressed: () =>
                controller.confirmSubtask(context: context, taskId: taskId),
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
                                autofocus: true,
                                style: TextStyleHelper.subtitle1(
                                    color: Theme.of(context)
                                        .customColors()
                                        .onBackground),
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Describe subtask...',
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
            ResponsibleTile(
              controller: controller,
              enableUnderline: false,
              suffixIcon: IconButton(
                icon: Icon(Icons.clear_rounded,
                    size: 20,
                    color: Theme.of(context)
                        .customColors()
                        .onSurface
                        .withOpacity(0.6)),
                onPressed: controller.clearResponsibles,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
