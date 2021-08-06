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

import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/profile/profile_screen.dart';

class PortalUserItemController extends GetxController {
  final _downloadService = locator<DownloadService>();

  var userTitle = ''.obs;

  PortalUserItemController({this.portalUser, this.isSelected}) {
    setupUser();
  }

  final PortalUser portalUser;
  var isSelected;
  var selectionMode = UserSelectionMode.None.obs;

  Rx<Uint8List> avatarData = Uint8List.fromList([]).obs;

  String get displayName => portalUser.displayName;
  String get id => portalUser.id;

  Future<void> loadAvatar() async {
    try {
      var avatarBytes =
          await _downloadService.downloadImage(portalUser.avatarMedium);
      if (avatarBytes == null) return;

      avatarData.value = avatarBytes;
    } catch (e) {
      // TODO if no user.avatarMedium case
      // only prints error now
      // test: "3 resp" task
      print(e);
      return;
    }
  }

  void setupUser() {
    isSelected ??= false.obs;
    if (portalUser?.title != null) {
      userTitle.value = portalUser.title;
    }
    loadAvatar();
  }

  void onTap() {
    if (selectionMode.value == UserSelectionMode.Single ||
        selectionMode.value == UserSelectionMode.Multiple)
      isSelected.value = !isSelected.value;
    else
      Get.find<NavigationController>()
          .to(const ProfileScreen(), arguments: {'portalUser': portalUser});
  }
}
