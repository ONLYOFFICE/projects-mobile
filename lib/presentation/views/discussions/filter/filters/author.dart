part of '../discussions_filter_screen.dart';

class _Author extends StatelessWidget {
  final DiscussionsFilterController filterController;
  const _Author({Key key, this.filterController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FiltersRow(
        title: tr('author'),
        options: <Widget>[
          FilterElement(
              title: tr('me'),
              titleColor: Theme.of(context).colors().onSurface,
              isSelected: filterController.author['me'],
              onTap: () => filterController.changeAuthor(('me'))),
          FilterElement(
            title: filterController.author['other'].isEmpty
                ? tr('otherUser')
                : filterController.author['other'],
            isSelected: filterController.author['other'].isNotEmpty,
            cancelButtonEnabled: filterController.author['other'].isNotEmpty,
            onTap: () async {
              var newUser = await Get.bottomSheet(const UsersBottomSheet());
              filterController.changeAuthor('other', newUser);
            },
            onCancelTap: () => filterController.changeAuthor('other', null),
          ),
        ],
      ),
    );
  }
}
