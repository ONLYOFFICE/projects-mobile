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

import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/move_folder_response.dart';
import 'package:synchronized/synchronized.dart';

import 'package:projects/data/api/files_api.dart';
import 'package:projects/data/models/from_api/folder.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/domain/controllers/documents/base_documents_controller.dart';
import 'package:projects/domain/controllers/documents/conflict_resolving_dialog.dart';
import 'package:projects/domain/controllers/documents/documents_filter_controller.dart';
import 'package:projects/domain/controllers/documents/documents_sort_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/documents/documents_move_or_copy_view.dart';

enum MoveOrCopyMode { CopyDocument, CopyFolder, MoveDocument, MoveFolder }

class DocumentsMoveOrCopyController extends BaseDocumentsController {
  final FilesService _api = locator<FilesService>();

  TextEditingController searchInputController = TextEditingController();

  String _query = '';

  int? initialFolderId;

  @override
  int? get currentFolderID => initialFolderId;

  Timer? _searchDebounce;

  late MoveOrCopyMode mode;

  int nestingCounter = 1;

  int? _targetId;

  int? get target => _targetId;

  String? _screenName;
  Folder? _currentFolder;

  Folder? get currentFolder => _currentFolder;

  final _paginationController = Get.find<PaginationController>();
  @override
  PaginationController get paginationController => _paginationController;
  @override
  RxList get itemList => _paginationController.data;

  final _sortController = Get.find<DocumentsSortController>();
  @override
  DocumentsSortController get sortController => _sortController;

  final _filterController = Get.find<DocumentsFilterController>();
  @override
  DocumentsFilterController get filterController => _filterController;

  @override
  RxBool get hasFilters => _filterController.hasFilters;

  final _lock = Lock();

  DocumentsMoveOrCopyController() {
    _filterController.applyFiltersDelegate = () async => refreshContent();

    sortController.updateSortDelegate = () async => refreshContent();
    paginationController.loadDelegate = () async => _getDocuments();
    paginationController.refreshDelegate = () async => refreshContent();

    paginationController.pullDownEnabled = true;

    documentsScreenName.value = tr('chooseSection');
  }

  Future<void> refreshContent() async {
    if (_currentFolder == null) {
      await initialSetup();
    } else
      await setupFolder(folder: _currentFolder, folderName: documentsScreenName.value);
  }

  Future<void> initialSetup() async {
    loaded.value = false;

    _clear();
    await _getDocuments();
    loaded.value = true;
  }

  void setupOptions(int? targetId, int? initial) {
    _targetId = targetId;
    initialFolderId = initial;
  }

  Future<void> setupFolder({required String folderName, Folder? folder}) async {
    loaded.value = false;

    _clear();
    _currentFolder = folder;
    _filterController.folderId = _currentFolder!.id;
    documentsScreenName.value = folderName;
    screenName = folderName;
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
    final result = await _api.getFilesByParams(
      folderId: _currentFolder == null ? null : _currentFolder!.id,
      query: _query,
      startIndex: paginationController.startIndex,
      sortBy: sortController.currentSortfilter,
      sortOrder: sortController.currentSortOrder,
      typeFilter: _filterController.typeFilter,
      authorFilter: _filterController.authorFilter,
    );

    if (result == null) return;

    paginationController.total.value = result.total!;

    if (_currentFolder != null && result.current != null) _screenName = result.current!.title;

    paginationController.data.addAll(result.folders!);
    paginationController.data.addAll(result.files!);

    countFolders();

    documentsScreenName.value = _screenName ?? tr('chooseSection');
    screenName = _screenName ?? tr('chooseSection');
  }

  void clearSearch() {
    _query = '';

    searchInputController.clear();
    nothingFound.value = false;

    paginationController.startIndex = 0;
    paginationController.data.clear();
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

  void _performSearch() async {
    loaded.value = false;
    nothingFound.value = false;

    await _getDocuments();

    if (paginationController.data.isEmpty) {
      nothingFound.value = true;
    }

    loaded.value = true;
  }

  void processMoveOrCopy() {
    if (_lock.locked) return;

    unawaited(_lock.synchronized(() async {
      final conflictsResult = await _api.checkForConflicts(
        destFolderId: _currentFolder!.id.toString(),
        folderIds: mode == MoveOrCopyMode.CopyFolder || mode == MoveOrCopyMode.MoveFolder
            ? [_targetId.toString()]
            : null,
        fileIds: mode == MoveOrCopyMode.CopyDocument || mode == MoveOrCopyMode.MoveDocument
            ? [_targetId.toString()]
            : null,
      );
      if (conflictsResult == null) {
        MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
        return;
      }

      ConflictResolveType? type = ConflictResolveType.Skip;
      if (conflictsResult.isNotEmpty) {
        final titles = <String>[];
        for (final portalFile in conflictsResult) titles.add(portalFile.title!);

        type = await showConflictResolvingDialog(titles);
      }

      if (type == null) return;
      if (type == ConflictResolveType.Skip && conflictsResult.isNotEmpty) {
        Get.close(nestingCounter);
        return;
      }

      MoveFolderResponse? result;
      if (mode == MoveOrCopyMode.CopyFolder || mode == MoveOrCopyMode.CopyDocument)
        result = await _api.copyDocument(
          copyingFile: mode == MoveOrCopyMode.CopyDocument ? _targetId.toString() : null,
          copyingFolder: mode == MoveOrCopyMode.CopyFolder ? _targetId.toString() : null,
          targetFolder: _currentFolder!.id.toString(),
          type: type,
        );
      if (mode == MoveOrCopyMode.MoveDocument || mode == MoveOrCopyMode.MoveFolder)
        result = await _api.moveDocument(
          movingFile: mode == MoveOrCopyMode.MoveDocument ? _targetId.toString() : null,
          movingFolder: mode == MoveOrCopyMode.MoveFolder ? _targetId.toString() : null,
          targetFolder: _currentFolder!.id.toString(),
          type: type,
        );

      Get.close(nestingCounter);
      if (result != null)
        switch (mode) {
          case MoveOrCopyMode.CopyDocument:
            MessagesHandler.showSnackBar(context: Get.context!, text: tr('fileCopied'));
            break;
          case MoveOrCopyMode.CopyFolder:
            MessagesHandler.showSnackBar(context: Get.context!, text: tr('folderCopied'));
            break;
          case MoveOrCopyMode.MoveDocument:
            MessagesHandler.showSnackBar(context: Get.context!, text: tr('fileMoved'));
            break;
          case MoveOrCopyMode.MoveFolder:
            MessagesHandler.showSnackBar(context: Get.context!, text: tr('folderMoved'));
            break;
        }
      else
        MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));

      locator<EventHub>().fire('needToRefreshDocuments');
    }));
  }

  void cancelCopying() {
    if (_lock.locked) return;

    _lock.synchronized(() => Get.close(nestingCounter));
  }

  @override
  void showSearch() {
    Get.find<NavigationController>()
        .toScreen(DocumentsMoveSearchView(), preventDuplicates: false, arguments: {
      'mode': mode,
      'folderName': documentsScreenName.value,
      'target': target,
      'currentFolder': currentFolder,
      'initialFolderId': initialFolderId,
      'nestingCounter': nestingCounter,
    });
  }

  @override
  // TODO: implement expandedCardView
  RxBool get expandedCardView => throw UnimplementedError();

  @override
  // TODO: implement showAll
  RxBool get showAll => throw UnimplementedError();
}
