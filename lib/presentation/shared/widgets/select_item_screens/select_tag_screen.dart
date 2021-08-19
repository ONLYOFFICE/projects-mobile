import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/project_tag.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/tags/tags_controller.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/common/select_item_template.dart';

class SelectTagScreen extends StatelessWidget with SelectItemMixin {
  const SelectTagScreen({Key key}) : super(key: key);

  @override
  String get appBarText => tr('selectTag');

  @override
  TagsController get controller => Get.put(TagsController());

  @override
  VoidCallback get getItemsFunction => () async => await controller.getItems();

  @override
  Widget get itemList => const _TagList();
}

class _TagList extends StatelessWidget with SelectItemListMixin {
  const _TagList({Key key}) : super(key: key);

  @override
  PaginationController get paginationController =>
      Get.find<TagsController>().paginationController;

  @override
  Widget Function(BuildContext context, int index) get itemBuilder => (_, i) {
        ProjectTag tag = paginationController.data[i];
        return SelectItemTile(
            title: tag.title,
            onSelect: () =>
                Get.back(result: {'id': tag.id, 'title': tag.title}));
      };
}
