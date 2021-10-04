import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_task.dart';
import 'package:projects/domain/controllers/tasks/task_editing_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/new_task/tiles/description_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/due_date_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/milestone_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/priority_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/responsible_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/start_date_tile.dart';
import 'package:projects/presentation/views/new_task/tiles/task_title.dart';
import 'package:projects/presentation/views/task_editing_view/elements/status_selection_bottom_sheet.dart';

class TaskEditingView extends StatelessWidget {
  const TaskEditingView({
    Key key,
    @required this.task,
  }) : super(key: key);

  final PortalTask task;

  @override
  Widget build(BuildContext context) {
    var controller =
        Get.put(TaskEditingController(task: task), permanent: false);

    // controller.init();
    return WillPopScope(
      onWillPop: () async {
        controller.discardChanges();
        return false;
      },
      child: Scaffold(
        appBar: StyledAppBar(
          titleText: tr('editTask'),
          onLeadingPressed: controller.discardChanges,
          actions: [
            IconButton(
                icon: const Icon(Icons.done_rounded),
                onPressed: () => controller.confirm())
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              TaskTitle(
                  controller: controller,
                  showCaption: true,
                  focusOnTitle: false),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.only(left: 72, right: 16),
                child: OutlinedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await statusSelectionBS(
                        context: context,
                        controller: controller,
                      );
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((_) {
                      return const Color(0xff81C4FF).withOpacity(0.1);
                    }),
                    side: MaterialStateProperty.resolveWith((_) {
                      return const BorderSide(
                          color: Colors.transparent, width: 1.5);
                    }),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Obx(() => Text(
                                  controller.newStatus.value.title,
                                  style: TextStyleHelper.subtitle2())))),
                      const Icon(Icons.arrow_drop_down_sharp)
                    ],
                  ),
                ),
              ),
              DescriptionTile(controller: controller),
              MilestoneTile(controller: controller),
              StartDateTile(controller: controller),
              DueDateTile(controller: controller),
              PriorityTile(controller: controller),
              ResponsibleTile(controller: controller, enableUnderline: false)
            ],
          ),
        ),
      ),
    );
  }
}
