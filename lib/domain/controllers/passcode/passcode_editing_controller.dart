import 'package:get/get.dart';
import 'package:projects/data/services/passcode_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/settings/passcode/edit/edit_passcode_screen2.dart';

class PasscodeEditingController extends GetxController {
  final PasscodeService _service = locator<PasscodeService>();
  String _passcode = '';
  String _passcodeCheck = '';

  var passcodeCheckFailed = false.obs;
  RxInt enteredPasscodeLen = 0.obs;
  RxInt passcodeCheckLen = 0.obs;

  void addNumberToPasscode(int number) {
    if (_passcode.length < 4) {
      _passcode += number.toString();
      enteredPasscodeLen.value++;
    }
    if (_passcode.length == 4) {
      Get.to(() => EditPasscodeScreen2());
    }
  }

  void deleteNumber() {
    if (_passcode.isNotEmpty) {
      _passcode = _passcode.substring(0, enteredPasscodeLen.value - 1);
      enteredPasscodeLen.value--;
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
        _onPasscodeSaved();
      } else {
        passcodeCheckFailed.value = true;
      }
    }
  }

  void deletePasscodeCheckNumber() {
    passcodeCheckFailed.value = false;
    if (_passcodeCheck.isNotEmpty) {
      _passcodeCheck = _passcodeCheck.substring(0, passcodeCheckLen.value - 1);
      passcodeCheckLen.value--;
    }
  }

  void _clear() {
    _passcodeCheck = '';
    passcodeCheckLen.value = 0;
    passcodeCheckFailed.value = false;
    _passcode = '';
    enteredPasscodeLen.value = 0;
  }

  void leave1Page() {
    _clear();
    Get.back();
  }

  void leave2Page() {
    _clear();
    Get.back();
  }

  void _onPasscodeSaved() {
    _clear();
    Get.back();
    Get.back();
    Get.back();
  }
}
