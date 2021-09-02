import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/local_authentication_service.dart';
import 'package:projects/data/services/passcode_service.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/internal/locator.dart';

class PasscodeCheckingController extends GetxController {
  PasscodeCheckingController({this.canUseFingerprint = false});

  final bool canUseFingerprint;

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
    _correctPasscode = await _service.getPasscode;
    await _getFingerprintAvailability();
    super.onInit();
    if (isFingerprintEnable) await useFingerprint();
  }

  Future<void> useFingerprint() async {
    try {
      var didAuthenticate = await _authService.authenticate();

      if (!didAuthenticate) {
        await _getFingerprintAvailability();
      } else {
        var nextPage = await _getNextPage();
        await Get.offNamed(nextPage);
      }
    } catch (_) {
      loaded.value = false;
      isFingerprintAvailable = false;
      isFingerprintEnable = false;
      loaded.value = true;
    }
  }

  void addNumberToPasscode(
    int number, {
    String nextPage,
    Map nextPageArguments,
    var onPass,
  }) async {
    nextPage ??= await _getNextPage();

    if (passcodeCheckFailed.isTrue) passcodeCheckFailed.value = false;

    if (_enteredPasscode.length < 4) {
      _enteredPasscode += number.toString();
      passcodeLen.value++;
    }
    if (_enteredPasscode.length == 4) {
      if (_enteredPasscode != _correctPasscode) {
        await HapticFeedback.mediumImpact();
        _handleIncorrectPinEntering();
      } else {
        _clear();
        if (onPass != null) {
          await onPass();
        } else {
          await Get.offNamed(nextPage, arguments: nextPageArguments);
        }
      }
    }
  }

  void deleteNumber() {
    if (passcodeCheckFailed.isTrue) _clear();
    if (_enteredPasscode.isNotEmpty) {
      _enteredPasscode = _enteredPasscode.substring(0, passcodeLen.value - 1);
      passcodeLen.value--;
    }
  }

  void _clear({bool clearError = true}) {
    if (clearError) passcodeCheckFailed.value = false;
    _enteredPasscode = '';
    passcodeLen.value = 0;
  }

  void _handleIncorrectPinEntering() async {
    passcodeCheckFailed.value = true;

    _clear(clearError: false);

    await Future.delayed(const Duration(milliseconds: 1700)).then((value) {
      if (passcodeCheckFailed.isTrue) _clear();
    });
  }

  void leave() {
    _clear();
    Get.back();
  }

  Future<String> _getNextPage() async {
    LoginController loginController;
    try {
      loginController = Get.find<LoginController>();
    } catch (_) {
      loginController = Get.put(LoginController());
    }

    if (await loginController.isLoggedIn) return 'NavigationView';
    return 'PortalView';
  }

  Future<void> _getFingerprintAvailability() async {
    loaded.value = false;
    if (!canUseFingerprint) {
      isFingerprintAvailable = false;
      isFingerprintEnable = false;
    } else {
      isFingerprintAvailable = await _authService.isFingerprintAvailable;
      isFingerprintEnable = await _service.isFingerprintEnable;
    }
    loaded.value = true;
  }
}
