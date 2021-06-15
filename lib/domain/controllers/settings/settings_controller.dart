import 'package:get/get.dart';
import 'package:projects/data/services/settings_service.dart';
import 'package:projects/internal/locator.dart';

class SettingsController extends GetxController {
  final _service = locator<SettingsService>();

  var loaded = false.obs;

  var isPasscodeEnable;

  @override
  void onInit() async {
    loaded.value = false;
    var isPassEnable = await _service.isPasscodeEnable;
    isPasscodeEnable = isPassEnable.obs;
    loaded.value = true;
    super.onInit();
  }

  void leave() => Get.offNamed('/');
}
