import 'package:get/get.dart';

class PasscodeController extends GetxController {
  String _passcode = '';
  RxInt passcodeLen = 0.obs;

  void addNumberToPasscode(int number) {
    if (_passcode.length < 4) {
      _passcode += number.toString();
      passcodeLen.value++;
    }
  }

  void deleteNumber() {
    if (_passcode.isNotEmpty) {
      _passcode = _passcode.substring(0, passcodeLen.value - 1);
      passcodeLen.value--;
    }
  }
}
