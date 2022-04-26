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

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:projects/data/services/local_authentication_service.dart';
import 'package:projects/data/services/passcode_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/main_view.dart';

class PasscodeCheckingController extends GetxController {
  void setup({bool canUseBiometric = false}) {
    _canUseBiometric = canUseBiometric;
  }

  bool _canUseBiometric = false;

  final _service = locator<PasscodeService>();
  final _authService = locator<LocalAuthenticationService>();
  late bool isFingerprint;

  final passcodeCheckFailed = false.obs;
  final passcodeLen = 0.obs;
  final loaded = false.obs;

  bool isBiometricEnable = false;
  bool isBiometricAvailable = false;

  String _enteredPasscode = '';
  String? _correctPasscode;

  @override
  void onInit() async {
    if (!await locator<PasscodeService>().isPasscodeEnable) {
      await Get.offAll(() => const MainView());
      return;
    }

    _correctPasscode = await _service.getPasscode;
    await _getBiometricAvailability();
    super.onInit();
    if (isBiometricEnable) await useBiometric();
  }

  // update code in main passcode controller
  Future<void> updatePasscode() async {
    _correctPasscode = await _service.getPasscode;
    await _getBiometricAvailability();
    if (isBiometricEnable) await useBiometric();
  }

  Future<void> useBiometric() async {
    try {
      final didAuthenticate = await _authService.authenticate();

      if (!didAuthenticate) {
        await _getBiometricAvailability();
      } else {
        await Get.offAll(() => const MainView());
      }
    } catch (e) {
      if (e is PlatformException && e.message == 'Biometry is not available.') {
        await _service.setBiometricStatus(false);
      }
      loaded.value = false;
      isBiometricAvailable = false;
      isBiometricEnable = false;
      loaded.value = true;
    }
  }

  Future<void> addNumberToPasscode(
    int number, {
    Function? onPass,
  }) async {
    if (passcodeCheckFailed.isTrue) passcodeCheckFailed.value = false;

    _correctPasscode = _correctPasscode ?? await _service.getPasscode;

    if (_enteredPasscode.length < 4) {
      _enteredPasscode += number.toString();
      passcodeLen.value++;
    }
    if (_enteredPasscode.length == 4) {
      if (_enteredPasscode != _correctPasscode) {
        await HapticFeedback.mediumImpact();
        await _handleIncorrectPinEntering();
      } else {
        _clear();

        if (onPass != null) {
          await onPass();
        } else {
          await Get.offAll(() => const MainView());
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

  Future<void> _handleIncorrectPinEntering() async {
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

  Future<void> _getBiometricAvailability() async {
    loaded.value = false;
    if (!_canUseBiometric) {
      isBiometricAvailable = false;
      isBiometricEnable = false;
    } else {
      final availableBiometrics = await _authService.availableBiometrics;
      isFingerprint = availableBiometrics == BiometricType.fingerprint;
      isBiometricAvailable = availableBiometrics != null;
      isBiometricEnable = await _service.isBiometricEnable;
    }
    loaded.value = true;
  }
}
