import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/domain/controllers/discussions/discussions_sort_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';

class ProjectDiscussionsController extends GetxController {
  final _api = locator<DiscussionsService>();
  final projectId;
  var projectTitle;

  final _paginationController =
      Get.put(PaginationController(), tag: 'ProjectDiscussionsController');

  PaginationController get paginationController => _paginationController;

  final _sortController = Get.find<DiscussionsSortController>();
  final _scrollController = ScrollController();
  var needToShowDivider = false.obs;

  ScrollController get scrollController => _scrollController;

  RxBool loaded = false.obs;

  ProjectDiscussionsController(this.projectId, this.projectTitle) {
    _sortController.updateSortDelegate =
        () async => await loadProjectDiscussions();

    paginationController.loadDelegate = () async => await _getDiscussions();
    paginationController.refreshDelegate =
        () async => await _getDiscussions(needToClear: true);
    paginationController.pullDownEnabled = true;
    scrollController.addListener(
        () => needToShowDivider.value = scrollController.offset > 2);
  }

  RxList get itemList => paginationController.data;

  Future loadProjectDiscussions() async {
    loaded.value = false;
    paginationController.startIndex = 0;
    await _getDiscussions(needToClear: true);
    loaded.value = true;
  }

  Future _getDiscussions({needToClear = false}) async {
    var result = await _api.getDiscussionsByParams(
      startIndex: paginationController.startIndex,
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectId: projectId.toString(),
    );
    paginationController.total.value = result.total;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result.response);
  }

  void toDetailed(Discussion discussion) =>
      Get.toNamed('DiscussionDetailed', arguments: {'discussion': discussion});

  void toNewDiscussionScreen() => Get.toNamed('NewDiscussionScreen',
      arguments: {'projectId': projectId, 'projectTitle': projectTitle});
}
