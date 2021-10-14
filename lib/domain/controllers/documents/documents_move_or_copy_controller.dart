/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/domain/controllers/documents/documents_filter_controller.dart';
import 'package:projects/domain/controllers/documents/documents_sort_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';

import 'package:projects/internal/locator.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';

class DocumentsMoveOrCopyController extends GetxController {
  final _api = locator<FilesService>();

  var hasFilters = false.obs;
  var loaded = false.obs;
  var nothingFound = false.obs;
  var searchMode = false.obs;

  var searchInputController = TextEditingController();

  PaginationController _paginationController;

  String _query;

  int initialFolderId;

  int foldersCount = 0;

  String mode;

  int _targetId;
  int get target => _targetId;

  PaginationController get paginationController => _paginationController;

  String _screenName;
  Folder _currentFolder;
  Folder get currentFolder => _currentFolder;

  var screenName = tr('chooseSection').obs;

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

    screenName.value = _screenName ?? tr('documents');
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

  Future moveFolder() async {
    var result = await _api.moveDocument(
      movingFolder: _targetId.toString(),
      targetFolder: _currentFolder.id.toString(),
    );

    if (result != null) {
      Get.close(foldersCount);

      MessagesHandler.showSnackBar(
          context: Get.context, text: tr('folderMoved'));
    }
    locator<EventHub>().fire('needToRefreshDocuments');
  }

  Future copyFolder() async {
    var result = await _api.copyDocument(
      copyingFolder: _targetId.toString(),
      targetFolder: _currentFolder.id.toString(),
    );

    if (result != null) {
      Get.close(foldersCount);

      MessagesHandler.showSnackBar(
          context: Get.context, text: tr('folderCopied'));
    }
    locator<EventHub>().fire('needToRefreshDocuments');
  }

  Future moveFile() async {
    var result = await _api.moveDocument(
      movingFile: _targetId.toString(),
      targetFolder: _currentFolder.id.toString(),
    );

    if (result != null) {
      Get.close(foldersCount);

      MessagesHandler.showSnackBar(context: Get.context, text: tr('fileMoved'));
    }
    locator<EventHub>().fire('needToRefreshDocuments');
  }

  Future copyFile() async {
    var result = await _api.copyDocument(
      copyingFile: _targetId.toString(),
      targetFolder: _currentFolder.id.toString(),
    );

    if (result != null) {
      Get.close(foldersCount);

      MessagesHandler.showSnackBar(
          context: Get.context, text: tr('fileCopied'));
    }
    locator<EventHub>().fire('needToRefreshDocuments');
  }

  void setupOptions(int targetId, int initial) {
    _targetId = targetId;
    initialFolderId = initial;
  }
}
