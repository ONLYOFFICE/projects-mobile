import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class ProfileController extends GetxController {
  final _downloadService = locator<DownloadService>();

  var portalInfoController = Get.find<PortalInfoController>();
  var userController = Get.find<UserController>();

  Rx<PortalUser> user = PortalUser().obs;
  RxBool loaded = false.obs;
  var username = ''.obs;
  var portalName = ''.obs;
  var displayName = ''.obs;
  var email = ''.obs;

  // ignore: unnecessary_cast
  Rx<Widget> avatar = (AppIcon(
          width: 120,
          height: 120,
          icon: SvgIcons.avatar,
          color: Get.theme.colors().onSurface) as Widget)
      .obs;

  Future<void> setup() async {
    await userController.getUserInfo();
    await portalInfoController.setup();

    user.value = userController.user;
    portalName.value = portalInfoController.portalName;
    username.value = userController.user.displayName;

    email.value = userController.user.email;
    await loadAvatar();
  }

  void logout(context) async {
    await Get.dialog(StyledAlertDialog(
      titleText: tr('logOutTitle'),
      acceptText: tr('logOut').toUpperCase(),
      acceptColor: Get.theme.colors().primary,
      onAcceptTap: () async {
        Get.back();
        await Get.find<LoginController>().logout();
      },
    ));
  }

  Future<void> loadAvatar() async {
    try {
      var avatarBytes = await _downloadService.downloadImage(
          user.value?.avatar ??
              user.value?.avatarMedium ??
              user.value?.avatarSmall);
      if (avatarBytes == null) return;

      // ignore: unnecessary_cast
      avatar.value = Image.memory(
        avatarBytes,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      ) as Widget;
    } catch (e) {
      print(e);
      return;
    }
  }
}
