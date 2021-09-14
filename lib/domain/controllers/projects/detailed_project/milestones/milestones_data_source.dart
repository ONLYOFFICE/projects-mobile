import 'package:get/get.dart';
import 'package:projects/data/services/milestone_service.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_filter_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/milestones/milestones_sort_controller.dart';
import 'package:projects/internal/locator.dart';

class MilestonesDataSource extends GetxController {
  final _api = locator<MilestoneService>();

  final paginationController =
      Get.put(PaginationController(), tag: 'MilestonesDataSource');

  final _sortController = Get.find<MilestonesSortController>();
  final _filterController = Get.find<MilestonesFilterController>();

  MilestonesSortController get sortController => _sortController;
  MilestonesFilterController get filterController => _filterController;

  int get itemCount => paginationController.data.length;
  RxList get itemList => paginationController.data;

  RxBool loaded = false.obs;

  var hasFilters = false.obs;

  int _projectId;

  MilestonesDataSource() {
    _sortController.updateSortDelegate = () async => await loadMilestones();
    _filterController.applyFiltersDelegate = () async => loadMilestones();
    paginationController.loadDelegate = () async => await _getMilestones();
    paginationController.refreshDelegate =
        () async => await _getMilestones(needToClear: true);
    paginationController.pullDownEnabled = true;
  }

  Future loadMilestones() async {
    loaded.value = false;
    paginationController.startIndex = 0;
    await _getMilestones(needToClear: true);
    loaded.value = true;
  }

  Future _getMilestones({needToClear = false}) async {
    var result = await _api.milestonesByFilter(
      sortBy: _sortController.currentSortfilter,
      sortOrder: _sortController.currentSortOrder,
      projectId: _projectId != null ? _projectId.toString() : null,
      milestoneResponsibleFilter: _filterController.milestoneResponsibleFilter,
      taskResponsibleFilter: _filterController.taskResponsibleFilter,
      statusFilter: _filterController.statusFilter,
      deadlineFilter: _filterController.deadlineFilter,
    );

    paginationController.total.value = result.length;

    if (needToClear) paginationController.data.clear();

    paginationController.data.addAll(result);
  }

  Future<void> setup(int projectId) async {
    _projectId = projectId;
    _filterController.projectId = _projectId.toString();
    await loadMilestones();
  }
}
