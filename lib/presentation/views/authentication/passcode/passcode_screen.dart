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
import 'package:projects/domain/controllers/passcode/passcode_controller.dart';

import 'package:projects/internal/utils/adaptive_size.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_dot.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_numbers.dart';

class PasscodeScreen extends StatelessWidget {
  const PasscodeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PasscodeController());

    return Scaffold(
      body: Obx(
        () {
          if (controller.loaded.value == true) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: h(170)),
                  Text(
                    tr('passcodeToUnlock'),
                    textAlign: TextAlign.center,
                    style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onBackground,
                    ),
                  ),
                  SizedBox(
                    height: h(72),
                    child: Column(
                      children: [
                        const Flexible(flex: 1, child: SizedBox(height: 16)),
                        if (controller.passcodeCheckFailed.value == true)
                          Text(tr('incorrectPIN'),
                              style: TextStyleHelper.subtitle1(
                                  color: Get.theme.colors().colorError)),
                        const Flexible(flex: 2, child: SizedBox(height: 32)),
                      ],
                    ),
                  ),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < 4; i++)
                          PasscodeDot(
                            inputLenght: controller.passcodeLen.value,
                            position: i,
                            passwordIsWrong:
                                controller.passcodeCheckFailed.value,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: h(165)),
                  PasscodeNumbersRow(
                    numbers: [1, 2, 3],
                    onPressed: controller.addNumberToPasscode,
                  ),
                  PasscodeNumbersRow(
                    numbers: [4, 5, 6],
                    onPressed: controller.addNumberToPasscode,
                  ),
                  PasscodeNumbersRow(
                    numbers: [7, 8, 9],
                    onPressed: controller.addNumberToPasscode,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controller.isFingerprintAvailable &&
                          controller.isFingerprintEnable)
                        FingerprintButton(onTap: controller.useFingerprint),
                      if (!controller.isFingerprintAvailable ||
                          !controller.isFingerprintEnable)
                        const SizedBox(width: 72.53),
                      const SizedBox(width: 20.53),
                      PasscodeNumber(
                          number: 0, onPressed: controller.addNumberToPasscode),
                      const SizedBox(width: 20.53),
                      DeleteButton(onTap: controller.deleteNumber),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
