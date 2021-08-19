part of 'select_user_screen.dart';

class _SearchResult extends StatelessWidget {
  const _SearchResult({
    Key key,
    @required this.searchController,
  }) : super(key: key);

  final UserSearchController searchController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PaginationListView(
        paginationController: searchController.paginationController,
        child: ListView.builder(
          itemCount: searchController.paginationController.data.length,
          itemBuilder: (BuildContext context, int index) {
            PortalUser user = searchController.paginationController.data[index];
            return _UserTile(user: user);
          },
        ),
      ),
    );
  }
}
