part of '../projects_filter.dart';

class _TeamMember extends StatelessWidget {
  const _TeamMember({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<ProjectsFilterController>();
    return Obx(
      () => FiltersRow(
        title: 'Team member',
        options: <Widget>[
          FilterElement(
              title: 'Me',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.teamMember['me'],
              onTap: () => filterController.changeTeamMember('me')),
          FilterElement(
            title: filterController.teamMember['other'].isEmpty
                ? 'Other user'
                : filterController.teamMember['other'],
            isSelected: filterController.teamMember['other'].isNotEmpty,
            cancelButtonEnabled:
                filterController.teamMember['other'].isNotEmpty,
            onTap: () async {
              var newUser = await Get.bottomSheet(UsersBottomSheet());
              await filterController.changeTeamMember('other', newUser);
            },
            onCancelTap: () => filterController.changeTeamMember('other', null),
          ),
        ],
      ),
    );
  }
}
