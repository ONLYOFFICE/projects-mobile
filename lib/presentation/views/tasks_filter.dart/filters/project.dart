part of '../tasks_filter.dart';

class _Project extends StatelessWidget {
  final TaskFilterController filterController;
  const _Project({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: 'Project',
        options: <Widget>[
          FilterElement(
              title: 'My projects',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.project['My'],
              onTap: () => filterController.changeProject('My')),
          FilterElement(
              title: filterController.project['Other'].isEmpty
                  ? 'Other projects'
                  : filterController.project['Other'],
              isSelected: filterController.project['Other'].isNotEmpty,
              cancelButtonEnabled: filterController.project['Other'].isNotEmpty,
              onTap: () async {
                var selectedProject =
                    await Get.bottomSheet(const ProjectsBottomSheet());
                filterController.changeProject('Other', selectedProject);
              },
              onCancelTap: () => filterController.changeProject('Other', null)),
          FilterElement(
              title: filterController.project['With tag'].isEmpty
                  ? 'With tag'
                  : filterController.project['With tag'],
              isSelected: filterController.project['With tag'].isNotEmpty,
              cancelButtonEnabled:
                  filterController.project['With tag'].isNotEmpty,
              onTap: () async {
                var selectedTag =
                    await Get.bottomSheet(const TagsBottomSheet());
                filterController.changeProject('With tag', selectedTag);
              },
              onCancelTap: () =>
                  filterController.changeProject('With tag', null)),
          FilterElement(
              title: 'Without tag',
              isSelected: filterController.project['Without tag'],
              onTap: () => filterController.changeProject('Without tag')),
        ],
      ),
    );
  }
}
