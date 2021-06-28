part of '../projects_filter.dart';

class _Status extends StatelessWidget {
  const _Status({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController =
        Get.find<ProjectsFilterController>(tag: 'ProjectsView');
    return Obx(
      () => FiltersRow(
        title: tr('status'),
        options: <Widget>[
          FilterElement(
              title: tr('active'),
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.status['active'],
              onTap: () => filterController.changeStatus('active')),
          FilterElement(
              title: tr('paused'),
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.status['paused'],
              onTap: () => filterController.changeStatus('paused')),
          FilterElement(
              title: tr('closed'),
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.status['closed'],
              onTap: () => filterController.changeStatus('closed')),
        ],
      ),
    );
  }
}
