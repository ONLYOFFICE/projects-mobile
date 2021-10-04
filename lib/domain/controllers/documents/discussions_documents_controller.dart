import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:projects/data/services/analytics_service.dart';
import 'package:projects/internal/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
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

class DiscussionsDocumentsController extends GetxController {
  final _api = locator<FilesService>();
  var portalInfoController = Get.find<PortalInfoController>();

  final _userController = Get.find<UserController>();

  var hasFilters = false.obs;
  var loaded = false.obs;
  var nothingFound = false.obs;
  var searchMode = false.obs;

  var searchInputController = TextEditingController();

  PaginationController _paginationController;

  String _entityType;

  String get entityType => _entityType;
  set entityType(String value) =>
      {_entityType = value, _filterController.entityType = value};

  PaginationController get paginationController => _paginationController;

  int _currentFolderId;
  int get currentFolder => _currentFolderId;

  var screenName = tr('documents').obs;

  RxList get itemList => _paginationController.data;

  DocumentsSortController _sortController;
  DocumentsSortController get sortController => _sortController;

  DocumentsFilterController _filterController;
  DocumentsFilterController get filterController => _filterController;

  bool get canCopy => false;
  bool get canMove => false;
  bool get canRename => false;
  bool get canDelete => !_userController.user.isVisitor;

  DiscussionsDocumentsController(
    DocumentsFilterController filterController,
    PaginationController paginationController,
    DocumentsSortController sortController,
  ) {
    _sortController = sortController;
    _paginationController = paginationController;
    _filterController = filterController;
    _filterController.applyFiltersDelegate =
        () async => {}; // await refreshContent();
    sortController.updateSortDelegate =
        () async => {}; //await refreshContent();
    paginationController.loadDelegate = () async => {}; //await _getDocuments();
    paginationController.refreshDelegate =
        () async => {}; //await refreshContent();

    paginationController.pullDownEnabled = true;

    portalInfoController.setup();
  }

  void setupFiles(List<PortalFile> files) {
    loaded.value = false;
    paginationController.data.clear();
    paginationController.data.addAll(files);
    loaded.value = true;
  }

  void onFilePopupMenuSelected(value, PortalFile element) {}

  Future<bool> renameFolder(Folder element, String newName) async {
    var result = await _api.renameFolder(
      folderId: element.id.toString(),
      newTitle: newName,
    );

    return result != null;
  }

  void downloadFolder() {}

  Future<bool> deleteFolder(Folder element) async {
    var result = await _api.deleteFolder(
      folderId: element.id.toString(),
    );

    return result != null;
  }

  Future<bool> deleteFile(PortalFile element) async {
    var result = await _api.deleteFile(
      fileId: element.id.toString(),
    );

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
    } else {
      await LaunchApp.openApp(
        androidPackageName: Const.Identificators.documentsAndroidAppBundle,
        iosUrlScheme: urlString,
        appStoreLink: Const.Urls.appStoreDocuments,
      );
      await AnalyticsService.shared
          .logEvent(AnalyticsService.Events.openEditor, {
        AnalyticsService.Params.Key.portal: portalInfoController.portalName,
        AnalyticsService.Params.Key.extension: extension(selectedFile.title)
      });
    }
  }
}
