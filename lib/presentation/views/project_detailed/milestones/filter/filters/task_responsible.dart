part of '../milestones_filter.dart';

class _TaskResponsible extends StatelessWidget {
  const _TaskResponsible({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<MilestonesFilterController>();
    return Obx(
      () => FiltersRow(
        title: tr('tasks'),
        options: <Widget>[
          FilterElement(
              title: 'My tasks',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.taskResponsible['me'],
              onTap: () => filterController.changeTasksResponsible('me')),
          FilterElement(
            title: filterController.taskResponsible['other'].isEmpty
                ? 'Other user'
                : filterController.taskResponsible['other'],
            isSelected: filterController.taskResponsible['other'].isNotEmpty,
            cancelButtonEnabled:
                filterController.taskResponsible['other'].isNotEmpty,
            onTap: () async {
              var newUser = await Get.bottomSheet(const UsersBottomSheet());
              await filterController.changeTasksResponsible('Other', newUser);
            },
            onCancelTap: () =>
                filterController.changeTasksResponsible('other', null),
          ),
        ],
      ),
    );
  }
}
