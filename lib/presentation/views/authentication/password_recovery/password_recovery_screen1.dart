import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/password_recovery_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
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
    );
  }
}
