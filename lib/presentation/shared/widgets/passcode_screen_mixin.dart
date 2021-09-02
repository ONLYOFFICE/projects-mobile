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
import 'package:projects/internal/utils/adaptive_size.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_dot.dart';
import 'package:projects/presentation/views/settings/passcode/passcode_keyboard_items.dart';

mixin PasscodeScreenMixin on StatelessWidget {
  void onBackPressed();
  void onNumberPressed(int number);
  void onDeletePressed();

  RxInt get enteredCodeLen;
  RxBool get hasError => false.obs;

  final bool hasBackButton = true;

  final String title = tr('enterPasscode');
  final String caption = null;
  final String errorText = null;

  final Widget keyboardLastRow = null;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (hasBackButton) onBackPressed();
        return hasBackButton;
      },
      child: Scaffold(
        appBar: hasBackButton
            ? StyledAppBar(elevation: 0, onLeadingPressed: onBackPressed)
            : null,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: hasBackButton ? h(114) : h(170)),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.headline6(
                      color: Get.theme.colors().onBackground)),
              SizedBox(
                  height: h(72),
                  child: Obx(() {
                    return Column(children: [
                      const Flexible(flex: 1, child: SizedBox(height: 16)),
                      if (hasError.isTrue)
                        Text(errorText,
                            textAlign: TextAlign.center,
                            style: TextStyleHelper.subtitle1(
                                color: Get.theme.colors().colorError)),
                      if (hasError.isFalse && caption != null)
                        Text(caption,
                            textAlign: TextAlign.center,
                            style: TextStyleHelper.subtitle1(
                                color: Get.theme
                                    .colors()
                                    .onBackground
                                    .withOpacity(0.6))),
                      const Flexible(flex: 2, child: SizedBox(height: 32)),
                    ]);
                  })),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 4; i++)
                      PasscodeDot(
                        position: i,
                        inputLenght: enteredCodeLen.value,
                        passwordIsWrong: hasError.value,
                      ),
                  ],
                ),
              ),
              SizedBox(height: h(165)),
              PasscodeNumbersRow(
                numbers: [1, 2, 3],
                onPressed: onNumberPressed,
              ),
              PasscodeNumbersRow(
                numbers: [4, 5, 6],
                onPressed: onNumberPressed,
              ),
              PasscodeNumbersRow(
                numbers: [7, 8, 9],
                onPressed: onNumberPressed,
              ),
              keyboardLastRow ??
                  PasscodeRowWithZero(
                    onZeroPressed: onNumberPressed,
                    onDeletePressed: onDeletePressed,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
