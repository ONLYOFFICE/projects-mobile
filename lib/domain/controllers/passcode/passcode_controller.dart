import 'package:get/get.dart';
import 'package:projects/data/services/local_authentication_service.dart';
import 'package:projects/data/services/passcode_service.dart';
import 'package:projects/internal/locator.dart';

class PasscodeController extends GetxController {
  final _service = locator<PasscodeService>();
  final _authService = locator<LocalAuthenticationService>();

  var passcodeCheckFailed = false.obs;
  RxInt passcodeLen = 0.obs;
  var loaded = false.obs;

  bool isFingerprintEnable;
  bool isFingerprintAvailable;

  String _enteredPasscode = '';
  String _correctPasscode;

  @override
  void onInit() async {
    isFingerprintEnable = await _service.isFingerprintEnable;
    _correctPasscode = await _service.getPasscode;
    isFingerprintAvailable = await _authService.isFingerprintAvailable;
    loaded.value = true;
    super.onInit();
  }

  Future<void> useFingerprint() async {
    var didAuthenticate = await _authService.authenticate();
    if (didAuthenticate) await Get.offAndToNamed('/');
  }

  void addNumberToPasscode(
    int number, {
    String nextPage = '/',
    Map nextPageArguments,
    var onPass,
  }) async {
    if (_enteredPasscode.length < 4) {
      passcodeCheckFailed.value = false;
      _enteredPasscode += number.toString();
      passcodeLen.value++;
    }
    if (_enteredPasscode.length == 4) {
      if (_enteredPasscode != _correctPasscode) {
        passcodeCheckFailed.value = true;
      } else {
        clear();
        if (onPass != null) {
          await onPass();
        } else {
          await Get.offAndToNamed(nextPage, arguments: nextPageArguments);
        }
      }
    }
  }

  void deleteNumber() {
    if (_enteredPasscode.isNotEmpty) {
      passcodeCheckFailed.value = false;
      _enteredPasscode = _enteredPasscode.substring(0, passcodeLen.value - 1);
      passcodeLen.value--;
    }
  }

  void clear() {
    passcodeCheckFailed.value = false;
    _enteredPasscode = '';
    passcodeLen.value = 0;
  }

  void leave() {
    clear();
    Get.back();
  }
}
