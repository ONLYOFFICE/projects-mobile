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
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/2fa_sms_controller.dart';
import 'package:projects/internal/utils/adaptive_size.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/wrappers/platform_text_button.dart';
import 'package:projects/presentation/shared/wrappers/platform_text_field.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class EnterSMSCodeScreen extends StatelessWidget {
  const EnterSMSCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TFASmsController controller;

    try {
      controller = Get.find<TFASmsController>();
    } catch (e) {
      controller = Get.put(TFASmsController());
      final phoneNoise = Get.arguments['phoneNoise'] as String;
      final login = Get.arguments['login'] as String;
      final password = Get.arguments['password'] as String;
      controller.initLoginAndPass(login, password);
      controller.setPhoneNoise(phoneNoise);
    }
    final codeController = MaskedTextController(mask: '*** ***');

    return Scaffold(
      appBar: StyledAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: Container(
              //color: Get.theme.backgroundColor,
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  SizedBox(height: h(24.71)),
                  AppIcon(
                    icon: SvgIcons.password_recovery,
                    color: Get.theme.colors().onBackground,
                  ),
                  SizedBox(height: h(20.74)),
                  Text(tr('enterSendedCode'),
                      style: TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface)),
                  Text(controller.phoneNoise!,
                      style: TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface)
                          .copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: h(100)),
                  Obx(
                    () => PlatformTextField(
                      controller: codeController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyleHelper.subtitle1(),
                      obscureText: true,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: controller.codeError.value == true
                                ? Get.theme.colors().colorError
                                : Get.theme.colors().onSurface.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: controller.codeError.value == true
                                ? Get.theme.colors().colorError
                                : Get.theme.colors().onSurface.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      height: h(24),
                      child: controller.codeError.value == true
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                tr('incorrectCode'),
                                style:
                                    TextStyleHelper.caption(color: Get.theme.colors().colorError),
                              ),
                            )
                          : null,
                    ),
                  ),
                  WideButton(
                    text: tr('confirm'),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    onPressed: () {
                      print(codeController.text);
                      controller.onConfirmPressed(codeController.text);
                    },
                  ),
                  PlatformTextButton(
                    onPressed: controller.resendSms,
                    child: Text(tr('requestNewCode')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
