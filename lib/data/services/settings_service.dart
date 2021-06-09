import 'package:projects/data/services/passcode_service.dart';
import 'package:projects/internal/locator.dart';

class SettingsService {
  final _passcodeService = locator<PasscodeService>();

  Future<bool> get isPasscodeEnable async =>
      await _passcodeService.isPasscodeEnable;
}
