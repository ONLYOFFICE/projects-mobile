import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/domain/controllers/base/base_search_controller.dart';
import 'package:projects/domain/controllers/milestones/milestones_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestone_search_controller.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/common/select_item_template.dart';

class SelectMilestoneScreen extends StatelessWidget
    with SelectItemWithSearchMixin {
  const SelectMilestoneScreen({Key key}) : super(key: key);

  @override
  String get appBarText => tr('selectMilestone');

  @override
  BaseSearchController get searchController =>
      Get.put(MilestoneSearchController());

  @override
  MilestonesController get controller => Get.find<MilestonesController>();

  @override
  VoidCallback get getItemsFunction =>
      () async => await controller.getMilestones();

  @override
  Widget get nothingFound => Column(children: const [NothingFound()]);

  @override
  Widget get itemList => const _MilestoneList();

  @override
  Widget get searchResult => _SearchResult(
      paginationController: searchController.paginationController);
}

class _MilestoneList extends StatelessWidget with SelectItemListMixin {
  const _MilestoneList({Key key}) : super(key: key);

  @override
  PaginationController get paginationController =>
      Get.find<MilestonesController>().paginationController;

  @override
  Widget Function(BuildContext context, int index) get itemBuilder => (_, i) {
        Milestone milestone = paginationController.data[i];
        return SelectItemTile(
            title: milestone.title,
            onSelect: () => Get.back(
                result: {'id': milestone.id, 'title': milestone.title}));
      };
}

class _SearchResult extends StatelessWidget with SelectItemListMixin {
  const _SearchResult({
    Key key,
    this.paginationController,
  }) : super(key: key);

  @override
  final PaginationController paginationController;

  @override
  Widget Function(BuildContext context, int index) get itemBuilder => (_, i) {
        Milestone milestone = paginationController.data[i];
        return SelectItemTile(
            title: milestone.title,
            onSelect: () => Get.back(
                result: {'id': milestone.id, 'title': milestone.title}));
      };
}
