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
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/models/from_api/portal_file.dart';
import 'package:projects/data/services/discussion_item_service.dart';
import 'package:projects/domain/controllers/documents/base_documents_controller.dart';
import 'package:projects/domain/controllers/documents/documents_filter_controller.dart';
import 'package:projects/domain/controllers/documents/documents_sort_controller.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class DiscussionsDocumentsController extends BaseDocumentsController {
  final _userController = Get.find<UserController>();
  final _api = locator<DiscussionItemService>();

  final _discussion = Rxn<Discussion>();

  TextEditingController searchInputController = TextEditingController();

  final _paginationController = PaginationController();

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

  final _sortController = DocumentsSortController();
  @override
  DocumentsSortController get sortController => _sortController;

  final _filterController = DocumentsFilterController();
  @override
  DocumentsFilterController get filterController => _filterController;

  @override
  RxBool get hasFilters => _filterController.hasFilters;

  bool get canCopy => false;

  bool get canMove => false;

  bool get canRename => false;

  bool get canDelete => !_userController.user.value!.isVisitor!;

  @override
  int countFiles() => filesCount.value = _discussion.value?.files?.length ?? 0;

  late StreamSubscription _refreshDocumentsSubscription;

  DiscussionsDocumentsController() {
    screenName = tr('documents');

    _filterController.applyFiltersDelegate = () async => {}; // await refreshContent();
    sortController.updateSortDelegate = () async => {}; //await refreshContent();
    paginationController.loadDelegate = () async => {}; //await _getDocuments();
    paginationController.refreshDelegate = () async => await refreshContent();

    paginationController.pullDownEnabled = true;

    portalInfoController.setup();

    _discussion.listen((discussion) {
      if (discussion == null) return;
      _setupFiles(discussion.files!);
    });

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

  void setup(Discussion disc) {
    _discussion.value = disc;
    _setupFiles(disc.files!);

    loaded.value = true;
  }

  void _setupFiles(List<PortalFile> files) {
    paginationController.data.clear();
    paginationController.data.addAll(files);

    filesCount.value = _discussion.value?.files?.length ?? 0;
  }

  Future<void> refreshContent({bool showLoading = true}) async {
    if (showLoading) loaded.value = false;
    final result = await _api.getMessageDetailed(id: _discussion.value!.id!);

    if (result != null) _discussion.value = result;

    if (showLoading) loaded.value = true;
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
