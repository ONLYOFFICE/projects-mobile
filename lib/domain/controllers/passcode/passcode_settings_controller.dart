import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/passcode_service.dart';
import 'package:projects/domain/controllers/passcode/passcode_controller.dart';
import 'package:projects/domain/controllers/settings/settings_controller.dart';
import 'package:projects/internal/locator.dart';

class PasscodeSettingsController extends GetxController {
  final _service = locator<PasscodeService>();
  String _passcode = '';
  String _passcodeCheck = '';

  var loaded = false.obs;
  var passcodeCheckFailed = false.obs;
  var isPasscodeEnable;
  var isFingerprintEnable;
  var isFingerprintAvailable;

  RxInt passcodeLen = 0.obs;
  RxInt passcodeCheckLen = 0.obs;

  @override
  void onInit() async {
    loaded.value = false;
    var isPassEnable = await _service.isPasscodeEnable;
    var isFinEnable = await _service.isFingerprintEnable;
    var isFinAvailable = await _service.isFingerprintAvailable;
    isPasscodeEnable = isPassEnable.obs;
    if (isFinAvailable) {
      isFingerprintEnable = isFinEnable.obs;
      isFingerprintAvailable = true.obs;
    } else {
      isFingerprintEnable = false.obs;
      isFingerprintAvailable = false.obs;
    }
    loaded.value = true;
    super.onInit();
  }

  void addNumberToPasscode(int number) {
    if (_passcode.length < 4) {
      _passcode += number.toString();
      passcodeLen.value++;
    }
    if (_passcode.length == 4) {
      Get.toNamed('NewPasscodeScreen2');
    }
  }

  void addNumberToPasscodeCheck(int number) {
    if (_passcodeCheck.length < 4) {
      passcodeCheckFailed.value = false;
      _passcodeCheck += number.toString();
      passcodeCheckLen.value++;
    }
    if (_passcodeCheck.length == 4) {
      if (_passcode == _passcodeCheck) {
        _service.setPasscode(_passcode);
        try {
          // update code in main passcode controller
          Get.find<PasscodeController>().onInit();
          // ignore: empty_catches
        } catch (e) {}
        leave();
      } else {
        passcodeCheckFailed.value = true;
      }
    }
  }

  void cancelEnablingPasscode() async {
    var isPassEnable = await _service.isPasscodeEnable;
    isPasscodeEnable.value = isPassEnable;
    leave();
  }

  void deleteNumber() {
    if (_passcode.isNotEmpty) {
      _passcode = _passcode.substring(0, passcodeLen.value - 1);
      passcodeLen.value--;
    }
  }

  void deletePasscodeCheckNumber() {
    passcodeCheckFailed.value = false;
    if (_passcodeCheck.isNotEmpty) {
      _passcodeCheck = _passcodeCheck.substring(0, passcodeCheckLen.value - 1);
      passcodeCheckLen.value--;
    }
  }

  Future<void> disablePasscode() async {
    await _service.deletePasscode();
    leave();
  }

  void leavePasscodeSettingsScreen() {
    clear();
    Get.find<SettingsController>().onInit();
    Get.offNamed('SettingsScreen');
  }

  void leave() {
    clear();
    Get.offNamed('PasscodeSettingsScreen');
  }

  void clear() {
    _passcodeCheck = '';
    passcodeCheckLen.value = 0;
    passcodeCheckFailed.value = false;
    _passcode = '';
    passcodeLen.value = 0;
  }

  void tryEnablingPasscode() async {
    isPasscodeEnable.value = true;
    await Get.toNamed('NewPasscodeScreen1',
        arguments: {'title': tr('enterPasscode')});
  }

  void tryDisablingPasscode() async {
    isPasscodeEnable.value = false;
    await Get.toNamed(
      'CurrentPasscodeCheckScreen',
      arguments: {
        'title': tr('enterCurrentPasscode'),
        'caption': '',
        'onPass': disablePasscode
      },
    );
  }

  Future<void> tryChangingPasscode() async {
    await Get.toNamed(
      'CurrentPasscodeCheckScreen',
      arguments: {
        'title': tr('enterCurrentPasscode'),
        'caption': '',
        'onPass': () => Get.toNamed('NewPasscodeScreen1',
            arguments: {'title': tr('enterNewPasscode'), 'caption': ''})
      },
    );
  }

  void onPasscodeTilePressed(value) {
    if (value == true) {
      tryEnablingPasscode();
    } else {
      tryDisablingPasscode();
    }
  }

  void toggleFingerprintStatus(value) {
    if (isFingerprintAvailable.value == true) {
      isFingerprintEnable.value = value;
      _service.setFingerprintStatus(value);
    }
  }
}
