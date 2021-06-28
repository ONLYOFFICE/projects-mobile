import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/data/models/from_api/project_tag.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/base_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';

class ProjectsController extends BaseController {
  final _api = locator<ProjectService>();

  var loaded = false.obs;

  RxList<ProjectTag> tags = <ProjectTag>[].obs;

  PaginationController _paginationController;
  PaginationController get paginationController => _paginationController;

  @override
  String get screenName => tr('projects');

  @override
  RxList get itemList => _paginationController.data;

  final _sortController = Get.find<ProjectsSortController>();
  ProjectsSortController get sortController => _sortController;

  ProjectsFilterController _filterController;
  ProjectsFilterController get filterController => _filterController;

  var scrollController = ScrollController();
  var needToShowDevider = false.obs;

  ProjectsController(
    ProjectsFilterController filterController,
    PaginationController paginationController,
  ) {
    _paginationController = paginationController;
    _sortController.updateSortDelegate = updateSort;
    _filterController = filterController;
    _filterController.applyFiltersDelegate =
        () async => await _getProjects(needToClear: true);

    paginationController.loadDelegate = () async => await _getProjects();
    paginationController.refreshDelegate =
        () async => await _getProjects(needToClear: true);
    paginationController.pullDownEnabled = true;

    scrollController.addListener(
        () => needToShowDevider.value = scrollController.offset > 2);
  }

  @override
  void showSearch() {
    Get.toNamed('ProjectSearchView');
  }

  void updateSort() {
    loadProjects();
  }

  Future<void> loadProjects() async {
    loaded.value = false;
    paginationController.startIndex = 0;
    await _getProjects(needToClear: true);
    loaded.value = true;
  }

  Future _getProjects({needToClear = false}) async {
    var result = await _api.getProjectsByParams(
      startIndex: paginationController.startIndex,
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectManagerFilter: _filterController.projectManagerFilter,
      participantFilter: _filterController.teamMemberFilter,
      otherFilter: _filterController.otherFilter,
      statusFilter: _filterController.statusFilter,
    );
    if (needToClear) paginationController.data.clear();
    if (result == null) return;

    paginationController.total.value = result.total;
    paginationController.data.addAll(result.response);
  }

  Future getProjectTags() async {
    loaded.value = false;
    tags.value = await _api.getProjectTags();
    loaded.value = true;
  }

  void createNewProject() {
    Get.toNamed('NewProject');
  }
}
