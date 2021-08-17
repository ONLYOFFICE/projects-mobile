part of '../users/users_bottom_sheet.dart';

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    Key key,
    @required this.searchController,
    @required this.searchFieldController,
  }) : super(key: key);

  final UserSearchController searchController;
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
            ? TextField(
                autofocus: true,
                controller: searchFieldController,
                decoration:
                    InputDecoration.collapsed(hintText: tr('enterQuery')),
                style: TextStyleHelper.headline6(
                  color: Get.theme.colors().onSurface,
                ),
                onSubmitted: (value) => searchController.search(query: value),
              )
            : Align(
                alignment: Alignment.centerLeft,
                child: Text(tr('selectProject')),
              ),
      ),
    );
  }
}
