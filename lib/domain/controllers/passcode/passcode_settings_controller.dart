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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:projects/data/services/passcode_service.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/passcode/passcode_checking_controller.dart';
import 'package:projects/domain/controllers/settings/settings_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/settings/passcode/edit/edit_passcode_screen1.dart';
import 'package:projects/presentation/views/settings/passcode/edit/enter_current_passcode_screen.dart';
import 'package:projects/presentation/views/settings/passcode/new/new_passcode_screen1.dart';
import 'package:projects/presentation/views/settings/passcode/new/new_passcode_screen2.dart';

class PasscodeSettingsController extends GetxController {
  final PasscodeService _service = locator<PasscodeService>();

  String _passcode = '';
  String _passcodeCheck = '';

  final loaded = false.obs;
  final passcodeCheckFailed = false.obs;
  final isPasscodeEnable = false.obs;
  final isBiometricEnable = false.obs;
  final isBiometricAvailable = false.obs;

  late final BiometricType? biometricType;
  late final String biometricTypeDescription;
  RxInt enteredPasscodeLen = 0.obs;
  RxInt passcodeCheckLen = 0.obs;

  @override
  Future<void> onInit() async {
    loaded.value = false;

    isPasscodeEnable.value = await _service.isPasscodeEnable;

    biometricType = await _service.getBiometricType();
    biometricTypeDescription =
        biometricType == BiometricType.face ? tr('faceID') : tr('fingerprint');

    if (await _service.isBiometricAvailable) {
      isBiometricEnable.value = await _service.isBiometricEnable;
      isBiometricAvailable.value = true;
    } else {
      isBiometricEnable.value = false;
      isBiometricAvailable.value = false;
      await _service.setBiometricStatus(false);
    }

    loaded.value = true;

    super.onInit();
  }

  void addNumberToPasscode(int number) {
    if (_passcode.length < 4) {
      _passcode += number.toString();
      enteredPasscodeLen.value++;
    }
    if (_passcode.length == 4) {
      Get.to(NewPasscodeScreen2.new);
    }
  }

  void addNumberToPasscodeCheck(int number) async {
    if (_passcodeCheck.length < 4) {
      passcodeCheckFailed.value = false;
      _passcodeCheck += number.toString();
      passcodeCheckLen.value++;
    }
    if (_passcodeCheck.length == 4) {
      if (_passcode == _passcodeCheck) {
        await _service.setPasscode(_passcode);
        try {
          // update code in main passcode controller
          await Get.find<PasscodeCheckingController>().updatePasscode();
          // ignore: empty_catches
        } catch (_) {}
        _onPasscodeSaved();
      } else {
        await HapticFeedback.mediumImpact();
        _handleIncorrectPasscodeEntering();
        passcodeCheckFailed.value = true;
      }
    }
  }

  void cancelEnablingPasscode() async {
    final isPassEnable = await _service.isPasscodeEnable;
    isPasscodeEnable.value = isPassEnable;
    leave();
  }

  void deleteNumber() {
    if (_passcode.isNotEmpty) {
      _passcode = _passcode.substring(0, enteredPasscodeLen.value - 1);
      enteredPasscodeLen.value--;
    }
  }

  void deletePasscodeCheckNumber() {
    if (passcodeCheckFailed.isTrue) _clearPasscodeCheck();
    if (_passcodeCheck.isNotEmpty) {
      _passcodeCheck = _passcodeCheck.substring(0, passcodeCheckLen.value - 1);
      passcodeCheckLen.value--;
    }
  }

  Future<void> _disablePasscode() async {
    await _service.deletePasscode();
    isPasscodeEnable.value = false;
    if (isBiometricEnable.value == true) {
      await _service.setBiometricStatus(false);
      isBiometricEnable.value = false;
    }
    leave();
  }

  void _clearPasscodeCheck({bool clearError = true}) {
    if (clearError) passcodeCheckFailed.value = false;
    _passcodeCheck = '';
    passcodeCheckLen.value = 0;
  }

  void _handleIncorrectPasscodeEntering() async {
    passcodeCheckFailed.value = true;
    _clearPasscodeCheck(clearError: false);
    await Future.delayed(const Duration(milliseconds: 1700)).then((value) {
      if (passcodeCheckFailed.isTrue) _clearPasscodeCheck();
    });
  }

  void leavePasscodeSettingsScreen() {
    clear();
    Get.find<SettingsController>().onInit();
    Get.find<NavigationController>().back();
  }

  void leave() {
    clear();
    Get.back();
  }

  void clear() {
    _passcodeCheck = '';
    passcodeCheckLen.value = 0;
    passcodeCheckFailed.value = false;
    _passcode = '';
    enteredPasscodeLen.value = 0;
  }

  void tryEnablingPasscode() async {
    isPasscodeEnable.value = true;
    await Get.to(NewPasscodeScreen1.new, preventDuplicates: false);
  }

  void tryDisablingPasscode() async {
    await Get.to(
      () => EnterCurrentPasscodeScreen(onPass: _disablePasscode, onBack: Get.back),
      preventDuplicates: false,
    );
  }

  Future<void> tryChangingPasscode() async {
    await Get.to(
      () => EnterCurrentPasscodeScreen(onPass: () => Get.to(EditPasscodeScreen1.new)),
      preventDuplicates: false,
    );
  }

  void onPasscodeTilePressed(bool value) {
    if (value) {
      tryEnablingPasscode();
    } else {
      tryDisablingPasscode();
    }
  }

  void tryTogglingFingerprintStatus(bool value) {
    isBiometricEnable.value = value;
    Get.to(
      () => EnterCurrentPasscodeScreen(
        onPass: () => _toggleFingerprintStatus(value),
        onBack: () {
          isBiometricEnable.value = !value;
          Get.back();
        },
      ),
      preventDuplicates: false,
    );
  }

  void _toggleFingerprintStatus(bool value) {
    if (isBiometricAvailable.value == true) {
      isBiometricEnable.value = value;
      _service.setBiometricStatus(value);
    }
    Get.back();
  }

  void _onPasscodeSaved() {
    clear();
    Get.back();
    Get.back();
  }

  @override
  void onClose() {
    clear();
    //Get.find<SettingsController>().onInit(); это тут действительно нужно?
    super.onClose();
  }
}
