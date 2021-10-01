import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/services/discussions_service.dart';
import 'package:projects/domain/controllers/base/base_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_filter_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_sort_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/projects_with_presets.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/new_discussion/new_discussion_screen.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_detailed.dart';
import 'package:projects/presentation/views/discussions/discussions_search_view.dart';

class DiscussionsController extends BaseController {
  final _api = locator<DiscussionsService>();

  PaginationController _paginationController;
  PaginationController get paginationController => _paginationController;

  final _userController = Get.find<UserController>();
  final _sortController = Get.find<DiscussionsSortController>();
  DiscussionsSortController get sortController => _sortController;

  DiscussionsFilterController _filterController;
  DiscussionsFilterController get filterController => _filterController;

  RxBool loaded = false.obs;
  var fabIsVisible = true.obs;

  DiscussionsController(
    DiscussionsFilterController filterController,
    PaginationController paginationController,
  ) {
    screenName = tr('discussions');
    _paginationController = paginationController;
    _filterController = filterController;
    _filterController.applyFiltersDelegate = () async => loadDiscussions();
    _sortController.updateSortDelegate = () async => await loadDiscussions();
    paginationController.loadDelegate = () async => await _getDiscussions();
    paginationController.refreshDelegate = () async => await refreshData();
    paginationController.pullDownEnabled = true;

    getFabVisibility().then((value) => fabIsVisible.value = value);

    locator<EventHub>().on('moreViewVisibilityChanged', (dynamic data) async {
      fabIsVisible.value = data ? false : await getFabVisibility();
    });
  }

  @override
  RxList get itemList => paginationController.data;

  Future loadDiscussions({PresetDiscussionFilters preset}) async {
    loaded.value = false;
    paginationController.startIndex = 0;
    if (preset != null) {
      await _filterController
          .setupPreset(preset)
          .then((value) => _getDiscussions(needToClear: true));
    } else {
      await _getDiscussions(needToClear: true);
    }
    loaded.value = true;
  }

  Future<void> refreshData() async {
    loaded.value = false;
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

  void toDetailed(Discussion discussion) => Get.find<NavigationController>()
      .to(DiscussionDetailed(), arguments: {'discussion': discussion});

  void toNewDiscussionScreen() =>
      Get.find<NavigationController>().to(const NewDiscussionScreen());

  @override
  void showSearch() =>
      Get.find<NavigationController>().to(const DiscussionsSearchScreen());

  Future<bool> getFabVisibility() async {
    var fabVisibility = false;
    await _userController.getUserInfo();
    var selfUser = _userController.user;

    if (selfUser.isAdmin ||
        selfUser.isOwner ||
        selfUser.listAdminModules.contains('projects')) {
      if (ProjectsWithPresets.activeProjectsController.itemList.isEmpty)
        await ProjectsWithPresets.activeProjectsController.loadProjects();
      fabVisibility =
          ProjectsWithPresets.activeProjectsController.itemList.isNotEmpty;
    } else {
      if (ProjectsWithPresets.myProjectsController.itemList.isEmpty)
        await ProjectsWithPresets.myProjectsController.loadProjects();
      fabVisibility =
          ProjectsWithPresets.myProjectsController.itemList.isNotEmpty;
    }
    return fabVisibility;
  }
}
