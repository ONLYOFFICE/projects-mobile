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
              isSelected: filterController.teamMember['Me'],
              onTap: () => filterController.changeTeamMember('Me')),
          FilterElement(
            title: filterController.teamMember['Other'].isEmpty
                ? 'Other user'
                : filterController.teamMember['Other'],
            isSelected: filterController.teamMember['Other'].isNotEmpty,
            cancelButtonEnabled:
                filterController.teamMember['Other'].isNotEmpty,
            onTap: () async {
              var newUser = await Get.bottomSheet(const UsersBottomSheet());
              await filterController.changeTeamMember('Other', newUser);
            },
            onCancelTap: () => filterController.changeTeamMember('Other', null),
          ),
        ],
      ),
    );
  }
}
