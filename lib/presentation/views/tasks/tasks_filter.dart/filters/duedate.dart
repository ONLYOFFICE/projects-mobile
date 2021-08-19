part of '../tasks_filter.dart';

class _DueDate extends StatelessWidget {
  final TaskFilterController filterController;
  const _DueDate({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('dueDate'),
        options: <Widget>[
          FilterElement(
              title: tr('overdue'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.deadline['overdue'],
              onTap: () => filterController.changeDeadline('overdue')),
          FilterElement(
              title: tr('today'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.deadline['today'],
              onTap: () => filterController.changeDeadline('today')),
          FilterElement(
              title: tr('upcoming'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.deadline['upcoming'],
              onTap: () => filterController.changeDeadline('upcoming')),
          FilterElement(
              title: tr('customPeriod'),
              isSelected: filterController.deadline['custom']['selected'],
              onTap: () =>
                  selectDateRange(context, filterController: filterController)),
        ],
      ),
    );
  }
}

Future selectDateRange(
  BuildContext context, {
  TaskFilterController filterController,
}) async {
  var pickedRange = await showStyledDateRangePicker(
    context: context,
    initialDateRange: DateTimeRange(
      start: filterController.deadline['custom']['startDate'],
      end: filterController.deadline['custom']['stopDate'],
    ),
  );
  if (pickedRange != null) {
    await filterController.changeDeadline('custom',
        start: pickedRange.start, stop: pickedRange.end);
  }
}
