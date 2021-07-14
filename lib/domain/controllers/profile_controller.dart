import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/login_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled_alert_dialog.dart';

class ProfileController extends GetxController {
  void logout(context) async {
    await Get.dialog(StyledAlertDialog(
      titleText: tr('logOutTitle'),
      acceptText: tr('logOut').toUpperCase(),
      acceptColor: Get.theme.colors().primary,
      onAcceptTap: () async {
        Get.back();
        await Get.put(LoginController()).logout();
        await Get.offNamed('PortalView');
      },
    ));
  }
}
