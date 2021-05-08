import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/internal/locator.dart';

class PortalUserItemController extends GetxController {
  final _downloadService = locator<DownloadService>();

  var userTitle = ''.obs;

  PortalUserItemController({this.portalUser}) {
    setupUser();
  }
  final PortalUser portalUser;
  var isSelected = false.obs;
  var multipleSelectionEnabled = false.obs;

  // TODO после обновления GETX здесь ошибка
  // Rx<Image> avatarImage = Rx<Image>();
  Rx<Image> avatarImage = null.obs;

  String get displayName => portalUser.displayName;
  String get id => portalUser.id;

  Future<void> loadAvatar() async {
    try {
      var avatarBytes =
          await _downloadService.downloadImage(portalUser.avatarMedium);
      if (avatarBytes == null) return;

      var image = Image.memory(avatarBytes);
      avatarImage = image.obs;
    } catch (e) {
      // TODO if no user.avatarMedium case
      // only prints error now
      // test: "3 resp" task
      print(e);
      return;
    }
  }

  void setupUser() {
    if (portalUser?.title != null) {
      userTitle.value = portalUser.title;
    }
    loadAvatar();
  }
}
