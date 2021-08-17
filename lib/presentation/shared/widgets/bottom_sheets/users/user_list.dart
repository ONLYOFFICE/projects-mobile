part of 'users_bottom_sheet.dart';

class _UserList extends StatelessWidget {
  const _UserList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var usersController = Get.find<UsersController>();

    return Obx(
      () => PaginationListView(
        paginationController: usersController.paginationController,
        child: ListView.builder(
          itemCount: usersController.paginationController.data.length,
          itemBuilder: (BuildContext context, int index) {
            PortalUser user = usersController.paginationController.data[index];
            return _UserTile(user: user);
          },
        ),
      ),
    );
  }
}
