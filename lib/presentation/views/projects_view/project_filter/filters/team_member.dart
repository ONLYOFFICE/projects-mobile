part of '../projects_filter.dart';

class _TeamMember extends StatelessWidget {
  const _TeamMember({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController =
        Get.find<ProjectsFilterController>(tag: 'ProjectsView');
    return Obx(
      () => FiltersRow(
        title: tr('teamMember'),
        options: <Widget>[
          FilterElement(
              title: tr('me'),
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.teamMember['me'],
              onTap: () => filterController.changeTeamMember('me')),
          FilterElement(
            title: filterController.teamMember['other'].isEmpty
                ? tr('otherUser')
                : filterController.teamMember['other'],
            isSelected: filterController.teamMember['other'].isNotEmpty,
            cancelButtonEnabled:
                filterController.teamMember['other'].isNotEmpty,
            onTap: () async {
              var newUser = await Get.bottomSheet(const UsersBottomSheet());
              await filterController.changeTeamMember('other', newUser);
            },
            onCancelTap: () => filterController.changeTeamMember('other', null),
          ),
        ],
      ),
    );
  }
}
