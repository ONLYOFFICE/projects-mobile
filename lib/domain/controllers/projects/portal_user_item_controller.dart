import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/internal/locator.dart';

class PortalUserItemController extends GetxController {
  final _downloadService = locator<DownloadService>();

  PortalUserItemController({
    this.portalUser,
  }) {
    loadAvatar();
  }
  final PortalUser portalUser;
  var isSelected = false.obs;
  var multipleSelectionEnabled = false.obs;

  Rx<Image> avatarImage = Rx<Image>();

  String get displayName => portalUser.displayName;

  Future<void> loadAvatar() async {
    var avatarBytes =
        await _downloadService.downloadImage(portalUser.avatarMedium);

    if (avatarBytes == null) return;

    var image = Image.memory(avatarBytes);
    avatarImage.value = image;
  }
}
