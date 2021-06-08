part of '../documents_filter.dart';

class _Author extends StatelessWidget {
  final filterController;

  const _Author({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: 'Author',
        options: <Widget>[
          FilterElement(
              title: 'Me',
              isSelected: filterController.author['me'],
              titleColor: Theme.of(context).customColors().onSurface,
              onTap: () => filterController.changeAuthorFilter('me')),
          FilterElement(
              title: filterController.author['users'].isEmpty
                  ? 'Users'
                  : filterController.author['users'],
              isSelected: filterController.author['users'].isNotEmpty,
              cancelButtonEnabled: filterController.author['users'].isNotEmpty,
              onTap: () async {
                var newUser = await Get.bottomSheet(const UsersBottomSheet());
                await filterController.changeAuthorFilter('users', newUser);
              },
              onCancelTap: () =>
                  filterController.changeAuthorFilter('users', null)),
          FilterElement(
              title: filterController.author['groups'].isEmpty
                  ? 'Groups'
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
