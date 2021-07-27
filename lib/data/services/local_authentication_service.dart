import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationService {
  final _localAuth = LocalAuthentication();

  Future<List<BiometricType>> get availableBiometrics async =>
      await _localAuth.getAvailableBiometrics();

  Future<bool> get isFingerprintAvailable async {
    var canCheckBiometrics = await _localAuth.canCheckBiometrics;
    var biometrics = await availableBiometrics;
    var isFingerprintAvailable = biometrics.contains(BiometricType.fingerprint);
    final isDeviceSupported = await _localAuth.isDeviceSupported();

    return canCheckBiometrics && isFingerprintAvailable && isDeviceSupported;
  }

  Future<bool> authenticate({String signInTitle}) async {
    return await _localAuth.authenticate(
      localizedReason: ' ',
      androidAuthStrings: AndroidAuthMessages(
        biometricHint: '',
        biometricNotRecognized: '',
        biometricRequiredTitle: '',
        biometricSuccess: '',
        deviceCredentialsRequiredTitle: '',
        deviceCredentialsSetupDescription: '',
        goToSettingsButton: '',
        goToSettingsDescription: '',
        signInTitle: signInTitle,
      ),
      stickyAuth: true,
      biometricOnly: true,
    );
  }
}
