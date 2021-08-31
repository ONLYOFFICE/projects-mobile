import 'package:projects/data/services/local_authentication_service.dart';
import 'package:projects/data/services/storage/secure_storage.dart';
import 'package:projects/internal/locator.dart';

class PasscodeService {
  final _storage = locator<SecureStorage>();
  final _biometricService = locator<LocalAuthenticationService>();

  Future<String> get getPasscode async => await _storage.getString('passcode');

  Future<void> setPasscode(String code) async {
    await deletePasscode();
    await _storage.putString('passcode', code);
  }

  Future<void> deletePasscode() async => await _storage.delete('passcode');

  Future<void> setFingerprintStatus(bool isEnable) async {
    var status = isEnable ? 'true' : 'false';
    await _storage.delete('isFingerprintEnable');
    await _storage.putString('isFingerprintEnable', status);
  }

  Future<bool> get isFingerprintEnable async {
    var isFingerprintEnable =
        await _storage.getString('isFingerprintEnable') ?? false;

    return isFingerprintEnable == 'true' ? true : false;
  }

  Future<bool> get isFingerprintAvailable async {
    var isFingerprintAvailable =
        await _biometricService.isFingerprintAvailable ?? false;

    return isFingerprintAvailable;
  }

  Future<bool> get isPasscodeEnable async {
    var isPasscodeEnable = await _storage.getString('passcode') ?? false;
    if (isPasscodeEnable != false) return true;
    return false;
  }
}
