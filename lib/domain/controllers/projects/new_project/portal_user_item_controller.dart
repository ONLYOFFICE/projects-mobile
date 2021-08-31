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
    if (selectionMode.value == UserSelectionMode.None) return;

    if (selectionMode.value == UserSelectionMode.Single ||
        selectionMode.value == UserSelectionMode.Multiple)
      isSelected.value = !isSelected.value;
    else
      Get.find<NavigationController>()
          .to(const ProfileScreen(), arguments: {'portalUser': portalUser});
  }
}
