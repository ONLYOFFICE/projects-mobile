part of '../projects_filter.dart';

class _Status extends StatelessWidget {
  const _Status({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<ProjectsFilterController>();
    return Obx(
      () => FiltersRow(
        title: 'Status',
        options: <Widget>[
          FilterElement(
              title: 'Active',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.status['Active'],
              onTap: () => filterController.changeStatus('Active')),
          FilterElement(
              title: 'Paused',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.status['Paused'],
              onTap: () => filterController.changeStatus('Paused')),
          FilterElement(
              title: 'Closed',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.status['Closed'],
              onTap: () => filterController.changeStatus('Closed')),
        ],
      ),
    );
  }
}
