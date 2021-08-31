part of '../tasks_filter.dart';

class _Project extends StatelessWidget {
  final TaskFilterController filterController;
  const _Project({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('project'),
        options: <Widget>[
          FilterElement(
              title: tr('myProjects'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.project['my'],
              onTap: () => filterController.changeProject('my')),
          FilterElement(
              title: filterController.project['other'].isEmpty
                  ? tr('otherProjects')
                  : filterController.project['other'],
              isSelected: filterController.project['other'].isNotEmpty,
              cancelButtonEnabled: filterController.project['other'].isNotEmpty,
              onTap: () async {
                var selectedProject = await Get.find<NavigationController>()
                    .toScreen(SelectProjectScreen());
                filterController.changeProject('other', selectedProject);
              },
              onCancelTap: () => filterController.changeProject('other', null)),
          FilterElement(
              title: filterController.project['withTag'].isEmpty
                  ? tr('withTag')
                  : filterController.project['withTag'],
              isSelected: filterController.project['withTag'].isNotEmpty,
              cancelButtonEnabled:
                  filterController.project['withTag'].isNotEmpty,
              onTap: () async {
                var selectedTag = await Get.find<NavigationController>()
                    .toScreen(const SelectTagScreen());
                filterController.changeProject('withTag', selectedTag);
              },
              onCancelTap: () =>
                  filterController.changeProject('withTag', null)),
          FilterElement(
              title: tr('withoutTag'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.project['withoutTag'],
              onTap: () => filterController.changeProject('withoutTag')),
        ],
      ),
    );
  }
}
