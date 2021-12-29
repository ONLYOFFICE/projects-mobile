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

import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:path/path.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/domain/controllers/documents/base_documents_controller.dart';
import 'package:projects/domain/controllers/documents/documents_filter_controller.dart';
import 'package:projects/domain/controllers/documents/documents_sort_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/portal_info_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/constants.dart';
import 'package:projects/internal/locator.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentsController extends GetxController implements BaseDocumentsController {
  final FilesService _api = locator<FilesService>();
  PortalInfoController portalInfoController = Get.find<PortalInfoController>();

  @override
  RxBool hasFilters = false.obs;
  @override
  RxBool loaded = false.obs;
  @override
  RxBool nothingFound = false.obs;
  @override
  RxBool searchMode = false.obs;

  TextEditingController searchInputController = TextEditingController();

  String? _query;

  String? _entityType;

  String? get entityType => _entityType;
  set entityType(String? value) => {_entityType = value, _filterController.entityType = value};

  late PaginationController _paginationController;
  Timer? _searchDebounce;

  @override
  PaginationController get paginationController => _paginationController;

  @override
  RxList get itemList => _paginationController.data;

  String? _screenName;
  int? _currentFolderId;

  @override
  int? get currentFolderID => _currentFolderId;

  @override
  RxString documentsScreenName = tr('documents').obs;

  RxInt filesCount = RxInt(-1);

  late DocumentsSortController _sortController;

  @override
  DocumentsSortController get sortController => _sortController;

  late DocumentsFilterController _filterController;

  @override
  DocumentsFilterController get filterController => _filterController;

  late StreamSubscription _refreshDocumentsSubscription;

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
    _paginationController.loadDelegate = () async => await _getDocuments();
    _paginationController.refreshDelegate = () async => await refreshContent();

    _paginationController.pullDownEnabled = true;

    portalInfoController.setup();

    _refreshDocumentsSubscription =
        locator<EventHub>().on('needToRefreshDocuments', (dynamic data) {
      refreshContent();
    });
  }

  @override
  void onClose() {
    _refreshDocumentsSubscription.cancel();
    super.onClose();
  }

  Future<void> refreshContent() async {
    if (_currentFolderId == null) {
      await initialSetup();
    } else
      await setupFolder(folderId: _currentFolderId, folderName: documentsScreenName.value);
  }

  Future<void> initialSetup() async {
    loaded.value = false;

    _clear();
    await _getDocuments();
    loaded.value = true;
  }

  Future<void> setupFolder({required String folderName, int? folderId}) async {
    loaded.value = false;

    _clear();
    _currentFolderId = folderId;
    _filterController.folderId = _currentFolderId;
    documentsScreenName.value = folderName;
    screenName = folderName;
    await _getDocuments();

    loaded.value = true;
  }

  void _clear() {
    _screenName = null;
    _currentFolderId = null;

    _filterController.folderId = null;
    _paginationController.startIndex = 0;
    if (_paginationController.data.isNotEmpty) _paginationController.data.clear();
  }

  Future _getDocuments() async {
    final result = await _api.getFilesByParams(
      folderId: _currentFolderId,
      query: _query,
      startIndex: _paginationController.startIndex,
      sortBy: sortController.currentSortfilter,
      sortOrder: sortController.currentSortOrder,
      typeFilter: _filterController.typeFilter,
      authorFilter: _filterController.authorFilter,
      entityType: _entityType,
    );

    if (result == null) return Future.value(false);

    if (result.total != null) paginationController.total.value = result.total!;

    if (_currentFolderId != null && result.current != null) _screenName = result.current!.title;

    if (result.folders != null) _paginationController.data.addAll(result.folders!);
    if (result.files != null) {
      _paginationController.data.addAll(result.files!);
      filesCount.value = result.files!.length;
    }

    documentsScreenName.value = _screenName ?? tr('documents');
    screenName = _screenName ?? tr('documents');

    return Future.value(true);
  }

  void clearSearch() {
    _query = '';

    searchInputController.clear();
    nothingFound.value = false;

    _paginationController.startIndex = 0;
    _paginationController.data.clear();
  }

  void newSearch(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      if (_query != query) {
        _query = query;
        paginationController.startIndex = 0;
        paginationController.data.clear();
        _performSearch();
      }
    });
  }

  Future<void> setupSearchMode({String? folderName, int? folderId}) async {
    loaded.value = true;
    searchMode.value = true;

    _screenName = folderName;
    _currentFolderId = folderId;
  }

  void _performSearch() async {
    loaded.value = false;
    nothingFound.value = false;

    await _getDocuments();

    if (_paginationController.data.isEmpty) {
      nothingFound.value = true;
    }

    loaded.value = true;
  }

  void onFilePopupMenuSelected(value, PortalFile element) {}

  Future<bool> renameFolder(Folder element, String newName) async {
    final result = await _api.renameFolder(
      folderId: element.id.toString(),
      newTitle: newName,
    );
    locator<EventHub>().fire('needToRefreshDocuments');
    return result != null;
  }

  Future<bool> deleteFolder(Folder element) async {
    final result = await _api.deleteFolder(
      folderId: element.id.toString(),
    );

    locator<EventHub>().fire('needToRefreshDocuments');

    return result != null;
  }

  Future<bool> deleteFile(PortalFile element) async {
    final result = await _api.deleteFile(
      fileId: element.id.toString(),
    );

    locator<EventHub>().fire('needToRefreshDocuments');

    return result != null;
  }

  Future<bool> renameFile(PortalFile element, String newName) async {
    final result = await _api.renameFile(
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
    final userController = Get.find<UserController>();

    await userController.getUserInfo();
    final body = <String, dynamic>{
      'portal': '${portalInfoController.portalName}',
      'email': '${userController.user!.email}',
      'file': <String, int?>{'id': selectedFile.id},
      'folder': {
        'id': selectedFile.folderId,
        'parentId': null,
        'rootFolderType': selectedFile.rootFolderType
      }
    };

    final bodyString = jsonEncode(body);
    final stringToBase64 = utf8.fuse(base64);
    final encodedBody = stringToBase64.encode(bodyString);
    final urlString = '${Const.Urls.openDocument}$encodedBody';

    if (await canLaunch(urlString)) {
      await launch(urlString);
      await AnalyticsService.shared.logEvent(AnalyticsService.Events.openEditor, {
        AnalyticsService.Params.Key.portal: portalInfoController.portalName,
        AnalyticsService.Params.Key.extension: extension(selectedFile.title!)
      });
    } else {
      await LaunchReview.launch(
        androidAppId: Const.Identificators.documentsAndroidAppBundle,
        iOSAppId: Const.Identificators.documentsAppStore,
        writeReview: false,
      );
    }
  }

  @override
  // TODO: implement expandedCardView
  RxBool get expandedCardView => throw UnimplementedError();

  @override
  // TODO: implement showAll
  RxBool get showAll => throw UnimplementedError();

  @override
  void showSearch() {
    // TODO: implement showSearch
  }

  @override
  String screenName = tr('documents');
}
