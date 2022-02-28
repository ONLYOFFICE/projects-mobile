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

import 'package:easy_localization/easy_localization.dart';
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
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/constants.dart';
import 'package:projects/internal/locator.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscussionsDocumentsController extends BaseDocumentsController {
  final FilesService _api = locator<FilesService>();

  final _userController = Get.find<UserController>();

  TextEditingController searchInputController = TextEditingController();

  late PaginationController _paginationController;

  @override
  PaginationController get paginationController => _paginationController;

  @override
  RxList get itemList => _paginationController.data;

  String? _entityType;

  String? get entityType => _entityType;

  set entityType(String? value) => {_entityType = value, _filterController.entityType = value};

  int? _currentFolderId;

  @override
  int? get currentFolderID => _currentFolderId;

  late DocumentsSortController _sortController;

  @override
  DocumentsSortController get sortController => _sortController;

  late DocumentsFilterController _filterController;

  @override
  RxBool get hasFilters => _filterController.hasFilters;

  @override
  DocumentsFilterController get filterController => _filterController;

  bool get canCopy => false;

  bool get canMove => false;

  bool get canRename => false;

  bool get canDelete => !_userController.user.value!.isVisitor!;

  DiscussionsDocumentsController(
    DocumentsFilterController filterController,
    PaginationController paginationController,
    DocumentsSortController sortController,
  ) {
    screenName = tr('documents');

    _sortController = sortController;
    _paginationController = paginationController;
    _filterController = filterController;
    _filterController.applyFiltersDelegate = () async => {}; // await refreshContent();
    sortController.updateSortDelegate = () async => {}; //await refreshContent();
    paginationController.loadDelegate = () async => {}; //await _getDocuments();
    paginationController.refreshDelegate = () async => {}; //await refreshContent();

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
    final result = await _api.renameFolder(
      folderId: element.id.toString(),
      newTitle: newName,
    );

    return result != null;
  }

  void downloadFolder() {}

  Future<bool> deleteFolder(Folder element) async {
    final result = await _api.deleteFolder(
      folderId: element.id.toString(),
    );

    return result != null;
  }

  Future<bool> deleteFile(PortalFile element) async {
    final result = await _api.deleteFile(
      fileId: element.id.toString(),
    );

    return result != null;
  }

  Future<void> downloadFile(String viewUrl) async {
    await locator<DocumentsDownloadService>().downloadDocument(viewUrl);
  }

  Future openFile(PortalFile selectedFile) async {
    final userController = Get.find<UserController>();

    await userController.getUserInfo();
    final body = <String, dynamic>{
      'portal': portalInfoController.portalName,
      'email': userController.user.value!.email,
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
}
