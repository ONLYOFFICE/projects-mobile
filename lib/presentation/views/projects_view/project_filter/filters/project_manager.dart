part of '../projects_filter.dart';

class _ProjectManager extends StatelessWidget {
  const _ProjectManager({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController =
        Get.find<ProjectsFilterController>(tag: 'ProjectsView');
    return Obx(
      () => FiltersRow(
        title: tr('projectManager'),
        options: <Widget>[
          FilterElement(
            title: tr('me'),
            titleColor: Get.theme.colors().onSurface,
            isSelected: filterController.projectManager['me'],
            onTap: () => filterController.changeProjectManager('me'),
          ),
          FilterElement(
            title: filterController.projectManager['other'].isEmpty
                ? tr('otherUser')
                : filterController.projectManager['other'],
            isSelected: filterController.projectManager['other'].isNotEmpty,
            cancelButtonEnabled:
                filterController.projectManager['other'].isNotEmpty,
            onTap: () async {
              var newUser = await Get.find<NavigationController>()
                  .toScreen(const SelectUserScreen());
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
