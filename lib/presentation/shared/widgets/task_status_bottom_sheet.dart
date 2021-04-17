import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class BottomSheet extends StatelessWidget {
  final TaskItemController taskItemController;
  const BottomSheet({Key key, @required this.taskItemController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _statusesController = Get.find<TaskStatusesController>();

    return Container(
      height: Get.height / 2,
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 18.5),
              child: SizedBox(
                height: 4,
                width: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .customColors()
                          .onSurface
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Select status',
              style: TextStyleHelper.h6(),
            ),
          ),
          const SizedBox(height: 14.5),
          Divider(height: 9),
          Flexible(
            child: ListView(
              children: [
                for (var i = 0; i < _statusesController.statuses.length; i++)
                  InkWell(
                    onTap: () async {
                      await taskItemController.updateTaskStatus(
                          id: taskItemController.task.value.id,
                          newStatusId: _statusesController.statuses[i].id,
                          newStatusType:
                              _statusesController.statuses[i].statusType);
                      Get.back();
                    },
                    child: StatusTile(
                        title: _statusesController.statuses[i].title,
                        icon: SVG.createSizedFromString(
                            _statusesController.statusImagesDecoded[i], 16, 16),
                        selected: _statusesController.statuses[i].title ==
                            taskItemController.status.value.title),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final bool selected;

  const StatusTile({Key key, this.icon, this.title, this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration _selectedDecoration() {
      return BoxDecoration(
          color: Theme.of(context).customColors().bgDescription,
          borderRadius: BorderRadius.circular(6));
    }

    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
      decoration: selected ? _selectedDecoration() : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 48, child: icon),
                Flexible(
                    child: Text(title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyleHelper.body2())),
              ],
            ),
          ),
          if (selected)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.done_rounded,
                color: Theme.of(context).customColors().primary,
              ),
            )
        ],
      ),
    );
  }
}
