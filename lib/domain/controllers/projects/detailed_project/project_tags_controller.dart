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

import 'package:projects/data/models/tag_itemDTO.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';

class ProjectTagsController extends GetxController {
  final ProjectService _api = locator<ProjectService>();
  final _userController = Get.find<UserController>()..getUserInfo();

  RxList usersList = [].obs;
  RxBool loaded = true.obs;

  RxBool isSearchResult = false.obs;

  RxList<TagItemDTO> tags = <TagItemDTO>[].obs;

  RxList<String?> projectDetailedTags = <String>[].obs;

  var _projController;

  RxBool fabIsVisible = false.obs;

  void onLoading() async {}

  Future<void> setup(projController) async {
    _projController = projController;
    loaded.value = false;
    tags.clear();
    projectDetailedTags.clear();
    var allTags = await _api.getProjectTags();

    if (projController?.tags != null) {
      for (var value in projController?.tags) {
        projectDetailedTags.add(value as String?);
      }
    }

    if (allTags != null) {
      for (var tag in allTags) {
        var isSelected = projectDetailedTags.contains(tag.title).obs;

        tags.add(TagItemDTO(isSelected: isSelected, tag: tag));
      }
    }

    fabIsVisible.value = _userController.user!.isAdmin! ||
        _userController.user!.isOwner! ||
        (_userController.user!.listAdminModules != null &&
            _userController.user!.listAdminModules!.contains('projects'));

    loaded.value = true;
  }

  Future<void> confirm() async {
    _projController.tags.clear();
    for (var tag in tags) {
      if (tag.isSelected!.value) {
        _projController.tags.add(tag.tag!.title);
      }
    }
    _projController.tagsText.value = _projController.tags.join(', ');
    Get.back();
  }

  Future changeTagSelection(TagItemDTO tag) async {
    tag.isSelected!.value = !tag.isSelected!.value;

    _projController.tags.clear();
    for (var tag in tags) {
      if (tag.isSelected!.value) {
        _projController.tags.add(tag.tag!.title);
      }
    }

    _projController.tagsText.value = _projController.tags.join(', ');
  }

  Future<void> createTag(String value) async {
    var res = await _api.createTag(name: value);
    if (res != null) await setup(_projController);
  }
}
