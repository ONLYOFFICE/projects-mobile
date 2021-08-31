part of 'select_item_template.dart';

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    Key key,
    @required this.appBarText,
    @required this.searchController,
  }) : super(key: key);

  final BaseSearchController searchController;
  final String appBarText;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutSine,
          switchOutCurve: Curves.fastOutSlowIn,
          child: searchController.switchToSearchView.value == true
              ? TextField(
                  autofocus: true,
                  controller: searchController.textController,
                  decoration:
                      InputDecoration.collapsed(hintText: tr('enterQuery')),
                  style: TextStyleHelper.headline6(
                    color: Get.theme.colors().onSurface,
                  ),
                  onSubmitted: (value) async =>
                      await searchController.search(query: value),
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Text(appBarText),
                ),
        ));
  }
}
