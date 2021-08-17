part of '../users/users_bottom_sheet.dart';

class _AppBarIcon extends StatelessWidget {
  const _AppBarIcon({
    Key key,
    @required this.searchController,
    @required this.searchIconKey,
    @required this.clearIconKey,
    @required this.searchFieldController,
  }) : super(key: key);

  final UserSearchController searchController;
  final Key searchIconKey;
  final Key clearIconKey;
  final TextEditingController searchFieldController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutSine,
        switchOutCurve: Curves.fastOutSlowIn,
        child: searchController.switchToSearchView.isTrue
            ? IconButton(
                key: searchIconKey,
                onPressed: () => searchController.switchToSearchView.toggle(),
                icon: const Icon(Icons.clear),
              )
            : IconButton(
                key: clearIconKey,
                onPressed: () {
                  searchController.switchToSearchView.toggle();
                  searchController.clearSearch();
                  searchFieldController.clear();
                },
                icon: const Icon(Icons.search),
              ),
      ),
    );
  }
}
