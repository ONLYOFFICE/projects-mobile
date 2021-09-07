import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/profile/profile_screen.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';

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

  // ignore: unnecessary_cast
  Rx<Widget> avatar = (AppIcon(
          width: 40,
          height: 40,
          icon: SvgIcons.avatar,
          color: Get.theme.colors().onSurface) as Widget)
      .obs;

  String get displayName => portalUser.displayName;
  String get id => portalUser.id;

  Future<void> loadAvatar() async {
    try {
      var avatarBytes = await _downloadService.downloadImage(
          portalUser?.avatar ??
              portalUser?.avatarMedium ??
              portalUser?.avatarSmall);
      if (avatarBytes == null) return;

      avatarData.value = avatarBytes;
      // ignore: unnecessary_cast
      avatar.value = Image.memory(avatarData.value) as Widget;
    } catch (e) {
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
    if (selectionMode.value == UserSelectionMode.None) return;

    if (selectionMode.value == UserSelectionMode.Single ||
        selectionMode.value == UserSelectionMode.Multiple)
      isSelected.value = !isSelected.value;
    else
      Get.find<NavigationController>()
          .to(const ProfileScreen(), arguments: {'portalUser': portalUser});
  }
}
