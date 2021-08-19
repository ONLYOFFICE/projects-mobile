import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_group.dart';
import 'package:projects/domain/controllers/groups/groups_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/common/select_item_template.dart';

class SelectGroupScreen extends StatelessWidget with SelectItemMixin {
  const SelectGroupScreen({Key key}) : super(key: key);

  @override
  String get appBarText => tr('selectGroup');

  @override
  GroupsController get controller => Get.find<GroupsController>();

  @override
  VoidCallback get getItemsFunction => () async => await controller.getGroups();

  @override
  Widget get itemList => const _GroupList();
}

class _GroupList extends StatelessWidget with SelectItemListMixin {
  const _GroupList({Key key}) : super(key: key);

  @override
  PaginationController get paginationController =>
      Get.find<GroupsController>().paginationController;

  @override
  Widget Function(BuildContext context, int index) get itemBuilder => (_, i) {
        PortalGroup group = paginationController.data[i];
        return SelectItemTile(
            title: group.name,
            onSelect: () =>
                Get.back(result: {'id': group.id, 'name': group.name}));
      };
}
