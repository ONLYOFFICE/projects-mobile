import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_sort_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';

class DiscussionsController extends BaseController {
  final _api = locator<DiscussionsService>();

  PaginationController _paginationController;
  PaginationController get paginationController => _paginationController;

  final _sortController = Get.find<DiscussionsSortController>();

  RxBool loaded = false.obs;

  DiscussionsController(PaginationController paginationController) {
    _paginationController = paginationController;
    _sortController.updateSortDelegate = () async => await loadDiscussions();
    paginationController.loadDelegate = () async => await _getDiscussions();
    paginationController.refreshDelegate =
        () async => await _getDiscussions(needToClear: true);
    paginationController.pullDownEnabled = true;
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
      projectId: projectId,
      // responsibleFilter: _filterController.responsibleFilter,
      // creatorFilter: _filterController.creatorFilter,
      // projectFilter: _filterController.projectFilter,
      // milestoneFilter: _filterController.milestoneFilter,
      // deadlineFilter: _filterController.deadlineFilter,
      // query: 'задача',
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
