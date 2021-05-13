import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/internal/locator.dart';

class PortalUserItemController extends GetxController {
  final _downloadService = locator<DownloadService>();

  var userTitle = ''.obs;

  PortalUserItemController({
    this.portalUser,
  }) {
    setupUser();
  }
  final PortalUser portalUser;
  var isSelected = false.obs;
  var selectionMode = UserSelectionMode.None.obs;

  Rx<Image> avatarImage = Rx<Image>();

  String get displayName => portalUser.displayName;
  String get id => portalUser.id;

  Future<void> loadAvatar() async {
    var avatarBytes =
        await _downloadService.downloadImage(portalUser.avatarMedium);

    if (avatarBytes == null) return;

    var image = Image.memory(avatarBytes);
    avatarImage.value = image;
  }

  void setupUser() {
    if (portalUser.title != null) {
      userTitle.value = portalUser.title;
    }
    loadAvatar();
  }

  void onTap() {
    if (selectionMode.value == UserSelectionMode.Single ||
        selectionMode.value == UserSelectionMode.Multiple)
      isSelected.value = !isSelected.value;
  }
}
