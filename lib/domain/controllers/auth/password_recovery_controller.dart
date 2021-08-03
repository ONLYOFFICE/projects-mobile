import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/authentication/password_recovery/password_recovery_screen2.dart';

class PasswordRecoveryController extends GetxController {
  final String _email;
  final AuthService _authService = locator<AuthService>();

  PasswordRecoveryController(this._email);

  @override
  void onInit() {
    _emailController.text = _email;
    super.onInit();
  }

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  var emailFieldError = false.obs;

  Future onConfirmPressed() async {
    if (_checkEmail()) {
      var result = await _authService.passwordRecovery(_emailController.text);
      if (result != null) {
        Get.find<NavigationController>()
            .navigateToFullscreen(const PasswordRecoveryScreen2());
      }
    }
  }

  bool _checkEmail() {
    if (!_emailController.text.isEmail) {
      emailFieldError.value = true;
      return false;
    } else {
      emailFieldError.value = false;
      return true;
    }
  }

  void backToLogin() {
    Get.back();
    Get.back();
  }
}
