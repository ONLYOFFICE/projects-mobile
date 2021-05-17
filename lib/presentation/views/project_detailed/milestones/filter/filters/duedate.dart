part of '../milestones_filter.dart';

class _DueDate extends StatelessWidget {
  const _DueDate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<MilestonesFilterController>();
    return Obx(
      () => FiltersRow(
        title: 'Due date',
        options: <Widget>[
          FilterElement(
              title: 'Overdue',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.deadline['overdue'],
              onTap: () => filterController.changeDeadline('overdue')),
          FilterElement(
              title: 'Today',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.deadline['today'],
              onTap: () => filterController.changeDeadline('today')),
          FilterElement(
              title: 'Upcoming',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.deadline['upcoming'],
              onTap: () => filterController.changeDeadline('upcoming')),
          FilterElement(
              title: 'Custom period',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.deadline['custom']['selected'],
              onTap: () =>
                  selectDateRange(context, filterController: filterController)),
        ],
      ),
    );
  }
}

Future selectDateRange(BuildContext context,
    {MilestonesFilterController filterController}) async {
  var pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: filterController.deadline['custom']['startDate'],
        end: filterController.deadline['custom']['stopDate'],
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      helpText: 'Select Date Range',
      cancelText: 'CANCEL',
      confirmText: 'OK',
      saveText: 'SAVE',
      errorFormatText: 'Invalid format.',
      errorInvalidText: 'Out of range.',
      errorInvalidRangeText: 'Invalid range.',
      fieldStartHintText: 'Start Date',
      fieldEndLabelText: 'End Date');

  if (pickedRange != null) {
    await filterController.changeDeadline('custom',
        start: pickedRange.start, stop: pickedRange.end);
  }
}
