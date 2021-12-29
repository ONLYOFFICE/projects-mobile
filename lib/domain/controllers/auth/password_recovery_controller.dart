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

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/authentication_service.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/authentication/password_recovery/password_recovery_screen2.dart';

class PasswordRecoveryController extends GetxController {
  late final String _email;
  final AuthService _authService = locator<AuthService>();

  PasswordRecoveryController(this._email);

  @override
  void onInit() {
    _emailController.text = _email;
    super.onInit();
  }

  final TextEditingController _emailController = TextEditingController();

  TextEditingController get emailController => _emailController;

  RxBool emailFieldError = false.obs;

  Future onConfirmPressed() async {
    if (_checkEmail()) {
      final result = await _authService.passwordRecovery(email: _emailController.text);
      if (result != null) await Get.to(() => const PasswordRecoveryScreen2());
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
