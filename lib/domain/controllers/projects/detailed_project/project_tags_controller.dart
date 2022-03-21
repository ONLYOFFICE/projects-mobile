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

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/models/tag_item_DTO.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/projects/base_project_editor_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class ProjectTagsController extends GetxController {
  final _api = locator<ProjectService>();

  final searchInputController = TextEditingController();

  final usersList = [].obs;
  final loaded = true.obs;

  final isSearchResult = false.obs;

  final tags = <TagItemDTO>[].obs;
  final filteredTags = <TagItemDTO>[].obs;

  final projectDetailedTags = <String>[].obs;

  late BaseProjectEditorController _projController;

  final fabIsVisible = false.obs;

  void onLoading() async {}

  StreamSubscription? _ss;

  Future<void> setup(BaseProjectEditorController projController) async {
    _projController = projController;

    loaded.value = false;

    tags.clear();
    projectDetailedTags.clear();
    filteredTags.clear();

    final allTags = await _api.getProjectTags();

    for (final value in projController.tags) {
      projectDetailedTags.add(value as String);
    }

    if (allTags != null) {
      for (final tag in allTags) {
        final isSelected = projectDetailedTags.contains(tag.title).obs;

        tags.add(TagItemDTO(isSelected: isSelected, tag: tag));
        filteredTags.add(TagItemDTO(isSelected: isSelected, tag: tag));
      }
    }

    getFabVisibility(Get.find<UserController>().user.value);
    _ss ??= Get.find<UserController>().user.listen(getFabVisibility);

    loaded.value = true;
  }

  @override
  void onClose() {
    _ss?.cancel();

    super.onClose();
  }

  Future<void> confirm() async {
    _projController.tags.clear();
    for (final tag in tags) {
      if (tag.isSelected!.value) {
        _projController.tags.add(tag.tag!.title);
      }
    }
    _projController.tagsText.value = _projController.tags.join(', ');
    Get.back();
  }

  Future changeTagSelection(TagItemDTO tag) async {
    tag.isSelected!.value = !tag.isSelected!.value;

    final index = tags.indexWhere((element) => element.tag!.id == tag.tag!.id);
    tags[index].isSelected?.value = tag.isSelected!.value;
  }

  Future<void> createTag(String value) async {
    final res = await _api.createTag(name: value);
    if (res != null) await setup(_projController);
  }

  void newSearch(String searchValue) {
    if (searchValue.isNotEmpty) {
      filteredTags.clear();
      final filter = tags
          .where((tagItem) => tagItem.tag!.title!.toLowerCase().contains(searchValue.toLowerCase()))
          .toList();
      for (final tag in filter) {
        filteredTags.add(tag);
      }
    } else {
      clearSearch();
    }
  }

  void clearSearch() {
    searchInputController.clear();
    filteredTags.clear();
    for (final tag in tags) {
      filteredTags.add(tag);
    }
  }

  void getFabVisibility(PortalUser? user) {
    if (user == null) return;

    if ((user.isAdmin ?? false) ||
        (user.isOwner ?? false) ||
        (user.listAdminModules != null && user.listAdminModules!.contains('projects')))
      fabIsVisible.value = true;
    else
      fabIsVisible.value = false;
  }
}
