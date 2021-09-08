import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/security_info.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/data/models/from_api/project_tag.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/project_sort_controller.dart';
import 'package:projects/presentation/views/projects_view/new_project/new_project_view.dart';
import 'package:projects/presentation/views/projects_view/project_search_view.dart';

class ProjectsController extends BaseController {
  final _api = locator<ProjectService>();

  var loaded = false.obs;

  RxList<ProjectTag> tags = <ProjectTag>[].obs;

  PaginationController _paginationController;

  var securityInfo = SecrityInfo();
  PaginationController get paginationController => _paginationController;

  @override
  RxList get itemList => _paginationController.data;

  final _sortController = Get.find<ProjectsSortController>();
  ProjectsSortController get sortController => _sortController;

  ProjectsFilterController _filterController;
  ProjectsFilterController get filterController => _filterController;

  final _userController = Get.find<UserController>();

  var fabIsVisible = false.obs;

  ProjectsController(
    ProjectsFilterController filterController,
    PaginationController paginationController,
  ) {
    screenName = tr('projects');
    _paginationController = paginationController;
    _sortController.updateSortDelegate = updateSort;
    _filterController = filterController;
    _filterController.applyFiltersDelegate =
        () async => await _getProjects(needToClear: true);

    paginationController.loadDelegate = () async => await _getProjects();
    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;

    locator<EventHub>().on('needToRefreshProjects', (dynamic data) {
      loadProjects();
    });
    _userController
        .getUserInfo()
        .then((value) => _api.getProjectSecurityinfo().then((value) => {
              securityInfo = value,
              fabIsVisible.value = canCreateNewProject,
            }));
    locator<EventHub>().on('moreViewVisibilityChanged', (dynamic data) {
      fabIsVisible.value = data ? false : canCreateNewProject;
    });
  }

  bool get canCreateNewProject =>
      _userController.user.isAdmin ||
      _userController.user.isOwner ||
      securityInfo.canCreateProject;

  @override
  void showSearch() {
    Get.find<NavigationController>().to(ProjectSearchView());
  }

  void updateSort() {
    loadProjects();
  }

  Future<void> refreshData() async {
    loaded.value = false;
    await _getProjects(needToClear: true);
    loaded.value = true;
  }

  Future<void> loadProjects({PresetProjectFilters preset}) async {
    loaded.value = false;
    paginationController.startIndex = 0;
    if (preset != null) {
      await _filterController
          .setupPreset(preset)
          .then((value) => _getProjects(needToClear: true));
    } else {
      await _getProjects(needToClear: true);
    }
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
    expandedCardView.value = paginationController.data.isNotEmpty;
  }

  Future getProjectTags() async {
    loaded.value = false;
    tags.value = await _api.getProjectTags();
    loaded.value = true;
  }

  void createNewProject() {
    Get.find<NavigationController>().to(const NewProject());
  }
}
