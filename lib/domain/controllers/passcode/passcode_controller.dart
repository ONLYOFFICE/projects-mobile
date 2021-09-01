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

import 'package:get/get.dart';
import 'package:projects/data/services/local_authentication_service.dart';
import 'package:projects/data/services/passcode_service.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
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

    var nextPage = await _getNextPage();

    if (didAuthenticate) await Get.offNamed(nextPage);
  }

  void addNumberToPasscode(
    int number, {
    String nextPage,
    Map nextPageArguments,
    var onPass,
  }) async {
    nextPage ??= await _getNextPage();

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
          await Get.offNamed(nextPage, arguments: nextPageArguments);
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
}
