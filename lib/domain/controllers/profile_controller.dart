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
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/data/services/user_photo_service.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/domain/controllers/portal_info_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class ProfileController extends GetxController {
  final _downloadService = locator<DownloadService>();
  final _photoService = locator<UserPhotoService>();

  final portalInfoController = Get.find<PortalInfoController>();
  final userController = Get.find<UserController>();

  final user = PortalUser().obs;
  final username = ''.obs;
  final portalName = ''.obs;
  final displayName = ''.obs;
  final email = ''.obs;
  final status = (-1).obs;
  final isVisitor = false.obs;
  final isOwner = false.obs;
  final isAdmin = false.obs;

  final avatar = Rx<Widget>(
    AppIcon(
      width: 120,
      height: 120,
      icon: SvgIcons.avatar,
      color: Theme.of(Get.context!).colors().onSurface,
    ),
  );

  ProfileController() {
    if (userController.user.value != null)
      setUserData(userController.user.value!);
    else
      unawaited(userController.updateData());

    userController.user.listen((user) {
      if (user == null) return;
      setUserData(user);
    });

    portalInfoController.setup().then((value) {
      portalName.value = portalInfoController.portalName!;
    });
  }

  void setUserData(PortalUser _user) {
    user.value = _user;
    username.value = _user.displayName!;
    status.value = _user.status!;
    isVisitor.value = _user.isVisitor!;
    isOwner.value = _user.isOwner!;
    isAdmin.value = _user.isAdmin!;
    email.value = _user.email!;

    loadAvatar();
  }

  void logout(context) async {
    await Get.dialog(StyledAlertDialog(
      titleText: tr('logOutTitle'),
      acceptText: tr('logOut').toUpperCase(),
      acceptColor: Theme.of(context as BuildContext).colors().colorError,
      onAcceptTap: () async {
        await Get.find<LoginController>().logout();
      },
    ));
  }

  Future<void> loadAvatar() async {
    final photoUrl = await _photoService.getUserPhoto(user.value.id!);
    try {
      final avatarBytes = await _downloadService.downloadImage(
          photoUrl?.max ?? user.value.avatar ?? user.value.avatarMedium ?? user.value.avatarSmall!);
      if (avatarBytes == null) return;

      avatar.value = Image.memory(
        avatarBytes,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    } catch (e) {
      print(e);
      return;
    }
  }
}
