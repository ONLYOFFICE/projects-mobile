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
