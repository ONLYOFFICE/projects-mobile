/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'dart:io';

import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class LocalAuthenticationService {
  final _localAuth = LocalAuthentication();

  Future<BiometricType?> get availableBiometrics async {
    final biometrics = await _localAuth.getAvailableBiometrics();
    if (biometrics.contains(BiometricType.face) && Platform.isIOS) return BiometricType.face;
    if (biometrics.contains(BiometricType.fingerprint)) return BiometricType.fingerprint;
    if (biometrics.contains(BiometricType.strong) && Platform.isAndroid)
      return BiometricType.fingerprint;
    return null;
  }

  Future<bool> get isBiometricAvailable async {
    final canCheckBiometrics = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    final biometrics = await availableBiometrics;
    return biometrics != null && canCheckBiometrics && isDeviceSupported;
  }

  Future<bool> authenticate({String? signInTitle}) async {
    return _localAuth.authenticate(
      localizedReason: ' ',
      authMessages: [
        AndroidAuthMessages(
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
      ],
      options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
    );
  }
}
