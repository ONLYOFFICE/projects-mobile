import 'package:get/get.dart';
import 'package:projects/data/services/passcode_service.dart';
import 'package:projects/domain/controllers/passcode/passcode_checking_controller.dart';
import 'package:projects/domain/controllers/settings/settings_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/settings/passcode/edit/edit_passcode_screen1.dart';
import 'package:projects/presentation/views/settings/passcode/edit/enter_current_passcode_screen.dart';
import 'package:projects/presentation/views/settings/passcode/new/new_passcode_screen1.dart';
import 'package:projects/presentation/views/settings/passcode/new/new_passcode_screen2.dart';

class PasscodeSettingsController extends GetxController {
  final _service = locator<PasscodeService>();
  String _passcode = '';
  String _passcodeCheck = '';

  var loaded = false.obs;
  var passcodeCheckFailed = false.obs;
  var isPasscodeEnable;
  var isFingerprintEnable;
  var isFingerprintAvailable;

  RxInt enteredPasscodeLen = 0.obs;
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
      enteredPasscodeLen.value++;
    }
    if (_passcode.length == 4) {
      Get.to(() => NewPasscodeScreen2());
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
          Get.find<PasscodeCheckingController>().onInit();
          // ignore: empty_catches
        } catch (_) {}
        _onPasscodeSaved();
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
      _passcode = _passcode.substring(0, enteredPasscodeLen.value - 1);
      enteredPasscodeLen.value--;
    }
  }

  void deletePasscodeCheckNumber() {
    passcodeCheckFailed.value = false;
    if (_passcodeCheck.isNotEmpty) {
      _passcodeCheck = _passcodeCheck.substring(0, passcodeCheckLen.value - 1);
      passcodeCheckLen.value--;
    }
  }

  Future<void> _disablePasscode() async {
    await _service.deletePasscode();
    if (isFingerprintEnable.value == true) {
      await _service.setFingerprintStatus(false);
      isFingerprintEnable.value = false;
    }
    leave();
  }

  void leavePasscodeSettingsScreen() {
    clear();
    Get.find<SettingsController>().onInit();
    Get.back();
  }

  void leave() {
    clear();
    Get.back();
  }

  void clear() {
    _passcodeCheck = '';
    passcodeCheckLen.value = 0;
    passcodeCheckFailed.value = false;
    _passcode = '';
    enteredPasscodeLen.value = 0;
  }

  void tryEnablingPasscode() async {
    isPasscodeEnable.value = true;
    await Get.to(() => NewPasscodeScreen1(), preventDuplicates: false);
  }

  void tryDisablingPasscode() async {
    isPasscodeEnable.value = false;
    await Get.to(
      () => EnterCurrentPasscodeScreen(
        onPass: _disablePasscode,
        onBack: () {
          isPasscodeEnable.value = true;
          Get.back();
        },
      ),
      preventDuplicates: false,
    );
  }

  Future<void> tryChangingPasscode() async {
    await Get.to(
        () => EnterCurrentPasscodeScreen(
            onPass: () => Get.to(() => EditPasscodeScreen1())),
        preventDuplicates: false);
  }

  void onPasscodeTilePressed(value) {
    if (value == true) {
      tryEnablingPasscode();
    } else {
      tryDisablingPasscode();
    }
  }

  void tryTogglingFingerprintStatus(bool value) {
    isFingerprintEnable.value = value;
    Get.to(
      () => EnterCurrentPasscodeScreen(
        onPass: () => _toggleFingerprintStatus(value),
        onBack: () {
          isFingerprintEnable.value = !value;
          Get.back();
        },
      ),
      preventDuplicates: false,
    );
  }

  void _toggleFingerprintStatus(value) {
    if (isFingerprintAvailable.value == true) {
      isFingerprintEnable.value = value;
      _service.setFingerprintStatus(value);
    }
    Get.back();
  }

  void _onPasscodeSaved() {
    clear();
    Get.back();
    Get.back();
  }
}
