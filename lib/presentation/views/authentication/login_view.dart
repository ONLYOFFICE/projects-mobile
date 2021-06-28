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
