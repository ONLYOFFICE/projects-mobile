import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/sort_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';

class TasksSort extends StatelessWidget {
  const TasksSort({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sortController = Get.find<TasksSortController>();
    return Obx(
      () => Container(
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
                          borderRadius: BorderRadius.circular(2))),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 16, top: 18.5),
                child: Text('Sort by',
                    style: TextStyleHelper.h6(
                        color: Theme.of(context).customColors().onSurface))),
            const SizedBox(height: 14.5),
            const Divider(height: 9),
            SortTile(
              title: 'Deadline',
              selected: sortController.currentSort.startsWith('Deadline'),
              onTap: () {
                sortController.changeCurrentSort('Deadline');
                Get.back();
              },
            ),
            SortTile(
              title: 'Priority',
              selected: sortController.currentSort.startsWith('Priority'),
              onTap: () {
                sortController.changeCurrentSort('Priority');
                Get.back();
              },
            ),
            SortTile(
              title: 'Creation date',
              selected: sortController.currentSort.startsWith('Creation date'),
              onTap: () {
                sortController.changeCurrentSort('Creation date');
                Get.back();
              },
            ),
            SortTile(
              title: 'Start date',
              selected: sortController.currentSort.startsWith('Start date'),
              onTap: () {
                sortController.changeCurrentSort('Start date');
                Get.back();
              },
            ),
            SortTile(
              title: 'Title',
              selected: sortController.currentSort.startsWith('Title'),
              onTap: () {
                sortController.changeCurrentSort('Title');
                Get.back();
              },
            ),
            SortTile(
              title: 'Order',
              selected: sortController.currentSort.startsWith('Order'),
              onTap: () {
                sortController.changeCurrentSort('Order');
                Get.back();
              },
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}

class SortTile extends StatelessWidget {
  final String title;
  final bool selected;
  final Function onTap;

  const SortTile({Key key, this.title, this.selected = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration _selectedDecoration() {
      return BoxDecoration(
          color: Theme.of(context).customColors().bgDescription,
          borderRadius: BorderRadius.circular(6));
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
        padding: const EdgeInsets.only(left: 12, right: 20),
        decoration: selected ? _selectedDecoration() : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child: Text(title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyleHelper.body2()))
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.done_rounded,
                color: Theme.of(context).customColors().primary,
              )
          ],
        ),
      ),
    );
  }
}
