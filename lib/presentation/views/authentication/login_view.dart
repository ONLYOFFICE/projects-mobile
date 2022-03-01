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

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/privacy_and_terms_footer.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/shared/wrappers/platform_text_button.dart';
import 'package:projects/presentation/views/authentication/password_recovery/password_recovery_screen1.dart';
import 'package:projects/presentation/views/authentication/widgets/auth_text_field.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    final styledAppBar = StyledAppBar(
      backButtonIcon: Platform.isAndroid ? Icon(PlatformIcons(context).clear) : null,
      leading: Platform.isIOS
          ? Align(
              alignment: Alignment.centerLeft,
              child: CupertinoNavigationBarBackButton(
                onPressed: Get.back,
                previousPageTitle: tr('back').toLowerCase().capitalizeFirst,
              ),
            )
          : null,
      leadingWidth: Platform.isIOS ? 150 : null,
      elevation: Platform.isAndroid ? 1 : 0,
      title: Platform.isAndroid
          ? Text(
              tr('addNewAccount'),
              style: TextStyleHelper.headline6(color: Get.theme.colors().onSurface),
            )
          : null,
      titleHeight: Platform.isIOS ? 50 : 56,
      centerTitle: Platform.isIOS,
    );

    final passwordFocusNode = FocusNode();

    return WillPopScope(
      onWillPop: () async {
        controller.leaveLoginScreen();
        return false;
      },
      child: Scaffold(
        appBar: styledAppBar,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                constraints: BoxConstraints(
                  maxWidth: 480,
                  maxHeight: Get.height -
                      styledAppBar.titleHeight -
                      styledAppBar.bottomHeight -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: Get.height * 0.1),
                    Text('${tr('portalAdress')}:',
                        style: TextStyleHelper.body2(color: Get.theme.colors().onSurface)),
                    SizedBox(height: Get.height * 0.01),
                    Text(controller.portalAdress,
                        style: TextStyleHelper.headline6(color: Get.theme.colors().onSurface)),
                    SizedBox(height: Get.height * 0.111),
                    Obx(
                      () => Form(
                        child: Column(
                          children: [
                            AuthTextField(
                              hintText: tr('email'),
                              controller: controller.emailController,
                              autofillHint: AutofillHints.email,
                              hasError: controller.emailFieldError.value,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                FocusScope.of(context).requestFocus(passwordFocusNode);
                              },
                            ),
                            SizedBox(height: Get.height * 0.0444),
                            AuthTextField(
                              hintText: tr('password'),
                              focusNode: passwordFocusNode,
                              controller: controller.passwordController,
                              hasError: controller.passwordFieldError.value,
                              autofillHint: AutofillHints.password,
                              textInputAction: TextInputAction.done,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              onSubmitted: (_) async => await controller.loginByPassword(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.0333),
                    WideButton(
                      text: tr('next'),
                      onPressed: controller.loginByPassword,
                    ),
                    const SizedBox(height: 4),
                    PlatformTextButton(
                      onPressed: () async => Get.to<PasswordRecoveryScreen1>(
                        () => const PasswordRecoveryScreen1(),
                        arguments: {'email': controller.emailController.text},
                      ),
                      child: Text(
                        tr('forgotPassword'),
                        style: TextStyleHelper.subtitle2(
                          color: Get.theme.colors().primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    PrivacyAndTermsFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
