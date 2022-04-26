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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_checking_controller.dart';
import 'package:projects/presentation/shared/widgets/passcode_screen_mixin.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_keyboard_items.dart';

class PasscodeScreen extends StatelessWidget with PasscodeScreenMixin {
  PasscodeScreen({Key? key}) : super(key: key);

  final passcodeCheckingController = Get.find<PasscodeCheckingController>()
    ..setup(canUseBiometric: true);

  @override
  String get title => tr('passcodeToUnlock');

  @override
  RxInt get enteredCodeLen => passcodeCheckingController.passcodeLen;

  @override
  RxBool get hasError => passcodeCheckingController.passcodeCheckFailed;

  @override
  String get errorText => tr('incorrectPIN');

  @override
  void onBackPressed() => {};

  @override
  bool get hasBackButton => false;

  @override
  void onDeletePressed() => passcodeCheckingController.deleteNumber();

  @override
  void onNumberPressed(int number) => passcodeCheckingController.addNumberToPasscode(number);

  @override
  Widget get keyboardLastRow {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          if (passcodeCheckingController.loaded.value == false ||
              !passcodeCheckingController.isBiometricEnable) {
            return const SizedBox(width: 72.53);
          }
          return BiometricButton(
            onTap: passcodeCheckingController.useBiometric,
            isFingerprint: passcodeCheckingController.isFingerprint,
          );
        }),
        const SizedBox(width: 20.53),
        PasscodeNumber(number: 0, onPressed: passcodeCheckingController.addNumberToPasscode),
        const SizedBox(width: 20.53),
        DeleteButton(onTap: passcodeCheckingController.deleteNumber),
      ],
    );
  }
}
