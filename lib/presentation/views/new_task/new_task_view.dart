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
import 'package:projects/presentation/views/new_task/tiles/notify_responsibles.dart';
import 'package:projects/presentation/views/new_task/tiles/priority_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/project_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/responsible_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/start_date_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/task_title.dart';

part 'new_task_info.dart';

class NewTaskView extends StatelessWidget {
  const NewTaskView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<NewTaskController>();
    controller.init();
    return Scaffold(
      backgroundColor: Theme.of(context).customColors().backgroundColor,
      appBar: StyledAppBar(
        titleText: 'New task',
        actions: [
          IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: () => controller.confirm(context))
        ],
        onLeadingPressed: controller.discardTask,
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              const SizedBox(height: 16),
              TaskTitle(controller: controller),
              // unfocus title
              Listener(
                onPointerDown: (_) {
                  if (controller.title.isNotEmpty &&
                      controller.titleFocus.hasFocus)
                    controller.titleFocus.unfocus();
                },
                child: Column(
                  children: [
                    ProjectTile(controller: controller),
                    if (controller.selectedProjectTitle.value.isNotEmpty)
                      MilestoneTile(controller: controller),
                    if (controller.selectedProjectTitle.value.isNotEmpty)
                      ResponsibleTile(controller: controller),
                    if (controller.responsibles.isNotEmpty)
                      NotifyResponsiblesTile(controller: controller),
                    DescriptionTile(controller: controller),
                    GestureDetector(
                        child: StartDateTile(controller: controller)),
                    DueDateTile(controller: controller),
                    const SizedBox(height: 5),
                    PriorityTile(controller: controller)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
