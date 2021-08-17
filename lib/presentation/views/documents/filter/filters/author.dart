part of '../documents_filter.dart';

class _Author extends StatelessWidget {
  final filterController;

  const _Author({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('author'),
        options: <Widget>[
          FilterElement(
              title: tr('me'),
              isSelected: filterController.author['me'],
              titleColor: Get.theme.colors().onSurface,
              onTap: () => filterController.changeAuthorFilter('me')),
          FilterElement(
              title: filterController.author['users'].isEmpty
                  ? tr('users')
                  : filterController.author['users'],
              isSelected: filterController.author['users'].isNotEmpty,
              cancelButtonEnabled: filterController.author['users'].isNotEmpty,
              onTap: () async {
                var newUser = await Get.bottomSheet(UsersBottomSheet());
                await filterController.changeAuthorFilter('users', newUser);
              },
              onCancelTap: () =>
                  filterController.changeAuthorFilter('users', null)),
          FilterElement(
              title: filterController.author['groups'].isEmpty
                  ? tr('groups')
                  : filterController.author['groups'],
              isSelected: filterController.author['groups'].isNotEmpty,
              cancelButtonEnabled: filterController.author['groups'].isNotEmpty,
              onTap: () async {
                var newGroup = await Get.bottomSheet(const GroupsBottomSheet());
                await filterController.changeAuthorFilter('groups', newGroup);
              },
              onCancelTap: () =>
                  filterController.changeAuthorFilter('groups', null)),
        ],
      ),
    );
  }
}
