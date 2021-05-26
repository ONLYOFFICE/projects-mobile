import 'package:get/get.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/domain/controllers/documents/documents_sort_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/documents/documents_filter_controller.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/data/models/from_api/project_tag.dart';

class DocumentsController extends GetxController {
  final _api = locator<FilesService>();

  var hasFilters = false.obs;

  var loaded = false.obs;

  RxList<ProjectTag> tags = <ProjectTag>[].obs;

  PaginationController _paginationController;
  PaginationController get paginationController => _paginationController;

  String _screenName;
  String _folderId;

  var screenName = 'Documents'.obs;

  RxList get itemList => _paginationController.data;

  DocumentsSortController _sortController;
  DocumentsSortController get sortController => _sortController;

  DocumentsFilterController _filterController;

  DocumentsController(
      DocumentsFilterController filterController,
      PaginationController paginationController,
      DocumentsSortController sortController) {
    _sortController = sortController;
    _paginationController = paginationController;

    _filterController = filterController;
    _filterController.applyFiltersDelegate = () async {
      hasFilters.value = _filterController.hasFilters;
      await refreshContent();
    };

    sortController.updateSortDelegate = () async => await refreshContent();
    paginationController.loadDelegate = () async => await refreshContent();
    paginationController.refreshDelegate = () async => await refreshContent();

    paginationController.pullDownEnabled = true;
  }

  Future<void> refreshContent() async {
    if (_folderId == null) {
      await initialSetup();
    } else
      await setupFolder(folderId: _folderId, folderName: screenName.value);
  }

  Future<void> initialSetup() async {
    loaded.value = false;

    _clear();
    await _getDocuments();
    loaded.value = true;
  }

  Future<void> setupFolder({String folderName, String folderId}) async {
    loaded.value = false;

    _clear();
    _folderId = folderId;
    screenName.value = folderName;
    await _getDocuments();

    loaded.value = true;
  }

  void _clear() {
    _screenName = null;
    _folderId = null;

    paginationController.startIndex = 0;
    paginationController.data.clear();
  }

  Future _getDocuments() async {
    var result = await _api.getFiles(
      folderId: _folderId,
      startIndex: paginationController.startIndex,
      sortBy: sortController.currentSortfilter,
      sortOrder: sortController.currentSortOrder,
    );

    if (result == null) return;

    paginationController.total.value = result.total;

    if (_folderId != null && result.current != null)
      _screenName = result.current.title;

    paginationController.data.addAll(result.folders);
    paginationController.data.addAll(result.files);

    screenName.value = _screenName ?? 'Documents';
  }
}
