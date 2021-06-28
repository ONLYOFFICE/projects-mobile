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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/login_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/authentication/widgets/auth_text_field.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class LoginView extends StatelessWidget {
  LoginView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<LoginController>();

    return Scaffold(
      appBar: StyledAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.094),
            Text('Portal address:',
                style: TextStyleHelper.body2(
                    color: Theme.of(context).customColors().onSurface)),
            Text(controller.portalAdress,
                style: TextStyleHelper.headline6(
                    color: Theme.of(context).customColors().onSurface)),
            Center(
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Obx(
                        () => Form(
                          child: Column(
                            children: [
                              AuthTextField(
                                hintText: 'Email',
                                controller: controller.emailController,
                                validator: controller.emailValidator,
                                autofillHint: AutofillHints.email,
                                haveError: controller.emailFieldError.isTrue,
                              ),
                              SizedBox(height: Get.height * 0.0444),
                              AuthTextField(
                                hintText: 'Password',
                                controller: controller.passwordController,
                                haveError: controller.passwordFieldError.isTrue,
                                validator: controller.passValidator,
                                autofillHint: AutofillHints.password,
                                obscureText: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.0333),
                      DecoratedBox(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              blurRadius: 3,
                              offset: const Offset(0, 0.85),
                              color: Theme.of(context)
                                  .customColors()
                                  .onBackground
                                  .withOpacity(0.19)),
                          BoxShadow(
                              blurRadius: 3,
                              offset: const Offset(0, 0.25),
                              color: Theme.of(context)
                                  .customColors()
                                  .onBackground
                                  .withOpacity(0.04)),
                        ]),
                        child: WideButton(
                          text: 'NEXT',
                          onPressed: () async =>
                              await controller.loginByPassword(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                          onPressed: () async =>
                              Get.toNamed('PasswordRecoveryScreen'),
                          child: Text(
                            'Forgot password?',
                            style: TextStyleHelper.subtitle2(
                                color:
                                    Theme.of(context).customColors().primary),
                          )),
                      // PasswordForm(),
                      // (controller.capabilities != null)
                      //     ? LoginSources(
                      //         capabilities: controller.capabilities.providers)
                      //     : const SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
