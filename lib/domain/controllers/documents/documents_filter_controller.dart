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
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class DocumentsFilterController extends BaseFilterController {
  final _api = locator<FilesService>();
  Function applyFiltersDelegate;
  String entityType;

  String _typeFilter = '';
  String _authorFilter = '';
  String _searchSettingsFilter = '';

  RxMap<String, dynamic> contentTypes = {
    'folders': false,
    'documents': false,
    'presentations': false,
    'spreadsheets': false,
    'images': false,
    'media': false,
    'archives': false,
    'allFiles': false,
  }.obs;

  RxMap<String, dynamic> searchSettings =
      {'in_content': false, 'exclude_subfolders': false}.obs;

  RxMap<String, dynamic> author = {
    'me': false,
    'users': '',
    'groups': '',
    'no': false,
  }.obs;

  String get typeFilter => _typeFilter;
  String get authorFilter => _authorFilter;
  String get searchSettingsFilter => _searchSettingsFilter;

  var _selfId;
  int _folderId;
  set folderId(int value) => _folderId = value;

  @override
  bool get hasFilters => _typeFilter.isNotEmpty || _authorFilter.isNotEmpty;

  DocumentsFilterController() {
    filtersTitle = 'DOCUMENTS';
    suitableResultCount = (-1).obs;
  }

  Future<void> changeAuthorFilter(String filter, [newValue = '']) async {
    _selfId ??= await Get.find<UserController>().getUserId();
    _authorFilter = '';

    switch (filter) {
      case 'me':
        author['other'] = '';
        author['groups'] = '';
        author['no'] = false;
        author['me'] = !author['me'];
        if (author['me']) _authorFilter = '&userIdOrGroupId=$_selfId';
        break;
      case 'other':
        author['me'] = false;
        author['groups'] = '';
        author['no'] = false;
        if (newValue == null) {
          author['other'] = '';
        } else {
          author['other'] = newValue['displayName'];
          _authorFilter = '&userIdOrGroupId=${newValue["id"]}';
        }
        break;
      case 'groups':
        author['me'] = false;
        author['other'] = '';
        author['no'] = false;
        if (newValue == null) {
          author['groups'] = '';
        } else {
          author['groups'] = newValue['name'];
          _authorFilter = '&userIdOrGroupId=${newValue["id"]}';
        }
        break;
      case 'no':
        author['me'] = false;
        author['other'] = '';
        author['groups'] = '';
        author['no'] = !author['no'];
        if (author['no']) {
          _authorFilter =
              '&userIdOrGroupId=00000000-0000-0000-0000-000000000000';
        }
        break;
      default:
    }
    getSuitableResultCount();
  }

  Future<void> changeSearchSettingsFilter(String filter) async {
    getSuitableResultCount();
  }

  Future<void> changeContentTypeFilter(String filter) async {
    _typeFilter = '';

    var newValue = !contentTypes[filter];

    contentTypes.forEach((key, value) {
      contentTypes[key] = false;
    });

    contentTypes[filter] = newValue;

    switch (filter) {
      case 'folders':
        if (contentTypes['folders']) _typeFilter = '&filterType=FoldersOnly';
        break;

      case 'documents':
        if (contentTypes['documents'])
          _typeFilter = '&filterType=DocumentsOnly';
        break;

      case 'presentations':
        if (contentTypes['presentations'])
          _typeFilter = '&filterType=PresentationsOnly';
        break;

      case 'images':
        if (contentTypes['images']) _typeFilter = '&filterType=ImagesOnly';
        break;

      case 'spreadsheets':
        if (contentTypes['spreadsheets'])
          _typeFilter = '&filterType=SpreadsheetsOnly';
        break;

      case 'media':
        if (contentTypes['media']) _typeFilter = '&filterType=MediaOnly';
        break;

      case 'archives':
        if (contentTypes['archives']) _typeFilter = '&filterType=ArchiveOnly';
        break;

      case 'allFiles':
        if (contentTypes['allFiles']) _typeFilter = '&filterType=None';
        break;

      default:
    }
    getSuitableResultCount();
  }

  @override
  void getSuitableResultCount() async {
    suitableResultCount.value = -1;

    var result = await _api.getFilesByParams(
      folderId: _folderId,
      typeFilter: typeFilter,
      authorFilter: authorFilter,
      entityType: entityType,
    );

    suitableResultCount.value = result.count;
  }

  @override
  void resetFilters() async {
    contentTypes.value = {
      'folders': false,
      'documents': false,
      'presentations': false,
      'spreadsheets': false,
      'images': false,
      'media': false,
      'archives': false,
      'allFiles': false,
    };
    searchSettings.value = {'in_content': false, 'exclude_subfolders': false};
    author.value = {
      'me': false,
      'users': '',
      'groups': '',
      'no': false,
    };

    suitableResultCount.value = -1;

    _typeFilter = '';
    _authorFilter = '';
    _searchSettingsFilter = '';

    applyFilters();
  }

  @override
  void applyFilters() async {
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }
}
