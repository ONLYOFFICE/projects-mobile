import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/domain/controllers/base/base_search_controller.dart';
import 'package:projects/domain/controllers/users/user_search_controller.dart';
import 'package:projects/domain/controllers/users/users_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/common/select_item_template.dart';

part 'user_tile.dart';
part 'search_result.dart';
part 'user_list.dart';

class SelectUserScreen extends StatelessWidget with SelectItemWithSearchMixin {
  const SelectUserScreen({Key key}) : super(key: key);

  @override
  String get appBarText => tr('selectUser');

  @override
  BaseSearchController get searchController => Get.put(UserSearchController());

  @override
  UsersController get controller => Get.find<UsersController>();

  @override
  VoidCallback get getItemsFunction => () async => await controller.getUsers();

  @override
  Widget get nothingFound => Column(children: const [NothingFound()]);

  @override
  Widget get itemList => const _UserList();

  @override
  Widget get searchResult => _SearchResult(searchController: searchController);
}
