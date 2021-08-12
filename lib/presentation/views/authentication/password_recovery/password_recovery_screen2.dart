import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/password_recovery_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class PasswordRecoveryScreen2 extends StatelessWidget {
  const PasswordRecoveryScreen2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PasswordRecoveryController>();

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
                    tr('passwordChangeInstructionHasBeenSend',
                        args: [controller.emailController.text]),
                    textAlign: TextAlign.center,
                    style: TextStyleHelper.subtitle1(),
                  ),
                ),
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: WideButton(
                    text: tr('backToLogIn'),
                    onPressed: controller.backToLogin,
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
