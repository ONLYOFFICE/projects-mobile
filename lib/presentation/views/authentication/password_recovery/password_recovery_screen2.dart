import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/authentication/widgets/auth_text_field.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class PasswordRecoveryScreen2 extends StatelessWidget {
  const PasswordRecoveryScreen2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var codeController = MaskedTextController(mask: '000 000');

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: AuthTextField(
                hintText: 'Code',
                controller: codeController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: WideButton(text: 'PROCEED', onPressed: () {}),
            ),
            const SizedBox(height: 2),
            TextButton(onPressed: () {}, child: const Text('Need help?'))
          ],
        ),
      ),
    );
  }
}

const String _text =
    "Enter the 6-digit code generated by the authentificator app.\nIf you don't have access to your phone, you can use backup codes.";
