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
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/data/services/user_photo_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/profile/profile_screen.dart';

class PortalUserItemController extends GetxController {
  final _downloadService = locator<DownloadService>();
  final _userPhotoService = locator<UserPhotoService>();

  final userTitle = ''.obs;

  final PortalUser portalUser;
  final profileAvatar = ''.obs;
  final isSelected = false.obs;
  final selectionMode = UserSelectionMode.None.obs;

  final avatarData = Uint8List.fromList([]).obs;

  // ignore: unnecessary_cast
  Rx<Widget> avatar = (AppIcon(
    width: 40,
    height: 40,
    icon: SvgIcons.avatar,
    color: Get.theme.colors().onSurface,
  ) as Widget)
      .obs;

  String? get displayName => portalUser.displayName;
  String? get id => portalUser.id;

  PortalUserItemController({
    required this.portalUser,
    bool isSelected = false,
    UserSelectionMode selectionMode = UserSelectionMode.None,
  }) {
    this.isSelected.value = isSelected;
    this.selectionMode.value = selectionMode;

    setupUser();
  }

  Future<void> loadAvatar() async {
    try {
      final avatarUrl = portalUser.avatarMedium ?? portalUser.avatar ?? portalUser.avatarSmall;
      if (avatarUrl == null) return;
      final avatarBytes = await _downloadService.downloadImage(avatarUrl);
      if (avatarBytes == null) return;

      avatarData.value = avatarBytes;
      avatar.value = Image.memory(avatarData.value);

      unawaited(_getProfileAvatarUrl(portalUser));
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> _getProfileAvatarUrl(PortalUser user) async {
    if (user.id != null) {
      final userPhoto = await _userPhotoService.getUserPhoto(user.id!);
      if (userPhoto?.big != null) {
        profileAvatar.value = userPhoto!.max!;
      } else {
        profileAvatar.value = user.avatar ?? user.avatarMedium ?? user.avatarSmall ?? '';
      }
    }
  }

  void setupUser() {
    if (portalUser.title != null) {
      userTitle.value = portalUser.title!;
    }
    loadAvatar();
  }

  void onTap() {
    if (selectionMode.value == UserSelectionMode.None) return;

    if (selectionMode.value == UserSelectionMode.Single ||
        selectionMode.value == UserSelectionMode.Multiple)
      isSelected.value = !isSelected.value;
    else
      Get.find<NavigationController>().toScreen(
        const ProfileScreen(),
        transition: Transition.rightToLeft,
        arguments: {'controller': this},
      );
  }
}
