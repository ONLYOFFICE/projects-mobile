part of '../milestones_filter.dart';

class _Status extends StatelessWidget {
  const _Status({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<MilestonesFilterController>();
    return Obx(
      () => FiltersRow(
        title: 'Status',
        options: <Widget>[
          FilterElement(
              title: 'Active',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.status['active'],
              onTap: () => filterController.changeStatus('active')),
          FilterElement(
              title: 'Closed',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.status['closed'],
              onTap: () => filterController.changeStatus('closed')),
        ],
      ),
    );
  }
}
