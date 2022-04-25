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
import 'package:get/get.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/base/base_filter_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/select_group_screen.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/users/select_user_screen.dart';

class DocumentsFilterController extends BaseFilterController {
  final FilesService _api = locator<FilesService>();
  final Storage _storage = locator<Storage>();

  Function? applyFiltersDelegate;
  String? entityType;

  String _typeFilter = '';
  String _authorFilter = '';
  String _searchSettingsFilter = '';

  String _currentAppliedTypeFilter = '';
  String _currentAppliedAuthorFilter = '';
  String _currentAppliedSearchSettingsFilter = '';

  late RxMap contentTypes;
  late RxMap searchSettings;
  late RxMap author;

  late Map _currentAppliedContentTypes;
  late Map _currentAppliedSearchSettings;
  late Map _currentAppliedAuthor;

  String get typeFilter => _typeFilter;

  String get authorFilter => _authorFilter;

  String get searchSettingsFilter => _searchSettingsFilter;

  var _selfId;
  int? _folderId;

  set folderId(int? value) => _folderId = value;

  bool get _hasFilters => _typeFilter.isNotEmpty || _authorFilter.isNotEmpty;

  @override
  String get filtersTitle => plural('documentsFilterConfirm', suitableResultCount.value);

  DocumentsFilterController() {
    suitableResultCount = (-1).obs;
    loadFilters();
  }

  @override
  Future<void> restoreFilters() async {
    _restoreFilterState();

    hasFilters.value = _hasFilters;

    suitableResultCount.value = -1;

    //applyFiltersDelegate?.call();

// _getSavedFilters();
  }

  Future<void> changeAuthorFilter(String filter, [dynamic newValue = '']) async {
    _selfId = await Get.find<UserController>().getUserId();
    _authorFilter = '';

    switch (filter) {
      case 'me':
        author['other'] = '';
        author['groups'] = '';
        author['no'] = false;
        author['me'] = !(author['me'] as bool);
        if (author['me'] as bool) _authorFilter = '&userIdOrGroupId=$_selfId';
        break;
      case 'users':
        author['me'] = false;
        author['groups'] = '';
        author['no'] = false;
        if (newValue == null) {
          author['users'] = '';
        } else {
          author['users'] = newValue['displayName'];
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
        author['no'] = !(author['no'] as bool);
        if (author['no'] as bool) {
          _authorFilter = '&userIdOrGroupId=00000000-0000-0000-0000-000000000000';
        }
        break;
      default:
    }
    await getSuitableResultCount();
  }

  Future<void> changeSearchSettingsFilter(String filter) async {
    await getSuitableResultCount();
  }

  Future<void> changeContentTypeFilter(String filter) async {
    _typeFilter = '';

    final newValue = !(contentTypes[filter] as bool);

    contentTypes.forEach((key, value) {
      contentTypes[key] = false;
    });

    contentTypes[filter] = newValue;

    switch (filter) {
      case 'folders':
        if (contentTypes['folders'] as bool) _typeFilter = '&filterType=FoldersOnly';
        break;

      case 'documents':
        if (contentTypes['documents'] as bool) {
          _typeFilter = '&filterType=DocumentsOnly';
        }
        break;

      case 'presentations':
        if (contentTypes['presentations'] as bool) {
          _typeFilter = '&filterType=PresentationsOnly';
        }
        break;

      case 'images':
        if (contentTypes['images'] as bool) _typeFilter = '&filterType=ImagesOnly';
        break;

      case 'spreadsheets':
        if (contentTypes['spreadsheets'] as bool) {
          _typeFilter = '&filterType=SpreadsheetsOnly';
        }
        break;

      case 'media':
        if (contentTypes['media'] as bool) _typeFilter = '&filterType=MediaOnly';
        break;

      case 'archives':
        if (contentTypes['archives'] as bool) _typeFilter = '&filterType=ArchiveOnly';
        break;

      case 'allFiles':
        if (contentTypes['allFiles'] as bool) _typeFilter = '&filterType=None';
        break;

      default:
    }
    await getSuitableResultCount();
  }

  @override
  Future<void> getSuitableResultCount() async {
    suitableResultCount.value = -1;
    hasFilters.value = _hasFilters;

    final result = await _api.getFilesByParams(
      folderId: _folderId,
      typeFilter: typeFilter,
      authorFilter: authorFilter,
      entityType: entityType,
    );

    if (result != null) {
      suitableResultCount.value = result.count!;
    }
  }

  @override
  Future<void> resetFilters() async {
    contentTypes['folders'] = false;
    contentTypes['documents'] = false;
    contentTypes['presentations'] = false;
    contentTypes['spreadsheets'] = false;
    contentTypes['images'] = false;
    contentTypes['media'] = false;
    contentTypes['archives'] = false;
    contentTypes['allFiles'] = false;

    searchSettings['in_content'] = false;
    searchSettings['exclude_subfolders'] = false;

    author['me'] = false;
    author['users'] = '';
    author['groups'] = '';
    author['no'] = false;

    _typeFilter = '';
    _authorFilter = '';
    _searchSettingsFilter = '';

    await getSuitableResultCount();
  }

  @override
  Future<void> applyFilters() async {
    hasFilters.value = _hasFilters;

    _updateFilterState();

    suitableResultCount.value = -1;

    applyFiltersDelegate?.call();
  }

  // UNUSED
  @override
  Future<void> saveFilters() async {
    await _storage.write(
      'documentsFilters',
      {
        'contentTypes': {'buttons': contentTypes, 'value': _typeFilter},
        'searchSettings': {'buttons': searchSettings, 'value': _searchSettingsFilter},
        'author': {'buttons': author, 'value': _authorFilter},
        'hasFilters': _hasFilters,
      },
    );
  }

  @override
  Future<void> loadFilters() async {
    contentTypes = {
      'folders': false,
      'documents': false,
      'presentations': false,
      'spreadsheets': false,
      'images': false,
      'media': false,
      'archives': false,
      'allFiles': false,
    }.obs;
    searchSettings = {'in_content': false, 'exclude_subfolders': false}.obs;
    author = {
      'me': false,
      'users': '',
      'groups': '',
      'no': false,
    }.obs;

    _currentAppliedAuthor = Map.from(author);
    _currentAppliedContentTypes = Map.from(contentTypes);
    _currentAppliedSearchSettings = Map.from(searchSettings);

    _updateFilterState();
  }

  // UNUSED
  // ignore: unused_element
  Future<void> _getSavedFilters() async {
    final savedFilters = await _storage.read('documentFilters');

    if (savedFilters != null) {
      try {
        contentTypes = Map.from(
          savedFilters['contentTypes']['buttons'] as Map<String, dynamic>,
        ).obs;
        _typeFilter = savedFilters['contentTypes']['value'] as String;

        searchSettings = Map.from(
          savedFilters['searchSettings']['buttons'] as Map<String, dynamic>,
        ).obs;
        _searchSettingsFilter = savedFilters['searchSettings']['value'] as String;

        author = Map.from(savedFilters['author']['buttons'] as Map<String, dynamic>).obs;
        _authorFilter = savedFilters['author']['value'] as String;

        hasFilters.value = savedFilters['hasFilters'] as bool;
      } catch (e) {
        print(e);
        await loadFilters();
      }
    } else {
      await loadFilters();
    }
  }

  void _updateFilterState() {
    _currentAppliedAuthor = Map.from(author);
    _currentAppliedContentTypes = Map.from(contentTypes);
    _currentAppliedSearchSettings = Map.from(searchSettings);

    _currentAppliedTypeFilter = typeFilter;
    _currentAppliedAuthorFilter = authorFilter;
    _currentAppliedSearchSettingsFilter = searchSettingsFilter;
  }

  void _restoreFilterState() {
    contentTypes = RxMap.from(_currentAppliedContentTypes);
    author = RxMap.from(_currentAppliedAuthor);
    searchSettings = RxMap.from(_currentAppliedSearchSettings);

    _typeFilter = _currentAppliedTypeFilter;
    _authorFilter = _currentAppliedAuthorFilter;
    _searchSettingsFilter = _currentAppliedSearchSettingsFilter;
  }

  // navigation
  Future onUsersFilterPressed() async => await navigationController.toScreen(
        const SelectUserScreen(),
        page: '/SelectUserScreen',
      );

  Future onGroupsFilterPressed() async => await navigationController.toScreen(
        const SelectGroupScreen(),
        page: '/SelectGroupScreen',
      );

  void back() => navigationController.back();
}
