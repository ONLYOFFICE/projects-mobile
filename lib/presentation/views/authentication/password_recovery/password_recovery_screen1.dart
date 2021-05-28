import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/authentication/widgets/auth_text_field.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class PasswordRecoveryScreen1 extends StatelessWidget {
  const PasswordRecoveryScreen1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyledAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.71),
            AppIcon(icon: SvgIcons.password_recovery),
            const SizedBox(height: 6.71),
            Text(
              'Password recovery',
              style: TextStyleHelper.headline6(),
            ),
            const SizedBox(height: 17.71),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _text,
                textAlign: TextAlign.center,
                style: TextStyleHelper.subtitle1(),
              ),
            ),
            const SizedBox(height: 76),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: AuthTextField(
                autofillHint: AutofillHints.email,
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: WideButton(
                  text: 'CONFIRM',
                  onPressed: () => Get.toNamed('PasswordRecoveryScreen2')),
            ),
          ],
        ),
      ),
    );
  }
}

const String _text =
    'Please enter the email address you provided when registering on the portal. ';
