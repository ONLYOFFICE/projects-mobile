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
import 'package:get/get.dart';
import 'package:projects/data/services/passcode_service.dart';
import 'package:projects/domain/controllers/passcode/passcode_controller.dart';
import 'package:projects/domain/controllers/settings/settings_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/settings/passcode/screens/current_passcode_check_screen.dart';
import 'package:projects/presentation/views/settings/passcode/screens/new_passcode_screen1.dart';
import 'package:projects/presentation/views/settings/passcode/screens/new_passcode_screen2.dart';

class PasscodeSettingsController extends GetxController {
  final _service = locator<PasscodeService>();
  String _passcode = '';
  String _passcodeCheck = '';

  var loaded = false.obs;
  var passcodeCheckFailed = false.obs;
  var isPasscodeEnable;
  var isFingerprintEnable;
  var isFingerprintAvailable;

  RxInt passcodeLen = 0.obs;
  RxInt passcodeCheckLen = 0.obs;

  @override
  void onInit() async {
    loaded.value = false;
    var isPassEnable = await _service.isPasscodeEnable;
    var isFinEnable = await _service.isFingerprintEnable;
    var isFinAvailable = await _service.isFingerprintAvailable;
    isPasscodeEnable = isPassEnable.obs;
    if (isFinAvailable) {
      isFingerprintEnable = isFinEnable.obs;
      isFingerprintAvailable = true.obs;
    } else {
      isFingerprintEnable = false.obs;
      isFingerprintAvailable = false.obs;
    }
    loaded.value = true;
    super.onInit();
  }

  void addNumberToPasscode(int number) {
    if (_passcode.length < 4) {
      _passcode += number.toString();
      passcodeLen.value++;
    }
    if (_passcode.length == 4) {
      Get.to(() => const NewPasscodeScreen2());
    }
  }

  void addNumberToPasscodeCheck(int number) {
    if (_passcodeCheck.length < 4) {
      passcodeCheckFailed.value = false;
      _passcodeCheck += number.toString();
      passcodeCheckLen.value++;
    }
    if (_passcodeCheck.length == 4) {
      if (_passcode == _passcodeCheck) {
        _service.setPasscode(_passcode);
        try {
          // update code in main passcode controller
          Get.find<PasscodeController>().onInit();
          // ignore: empty_catches
        } catch (_) {}
        leave();
      } else {
        passcodeCheckFailed.value = true;
      }
    }
  }

  void cancelEnablingPasscode() async {
    var isPassEnable = await _service.isPasscodeEnable;
    isPasscodeEnable.value = isPassEnable;
    leave();
  }

  void deleteNumber() {
    if (_passcode.isNotEmpty) {
      _passcode = _passcode.substring(0, passcodeLen.value - 1);
      passcodeLen.value--;
    }
  }

  void deletePasscodeCheckNumber() {
    passcodeCheckFailed.value = false;
    if (_passcodeCheck.isNotEmpty) {
      _passcodeCheck = _passcodeCheck.substring(0, passcodeCheckLen.value - 1);
      passcodeCheckLen.value--;
    }
  }

  Future<void> disablePasscode() async {
    await _service.deletePasscode();
    leave();
  }

  void leavePasscodeSettingsScreen() {
    clear();
    Get.find<SettingsController>().onInit();
    Get.back();
  }

  void leave() {
    clear();

    Get.back();
    Get.back();
  }

  void clear() {
    _passcodeCheck = '';
    passcodeCheckLen.value = 0;
    passcodeCheckFailed.value = false;
    _passcode = '';
    passcodeLen.value = 0;
  }

  void tryEnablingPasscode() async {
    isPasscodeEnable.value = true;
    await Get.to(() => const NewPasscodeScreen1(),
        arguments: {'title': tr('enterPasscode')});
  }

  void tryDisablingPasscode() async {
    isPasscodeEnable.value = false;
    await Get.to(
      () => const CurrentPasscodeCheckScreen(),
      arguments: {
        'title': tr('enterCurrentPasscode'),
        'caption': '',
        'onPass': disablePasscode
      },
    );
  }

  Future<void> tryChangingPasscode() async {
    await Get.to(
      () => const CurrentPasscodeCheckScreen(),
      arguments: {
        'title': tr('enterCurrentPasscode'),
        'caption': '',
        'onPass': () => Get.to(() => const NewPasscodeScreen1(),
            arguments: {'title': tr('enterNewPasscode'), 'caption': ''})
      },
    );
  }

  void onPasscodeTilePressed(value) {
    if (value == true) {
      tryEnablingPasscode();
    } else {
      tryDisablingPasscode();
    }
  }

  void toggleFingerprintStatus(value) {
    if (isFingerprintAvailable.value == true) {
      isFingerprintEnable.value = value;
      _service.setFingerprintStatus(value);
    }
  }
}
