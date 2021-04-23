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
              title: 'me',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.projectManager['me'],
              onTap: () => filterController.changeProjectManager('me')),
          FilterElement(
            title: filterController.projectManager['other'].isEmpty
                ? 'Other user'
                : filterController.projectManager['other'],
            isSelected: filterController.projectManager['other'].isNotEmpty,
            cancelButtonEnabled:
                filterController.projectManager['other'].isNotEmpty,
            onTap: () async {
              var newUser = await Get.bottomSheet(UsersBottomSheet());
              await filterController.changeProjectManager('other', newUser);
            },
            onCancelTap: () =>
                filterController.changeProjectManager('other', null),
          ),
        ],
      ),
    );
  }
}
