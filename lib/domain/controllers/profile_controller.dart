import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_user.dart';
import 'package:projects/data/services/download_service.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';

class ProfileController extends GetxController {
  final _downloadService = locator<DownloadService>();
  // ignore: unnecessary_cast
  Rx<Widget> avatar = (AppIcon(
          width: 120,
          height: 120,
          icon: SvgIcons.avatar,
          color: Get.theme.colors().onSurface) as Widget)
      .obs;

  void logout(context) async {
    await Get.dialog(StyledAlertDialog(
      titleText: tr('logOutTitle'),
      acceptText: tr('logOut').toUpperCase(),
      acceptColor: Get.theme.colors().primary,
      onAcceptTap: () async {
        Get.back();
        await Get.put(LoginController()).logout();
        await Get.offAllNamed('PortalInputView');
      },
    ));
  }

  Future<void> loadAvatar(PortalUser portalUser) async {
    try {
      var avatarBytes = await _downloadService.downloadImage(
          portalUser?.avatar ??
              portalUser?.avatarMedium ??
              portalUser?.avatarSmall);
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
