import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/files_service.dart';
import 'package:projects/data/services/storage/storage.dart';
import 'package:projects/domain/controllers/base/base_filter_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class DocumentsFilterController extends BaseFilterController {
  final _api = locator<FilesService>();
  final _storage = locator<Storage>();

  Function applyFiltersDelegate;
  String entityType;

  String _typeFilter = '';
  String _authorFilter = '';
  String _searchSettingsFilter = '';

  RxMap contentTypes;

  RxMap searchSettings;

  RxMap author;

  String get typeFilter => _typeFilter;
  String get authorFilter => _authorFilter;
  String get searchSettingsFilter => _searchSettingsFilter;

  var _selfId;
  int _folderId;
  set folderId(int value) => _folderId = value;

  bool get _hasFilters => _typeFilter.isNotEmpty || _authorFilter.isNotEmpty;

  @override
  String get filtersTitle =>
      plural('documentsFilterConfirm', suitableResultCount.value);

  DocumentsFilterController() {
    suitableResultCount = (-1).obs;
  }

  @override
  void onInit() async {
    await loadFilters();
    super.onInit();
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
    hasFilters.value = _hasFilters;

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

    suitableResultCount.value = -1;

    _typeFilter = '';
    _authorFilter = '';
    _searchSettingsFilter = '';

    getSuitableResultCount();
  }

  @override
  void applyFilters() async {
    hasFilters.value = _hasFilters;
    if (applyFiltersDelegate != null) applyFiltersDelegate();
  }

  // UNUSED
  @override
  Future<void> saveFilters() async {
    await _storage.write(
      'documentsFilters',
      {
        'contentTypes': {'buttons': contentTypes, 'value': _typeFilter},
        'searchSettings': {
          'buttons': searchSettings,
          'value': _searchSettingsFilter
        },
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
  }

  // UNUSED
  // ignore: unused_element
  Future<void> _getSavedFilters() async {
    var savedFilters = await _storage.read('documentFilters');

    if (savedFilters != null) {
      try {
        contentTypes = Map.from(
          savedFilters['contentTypes']['buttons'],
        ).obs;
        _typeFilter = savedFilters['contentTypes']['value'];

        searchSettings = Map.from(
          savedFilters['searchSettings']['buttons'],
        ).obs;
        _searchSettingsFilter = savedFilters['searchSettings']['value'];

        author = Map.from(savedFilters['author']['buttons']).obs;
        _authorFilter = savedFilters['author']['value'];

        hasFilters.value = savedFilters['hasFilters'];
      } catch (e) {
        print(e);
        await loadFilters();
      }
    } else {
      await loadFilters();
    }
  }
}
