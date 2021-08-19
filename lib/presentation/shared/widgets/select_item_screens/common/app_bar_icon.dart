part of 'select_item_template.dart';

class _AppBarIcon extends StatelessWidget {
  const _AppBarIcon({
    Key key,
    @required this.searchController,
    @required this.searchIconKey,
    @required this.clearIconKey,
  }) : super(key: key);

  final BaseSearchController searchController;
  final Key searchIconKey;
  final Key clearIconKey;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutSine,
        switchOutCurve: Curves.fastOutSlowIn,
        child: searchController.switchToSearchView.value == true
            ? IconButton(
                key: searchIconKey,
                onPressed: () {
                  searchController.switchToSearchView.value =
                      !searchController.switchToSearchView.value;
                  searchController.textController.clear();
                  searchController.clearSearch();
                },
                icon: const Icon(Icons.clear),
              )
            : IconButton(
                key: clearIconKey,
                onPressed: () => searchController.switchToSearchView.value =
                    !searchController.switchToSearchView.value,
                icon: const Icon(Icons.search),
              ),
      ),
    );
  }
}
