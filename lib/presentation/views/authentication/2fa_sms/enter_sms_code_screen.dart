import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/2fa_sms_controller.dart';
import 'package:projects/internal/utils/adaptive_size.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class EnterSMSCodeScreen extends StatelessWidget {
  const EnterSMSCodeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var text = 'Enter the 6-digit code we sent to ';
    TFASmsController controller;

    try {
      controller = Get.find<TFASmsController>();
    } catch (e) {
      controller = Get.put(TFASmsController());
      String phoneNoise = Get.arguments['phoneNoise'];
      var login = Get.arguments['login'];
      var password = Get.arguments['password'];
      controller.initLoginAndPass(login, password);
      controller.setPhoneNoise(phoneNoise);
    }
    var codeController = MaskedTextController(mask: '*** ***');

    return Scaffold(
      appBar: StyledAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h(24.71)),
              AppIcon(icon: SvgIcons.password_recovery),
              SizedBox(height: h(20.74)),
              Text(text,
                  style: TextStyleHelper.subtitle1(
                      color: Theme.of(context).customColors().onSurface)),
              Text(controller.phoneNoise,
                  style: TextStyleHelper.subtitle1(
                          color: Theme.of(context).customColors().onSurface)
                      .copyWith(fontWeight: FontWeight.w500)),
              SizedBox(height: h(100)),
              Obx(
                () => TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.subtitle1(),
                  obscureText: true,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: controller.codeError.isTrue
                            ? Theme.of(context).customColors().error
                            : Theme.of(context)
                                .customColors()
                                .onSurface
                                .withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: controller.codeError.isTrue
                            ? Theme.of(context).customColors().error
                            : Theme.of(context)
                                .customColors()
                                .onSurface
                                .withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => SizedBox(
                  height: h(24),
                  child: controller.codeError.isTrue
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Incorrect code, please try again.',
                            style: TextStyleHelper.caption(
                                color: Theme.of(context).customColors().error),
                          ),
                        )
                      : null,
                ),
              ),
              WideButton(
                text: 'CONFIRM',
                padding: const EdgeInsets.symmetric(vertical: 12),
                onPressed: () {
                  print(codeController.text);
                  controller.onConfirmPressed(codeController.text);
                },
              ),
              TextButton(
                onPressed: controller.resendSms,
                child: const Text('Request new code'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
