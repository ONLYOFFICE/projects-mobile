part of '../discussions_filter_screen.dart';

class _CreatingDate extends StatelessWidget {
  final DiscussionsFilterController filterController;
  const _CreatingDate({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('creationDate'),
        options: <Widget>[
          FilterElement(
              title: tr('today'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.creationDate['today'],
              onTap: () => filterController.changeCreationDate(('today'))),
          FilterElement(
              title: tr('last7Days'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.creationDate['last7Days'],
              onTap: () => filterController.changeCreationDate(('last7Days'))),
          FilterElement(
              title: tr('customPeriod'),
              isSelected: filterController.creationDate['custom']['selected'],
              onTap: () =>
                  selectDateRange(context, filterController: filterController)),
        ],
      ),
    );
  }
}

Future selectDateRange(
  BuildContext context, {
  DiscussionsFilterController filterController,
}) async {
  var pickedRange = await showStyledDateRangePicker(
    context: context,
    initialDateRange: DateTimeRange(
      start: filterController.creationDate['custom']['startDate'],
      end: filterController.creationDate['custom']['stopDate'],
    ),
  );

  if (pickedRange != null) {
    await filterController.changeCreationDate(
      'custom',
      start: pickedRange.start,
      stop: pickedRange.end,
    );
  }
}
