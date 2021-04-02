import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_filter_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/views/tasks_filter.dart/select_project.dart';
import 'package:projects/presentation/views/tasks_filter.dart/select_user.dart';

part 'filter_label.dart';
part 'filter_element.dart';
part 'filters/responsible.dart';
part 'filters/creator.dart';
part 'filters/project.dart';
part 'filters/milestone.dart';

class TasksFilter extends StatelessWidget {
  const TasksFilter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().onPrimarySurface,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
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
                padding: const EdgeInsets.only(left: 15, right: 16, top: 6),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              size: 26,
                              color: Theme.of(context).customColors().primary,
                            ),
                            onPressed: () => Get.back(),
                          ),
                          const SizedBox(width: 10),
                          Text('Filter',
                              style: TextStyleHelper.h6(
                                  color: Theme.of(context)
                                      .customColors()
                                      .onSurface))
                        ],
                      ),
                      TextButton(
                          onPressed: () => print('ok'),
                          child: Text('RESET',
                              style: TextStyleHelper.button(
                                  color: Theme.of(context)
                                      .customColors()
                                      .systemBlue)))
                    ])),
            const Divider(height: 18),
            const _Responsible(),
            const _Creator(),
            const _Project(),
            const _Milestone(),
            if (filterController.suitableTasksCount.value != -1)
              Center(
                child: TextButton(
                  onPressed: () async {
                    filterController.filter();
                    Get.back();
                  },
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                              (_) => EdgeInsets.only(
                                  left: Get.width * 0.243,
                                  right: Get.width * 0.243,
                                  top: 10,
                                  bottom: 12)),
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color>((_) {
                        return Theme.of(context).customColors().primary;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)))),
                  child: Text(
                      'SHOW ${filterController.suitableTasksCount.value} TASK',
                      style: TextStyleHelper.button(
                          color: Theme.of(context).customColors().onPrimary)),
                ),
              ),
            const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }
}
