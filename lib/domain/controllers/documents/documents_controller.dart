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

import 'dart:convert';

import 'package:event_hub/event_hub.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/internal/constants.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/domain/controllers/documents/documents_filter_controller.dart';
import 'package:projects/domain/controllers/documents/documents_sort_controller.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';

class DocumentsController extends GetxController {
  final _api = locator<FilesService>();
  var portalInfoController = Get.find<PortalInfoController>();

  var hasFilters = false.obs;
  var loaded = false.obs;
  var nothingFound = false.obs;
  var searchMode = false.obs;

  var searchInputController = TextEditingController();

  PaginationController _paginationController;

  String _query;

  String _entityType;

  String get entityType => _entityType;
  set entityType(String value) =>
      {_entityType = value, _filterController.entityType = value};

  PaginationController get paginationController => _paginationController;

  String _screenName;
  int _currentFolderId;
  int get currentFolder => _currentFolderId;

  var screenName = tr('documents').obs;

  RxList get itemList => _paginationController.data;
  RxInt filesCount = RxInt(-1);

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
    _filterController.applyFiltersDelegate = () async => await refreshContent();
    sortController.updateSortDelegate = () async => await refreshContent();
    paginationController.loadDelegate = () async => await _getDocuments();
    paginationController.refreshDelegate = () async => await refreshContent();

    paginationController.pullDownEnabled = true;

    portalInfoController.setup();

    locator<EventHub>().on('needToRefreshDocuments', (dynamic data) {
      refreshContent();
    });
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
    if (paginationController.data.isNotEmpty) paginationController.data.clear();
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
    if (result.files != null) {
      paginationController.data.addAll(result.files);
      filesCount.value = result.files.length;
    }

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

  Future<void> setupSearchMode({String folderName, int folderId}) async {
    loaded.value = true;
    searchMode.value = true;

    _screenName = folderName;
    _currentFolderId = folderId;
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
    locator<EventHub>().fire('needToRefreshDocuments');
    return result != null;
  }

  Future<bool> deleteFolder(Folder element) async {
    var result = await _api.deleteFolder(
      folderId: element.id.toString(),
    );

    locator<EventHub>().fire('needToRefreshDocuments');

    return result != null;
  }

  Future<bool> deleteFile(PortalFile element) async {
    var result = await _api.deleteFile(
      fileId: element.id.toString(),
    );

    locator<EventHub>().fire('needToRefreshDocuments');

    return result != null;
  }

  Future<bool> renameFile(PortalFile element, String newName) async {
    var result = await _api.renameFile(
      fileId: element.id.toString(),
      newTitle: newName,
    );
    locator<EventHub>().fire('needToRefreshDocuments');
    return result != null;
  }

  Future<void> downloadFile(String viewUrl) async {
    final _downloadService = locator<DownloadService>();
    await _downloadService.downloadDocument(viewUrl);
  }

  Future openFile(PortalFile selectedFile) async {
    var userController = Get.find<UserController>();

    await userController.getUserInfo();
    var body = <String, dynamic>{
      'portal': '${portalInfoController.portalName}',
      'email': '${userController.user.email}',
      'file': <String, int>{'id': selectedFile.id},
      'folder': {
        'id': selectedFile.folderId,
        'parentId': null,
        'rootFolderType': selectedFile.rootFolderType
      }
    };

    var bodyString = jsonEncode(body);
    var stringToBase64 = utf8.fuse(base64);
    var encodedBody = stringToBase64.encode(bodyString);
    var urlString = '${Const.Urls.openDocument}$encodedBody';

    if (await canLaunch(urlString)) {
      await launch(urlString);
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.openEditor, {
        AnalyticsService.Params.Key.portal: portalInfoController.portalName,
        AnalyticsService.Params.Key.extension: extension(selectedFile.title)
      });
    } else {
      await LaunchReview.launch(
        androidAppId: Const.Identificators.documentsAndroidAppBundle,
        iOSAppId: Const.Identificators.documentsAppStore,
        writeReview: false,
      );
    }
  }
}
