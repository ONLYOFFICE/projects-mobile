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

    var emailController = TextEditingController();
    var passController = TextEditingController();

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
                      Form(
                        child: Column(
                          children: [
                            AuthTextField(
                              controller: emailController,
                              hintText: 'Email',
                              autofillHint: AutofillHints.email,
                            ),
                            SizedBox(height: Get.height * 0.0444),
                            AuthTextField(
                              controller: passController,
                              hintText: 'Password',
                              autofillHint: AutofillHints.password,
                              obscureText: true,
                            ),
                          ],
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
                        child: Obx(
                          // ignore: deprecated_member_use
                          () => WideButton(
                            text: 'NEXT',
                            onPressed: controller.portalFieldIsEmpty.isTrue
                                ? null
                                : () async => await controller.loginByPassword(
                                    emailController.text, passController.text),
                          ),
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
