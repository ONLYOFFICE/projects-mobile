import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/domain/controllers/documents/documents_filter_controller.dart';
import 'package:projects/domain/controllers/documents/documents_sort_controller.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';

class DocumentsController extends GetxController {
  final _api = locator<FilesService>();
  var portalInfoController = Get.find<PortalInfoController>();

  var hasFilters = false.obs;
  var loaded = false.obs;
  var nothingFound = false.obs;

  var searchInputController = TextEditingController();

  PaginationController _paginationController;

  String _query;

  String _entityType;

  set entityType(String value) =>
      {_entityType = value, _filterController.entityType = value};

  PaginationController get paginationController => _paginationController;

  String _screenName;
  int _currentFolderId;
  int get currentFolder => _currentFolderId;

  var screenName = 'Documents'.obs;

  RxList get itemList => _paginationController.data;

  DocumentsSortController _sortController;
  DocumentsSortController get sortController => _sortController;

  DocumentsFilterController _filterController;
  DocumentsFilterController get filterController => _filterController;

  DocumentsController(
    DocumentsFilterController filterController,
    PaginationController paginationController,
    DocumentsSortController sortController,
  ) {
    _sortController = sortController;
    _paginationController = paginationController;

    _filterController = filterController;

    _filterController.applyFiltersDelegate = () async {
      hasFilters.value = _filterController.hasFilters;
      await refreshContent();
    };

    sortController.updateSortDelegate = () async => await refreshContent();
    paginationController.loadDelegate = () async => await _getDocuments();
    paginationController.refreshDelegate = () async => await refreshContent();

    paginationController.pullDownEnabled = true;
  }

  Future<void> refreshContent() async {
    if (_currentFolderId == null) {
      await initialSetup();
    } else
      await setupFolder(
          folderId: _currentFolderId, folderName: screenName.value);
  }

  Future<void> initialSetup() async {
    loaded.value = false;

    _clear();
    await _getDocuments();
    loaded.value = true;
  }

  Future<void> setupFolder({String folderName, int folderId}) async {
    loaded.value = false;

    _clear();
    _currentFolderId = folderId;
    _filterController.folderId = _currentFolderId;
    screenName.value = folderName;
    await _getDocuments();

    loaded.value = true;
  }

  void _clear() {
    _screenName = null;
    _currentFolderId = null;

    _filterController.folderId = null;
    paginationController.startIndex = 0;
    paginationController.data.clear();
  }

  Future _getDocuments() async {
    var result = await _api.getFilesByParams(
      folderId: _currentFolderId,
      query: _query,
      startIndex: paginationController.startIndex,
      sortBy: sortController.currentSortfilter,
      sortOrder: sortController.currentSortOrder,
      typeFilter: _filterController.typeFilter,
      authorFilter: _filterController.authorFilter,
      entityType: _entityType,
    );

    if (result == null) return;

    paginationController.total.value = result.total;

    if (_currentFolderId != null && result.current != null)
      _screenName = result.current.title;

    if (result.folders != null)
      paginationController.data.addAll(result.folders);
    if (result.files != null) paginationController.data.addAll(result.files);

    screenName.value = _screenName ?? 'Documents';
  }

  void clearSearch() {
    _query = '';

    searchInputController.clear();
    nothingFound.value = false;

    paginationController.startIndex = 0;
    paginationController.data.clear();
  }

  void newSearch(query) {
    _query = query;
    paginationController.startIndex = 0;
    paginationController.data.clear();
    _performSearch();
  }

  Future<void> setupSearchMode({String folderName, int folderId}) async {
    loaded.value = true;
  }

  void _performSearch() async {
    loaded.value = false;
    nothingFound.value = false;

    await _getDocuments();

    if (paginationController.data.isEmpty) {
      nothingFound.value = true;
    }

    loaded.value = true;
  }

  void onFilePopupMenuSelected(value, PortalFile element) {}

  Future<bool> renameFolder(Folder element, String newName) async {
    var result = await _api.renameFolder(
      folderId: element.id.toString(),
      newTitle: newName,
    );

    return result != null;
  }

  void downloadFolder() {}

  Future<bool> deleteFolder(Folder element) async {
    var result = await _api.deleteFolder(
      folderId: element.id.toString(),
    );

    return result != null;
  }

  Future<bool> deleteFile(PortalFile element) async {
    var result = await _api.deleteFile(
      fileId: element.id.toString(),
    );

    return result != null;
  }

  Future<bool> renameFile(PortalFile element, String newName) async {
    var result = await _api.renameFile(
      fileId: element.id.toString(),
      newTitle: newName,
    );

    return result != null;
  }

  Future<void> downloadFile(String viewUrl) async {
    final _downloadService = locator<DownloadService>();
    await _downloadService.downloadDocument(viewUrl);
  }
}
