part of '../tasks_filter.dart';

class _Status extends StatelessWidget {
  final TaskFilterController filterController;
  const _Status({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('status'),
        options: <Widget>[
          FilterElement(
              title: tr('open'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.status['open'],
              onTap: () => filterController.changeStatus('open')),
          FilterElement(
              title: tr('closed'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.status['closed'],
              onTap: () => filterController.changeStatus('closed')),
        ],
      ),
    );
  }
}
