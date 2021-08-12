import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/authentication/password_recovery/password_recovery_screen1.dart';
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
            Text('${tr('portalAdress')}:',
                style:
                    TextStyleHelper.body2(color: Get.theme.colors().onSurface)),
            Text(controller.portalAdress,
                style: TextStyleHelper.headline6(
                    color: Get.theme.colors().onSurface)),
            Center(
              child: Container(
                color: Get.theme.backgroundColor,
                constraints: const BoxConstraints(maxWidth: 480),
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
                                hintText: tr('email'),
                                controller: controller.emailController,
                                validator: controller.emailValidator,
                                autofillHint: AutofillHints.email,
                                hasError: controller.emailFieldError.value,
                              ),
                              SizedBox(height: Get.height * 0.0444),
                              AuthTextField(
                                hintText: tr('password'),
                                controller: controller.passwordController,
                                hasError: controller.passwordFieldError.value,
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
                              color: Get.theme
                                  .colors()
                                  .onBackground
                                  .withOpacity(0.19)),
                          BoxShadow(
                              blurRadius: 3,
                              offset: const Offset(0, 0.25),
                              color: Get.theme
                                  .colors()
                                  .onBackground
                                  .withOpacity(0.04)),
                        ]),
                        child: WideButton(
                          text: tr('next'),
                          onPressed: () async =>
                              await controller.loginByPassword(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () async => Get.to(
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
