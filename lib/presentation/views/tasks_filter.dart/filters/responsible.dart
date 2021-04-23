part of '../tasks_filter.dart';

class _Responsible extends StatelessWidget {
  const _Responsible({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = Get.find<TaskFilterController>();
    return Obx(
      () => FiltersRow(
        title: 'Responsible',
        options: <Widget>[
          FilterElement(
              title: 'Me',
              isSelected: filterController.responsible['Me'],
              onTap: () => filterController.changeResponsible('Me')),
          FilterElement(
              title: filterController.responsible['Other'].isEmpty
                  ? 'Other user'
                  : filterController.responsible['Other'],
              isSelected: filterController.responsible['Other'].isNotEmpty,
              cancelButtonEnabled:
                  filterController.responsible['Other'].isNotEmpty,
              onTap: () async {
                var newUser = await Get.bottomSheet(const UsersBottomSheet());
                filterController.changeResponsible('Other', newUser);
              },
              onCancelTap: () =>
                  filterController.changeResponsible('Other', null)),
          FilterElement(
              title: filterController.responsible['Groups'].isEmpty
                  ? 'Groups'
                  : filterController.responsible['Groups'],
              isSelected: filterController.responsible['Groups'].isNotEmpty,
              cancelButtonEnabled:
                  filterController.responsible['Groups'].isNotEmpty,
              onTap: () async {
                var newGroup = await Get.bottomSheet(const GroupsBottomSheet());
                filterController.changeResponsible('Groups', newGroup);
              },
              onCancelTap: () =>
                  filterController.changeResponsible('Groups', null)),
          FilterElement(
              title: 'No responsible',
              titleColor: Theme.of(context).customColors().onSurface,
              isSelected: filterController.responsible['No'],
              onTap: () => filterController.changeResponsible('No'))
        ],
      ),
    );
  }
}
