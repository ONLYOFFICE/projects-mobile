import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_filter_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_sort_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';

class DiscussionsController extends BaseController {
  final _api = locator<DiscussionsService>();

  PaginationController _paginationController;
  PaginationController get paginationController => _paginationController;

  final _sortController = Get.find<DiscussionsSortController>();
  DiscussionsSortController get sortController => _sortController;

  DiscussionsFilterController _filterController;
  DiscussionsFilterController get filterController => _filterController;

  final _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  RxBool loaded = false.obs;
  var needToShowDivider = false.obs;

  DiscussionsController(
    DiscussionsFilterController filterController,
    PaginationController paginationController,
  ) {
    _paginationController = paginationController;
    _filterController = filterController;
    _filterController.applyFiltersDelegate = () async => loadDiscussions();
    _sortController.updateSortDelegate = () async => await loadDiscussions();
    paginationController.loadDelegate = () async => await _getDiscussions();
    paginationController.refreshDelegate =
        () async => await _getDiscussions(needToClear: true);
    paginationController.pullDownEnabled = true;
    _scrollController.addListener(
        () => needToShowDivider.value = _scrollController.offset > 2);
  }

  @override
  String get screenName => tr('discussions');

  @override
  RxList get itemList => paginationController.data;

  Future loadDiscussions() async {
    loaded.value = false;
    paginationController.startIndex = 0;
    await _getDiscussions(needToClear: true);
    loaded.value = true;
  }

  Future _getDiscussions({needToClear = false, String projectId}) async {
    var result = await _api.getDiscussionsByParams(
      startIndex: paginationController.startIndex,
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      authorFilter: _filterController.authorFilter,
      statusFilter: _filterController.statusFilter,
      creationDateFilter: _filterController.creationDateFilter,
      projectFilter: _filterController.projectFilter,
      otherFilter: _filterController.otherFilter,
      projectId: projectId,
    );
    paginationController.total.value = result.total;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result.response);
  }

  void toDetailed(Discussion discussion) =>
      Get.toNamed('DiscussionDetailed', arguments: {'discussion': discussion});

  void toNewDiscussionScreen() => Get.toNamed('NewDiscussionScreen');

  @override
  void showSearch() => Get.toNamed('DiscussionsSearchScreen');
}
