part of '../projects_filter.dart';

class _ProjectManager extends StatelessWidget {
  const _ProjectManager({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<ProjectsFilterController>();
    return Obx(
      () => FiltersRow(
        title: 'Project manager',
        options: <Widget>[
          FilterElement(
              title: 'Me',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.projectManager['Me'],
              onTap: () => filterController.changeProjectManager('Me')),
          FilterElement(
            title: filterController.projectManager['Other'].isEmpty
                ? 'Other user'
                : filterController.projectManager['Other'],
            isSelected: filterController.projectManager['Other'].isNotEmpty,
            cancelButtonEnabled:
                filterController.projectManager['Other'].isNotEmpty,
            onTap: () async {
              var newUser = await Get.bottomSheet(UsersBottomSheet());
              await filterController.changeProjectManager('Other', newUser);
            },
            onCancelTap: () =>
                filterController.changeProjectManager('Other', null),
          ),
        ],
      ),
    );
  }
}
