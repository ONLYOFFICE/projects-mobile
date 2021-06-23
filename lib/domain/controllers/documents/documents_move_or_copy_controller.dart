import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/domain/controllers/documents/documents_filter_controller.dart';
import 'package:projects/domain/controllers/documents/documents_sort_controller.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';

class DocumentsMoveOrCopyController extends GetxController {
  final _api = locator<FilesService>();
  var portalInfoController = Get.find<PortalInfoController>();

  var hasFilters = false.obs;
  var loaded = false.obs;
  var nothingFound = false.obs;

  var searchInputController = TextEditingController();

  PaginationController _paginationController;

  String _query;

  int initialFolderId;

  int foldersCount = 0;
  Function refreshCalback;

  String mode;

  int _targetId;
  int get target => _targetId;

  PaginationController get paginationController => _paginationController;

  String _screenName;
  Folder _currentFolder;
  Folder get currentFolder => _currentFolder;

  var screenName = 'Choose section'.obs;

  RxList get itemList => _paginationController.data;

  DocumentsSortController _sortController;
  DocumentsSortController get sortController => _sortController;

  DocumentsFilterController _filterController;
  DocumentsFilterController get filterController => _filterController;

  DocumentsMoveOrCopyController(
    DocumentsFilterController filterController,
    PaginationController paginationController,
    DocumentsSortController sortController,
  ) {
    _sortController = sortController;
    _paginationController = paginationController;

    _filterController = filterController;
    _filterController.applyFiltersDelegate = () async => await refreshContent();

    sortController.updateSortDelegate = () async => await refreshContent();
    paginationController.loadDelegate = () async => await _getDocuments();
    paginationController.refreshDelegate = () async => await refreshContent();

    paginationController.pullDownEnabled = true;
  }

  Future<void> refreshContent() async {
    if (_currentFolder == null) {
      await initialSetup();
    } else
      await setupFolder(folder: _currentFolder, folderName: screenName.value);
  }

  Future<void> initialSetup() async {
    loaded.value = false;

    _clear();
    await _getDocuments();
    loaded.value = true;
  }

  Future<void> setupFolder({String folderName, Folder folder}) async {
    loaded.value = false;

    _clear();
    _currentFolder = folder;
    _filterController.folderId = _currentFolder.id;
    screenName.value = folderName;
    await _getDocuments();

    loaded.value = true;
  }

  void _clear() {
    _screenName = null;
    _currentFolder = null;

    _filterController.folderId = null;
    paginationController.startIndex = 0;
    paginationController.data.clear();
  }

  Future _getDocuments() async {
    var result = await _api.getFilesByParams(
      folderId: _currentFolder == null ? null : _currentFolder.id,
      query: _query,
      startIndex: paginationController.startIndex,
      sortBy: sortController.currentSortfilter,
      sortOrder: sortController.currentSortOrder,
      typeFilter: _filterController.typeFilter,
      authorFilter: _filterController.authorFilter,
    );

    if (result == null) return;

    paginationController.total.value = result.total;

    if (_currentFolder != null && result.current != null)
      _screenName = result.current.title;

    paginationController.data.addAll(result.folders);
    paginationController.data.addAll(result.files);

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

  Future<void> setupSearchMode({String folderName, Folder folder}) async {
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

  Future<bool> moveFolder() async {
    var result = await _api.moveDocument(
      movingFolder: _targetId.toString(),
      targetFolder: _currentFolder.id.toString(),
    );

    return result != null;
  }

  Future<bool> copyFolder() async {
    var result = await _api.copyDocument(
      copyingFolder: _targetId.toString(),
      targetFolder: _currentFolder.id.toString(),
    );

    return result != null;
  }

  Future<bool> moveFile() async {
    var result = await _api.moveDocument(
      movingFile: _targetId.toString(),
      targetFolder: _currentFolder.id.toString(),
    );

    return result != null;
  }

  Future<bool> copyFile() async {
    var result = await _api.copyDocument(
      copyingFile: _targetId.toString(),
      targetFolder: _currentFolder.id.toString(),
    );

    return result != null;
  }

  void setupOptions(int targetId, int initial) {
    _targetId = targetId;
    initialFolderId = initial;
  }
}
