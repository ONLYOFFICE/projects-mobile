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

  var paginationController =
      Get.put(PaginationController(), tag: 'ProjectsController');

  @override
  String get screenName => 'Projects';

  @override
  RxList get itemList => paginationController.data;

  final _sortController = Get.find<ProjectsSortController>();
  final _filterController = Get.find<ProjectsFilterController>();

  ProjectsController() {
    _sortController.updateSortDelegate = updateSort;

    _filterController.applyFiltersDelegate = () async {
      hasFilters.value = _filterController.hasFilters;
      await _getProjects(needToClear: true);
    };

    paginationController.loadDelegate = () async {
      await _getProjects();
    };
    {
      paginationController.refreshDelegate = () async {
        await _getProjects(needToClear: true);
      };
    }
    paginationController.pullDownEnabled = true;
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
    paginationController.total = result.total;

    if (needToClear) paginationController.data.clear();

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
