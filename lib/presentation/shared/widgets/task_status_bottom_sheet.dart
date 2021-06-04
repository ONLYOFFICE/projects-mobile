import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/domain/controllers/tasks/task_status_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/svg_manager.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/bottom_sheets/customBottomSheet.dart';

void showsStatusesBS({context, TaskItemController taskItemController}) async {
  var _statusesController = Get.find<TaskStatusesController>();
  showCustomBottomSheet(
    context: context,
    headerHeight: 60,
    initHeight:
        _getInititalSize(statusCount: _statusesController.statuses.length),
    // maxHeight: 0.7,
    decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
    headerBuilder: (context, bottomSheetOffset) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18.5),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text('Select status',
                style: TextStyleHelper.h6(
                    color: Theme.of(context).customColors().onSurface)),
          ),
          const SizedBox(height: 18.5),
        ],
      );
    },
    builder: (context, bottomSheetOffset) {
      return SliverChildListDelegate(
        [
          Obx(
            () => DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 1,
                      color: Theme.of(context)
                          .customColors()
                          .outline
                          .withOpacity(0.5)),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 4),
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
                              _statusesController.statusImagesDecoded[i],
                              16,
                              16),
                          selected: _statusesController.statuses[i].title ==
                              taskItemController.status.value.title),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
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

double _getInititalSize({int statusCount}) {
  var size = (statusCount * 75) / Get.height;
  return size > 0.7 ? 0.7 : size;
}
