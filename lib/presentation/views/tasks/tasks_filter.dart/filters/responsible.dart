part of '../tasks_filter.dart';

class _Responsible extends StatelessWidget {
  final TaskFilterController filterController;
  const _Responsible({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('responsible'),
        options: <Widget>[
          FilterElement(
              title: tr('me'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.responsible['me'],
              onTap: () => filterController.changeResponsible('me')),
          FilterElement(
              title: filterController.responsible['other'].isEmpty
                  ? tr('otherUser')
                  : filterController.responsible['other'],
              isSelected: filterController.responsible['other'].isNotEmpty,
              cancelButtonEnabled:
                  filterController.responsible['other'].isNotEmpty,
              onTap: () async {
                // TODO CHECK
                var newUser = await Get.to(() => UsersBottomSheet());
                filterController.changeResponsible('other', newUser);
              },
              onCancelTap: () =>
                  filterController.changeResponsible('other', null)),
          FilterElement(
              title: filterController.responsible['groups'].isEmpty
                  ? tr('groups')
                  : filterController.responsible['groups'],
              isSelected: filterController.responsible['groups'].isNotEmpty,
              cancelButtonEnabled:
                  filterController.responsible['groups'].isNotEmpty,
              onTap: () async {
                var newGroup = await Get.to(const GroupsBottomSheet());
                filterController.changeResponsible('groups', newGroup);
              },
              onCancelTap: () =>
                  filterController.changeResponsible('groups', null)),
          FilterElement(
              title: tr('noResponsible'),
              titleColor: Get.theme.colors().onSurface,
              isSelected: filterController.responsible['no'],
              onTap: () => filterController.changeResponsible('no'))
        ],
      ),
    );
  }
}
