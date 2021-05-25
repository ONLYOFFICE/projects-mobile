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
