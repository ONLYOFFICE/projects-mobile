import 'package:get/get.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/domain/controllers/base_filter_controller.dart';
import 'package:projects/internal/locator.dart';

//TODO: add docs filters
class DocumentsFilterController extends BaseFilterController {
  final _api = locator<FilesService>();

  // final _sortController = Get.find<DocumentsSortController>();
  Function applyFiltersDelegate;

  String _typeFilter = '';
  String _authorFilter = '';

  String get typeFilter => _typeFilter;
  String get authorFilter => _authorFilter;

  String _projectId;
  set projectId(String value) => _projectId = value;

  @override
  bool get hasFilters => _typeFilter.isNotEmpty || _authorFilter.isNotEmpty;

  RxMap<String, dynamic> milestoneResponsible = {'me': false, 'other': ''}.obs;
  RxMap<String, dynamic> taskResponsible = {'me': false, 'other': ''}.obs;

  DocumentsFilterController() {
    filtersTitle = 'DOCUMENTS';
    suitableResultCount = (-1).obs;
  }

  Future<void> changeTypeFilter(String filter, [newValue = '']) async {
    getSuitableTasksCount();
  }

  Future<void> changeAuthorFilter(String filter, [newValue = '']) async {
    getSuitableTasksCount();
  }

  void getSuitableTasksCount() async {
    suitableResultCount.value = -1;

    var result = await _api.getProjectFiles(
      // sortBy: _sortController.currentSortfilter,
      // sortOrder: _sortController.currentSortOrder,
      projectId: _projectId,
    );

    suitableResultCount.value = result.length;
  }

  @override
  void resetFilters() async {
    //typeFilter = {'me': false, 'other': ''}.obs;
    //authorFilter = {'me': false, 'other': ''}.obs;

    suitableResultCount.value = -1;

    _typeFilter = '';
    _authorFilter = '';

    applyFilters();
  }

  @override
  void applyFilters() async {
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }
}
