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
import 'package:projects/domain/controllers/auth/password_recovery_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/authentication/widgets/auth_text_field.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class PasswordRecoveryScreen1 extends StatelessWidget {
  const PasswordRecoveryScreen1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var email;

    if (Get.arguments != null) email = Get.arguments['email'];

    var controller = Get.put(PasswordRecoveryController(email));

    return Scaffold(
      appBar: StyledAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Get.theme.backgroundColor,
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const SizedBox(height: 20.71),
                AppIcon(icon: SvgIcons.password_recovery),
                const SizedBox(height: 6.71),
                Text(
                  tr('passwordRecovery'),
                  style: TextStyleHelper.headline6(),
                ),
                const SizedBox(height: 17.71),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    tr('emailDescription'),
                    textAlign: TextAlign.center,
                    style: TextStyleHelper.subtitle1(),
                  ),
                ),
                const SizedBox(height: 76),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Obx(
                    () => AuthTextField(
                      hasError: controller.emailFieldError.value == true,
                      controller: controller.emailController,
                      autofillHint: AutofillHints.email,
                      hintText: tr('email'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: WideButton(
                    text: tr('confirm'),
                    onPressed: () => controller.onConfirmPressed(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
