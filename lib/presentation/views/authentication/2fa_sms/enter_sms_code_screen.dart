import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/2fa_sms_controller.dart';
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
          child: Center(
            child: Container(
              color: Get.theme.backgroundColor,
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: h(24.71)),
                  AppIcon(icon: SvgIcons.password_recovery),
                  SizedBox(height: h(20.74)),
                  Text(tr('enterSendedCode'),
                      style: TextStyleHelper.subtitle1(
                          color: Get.theme.colors().onSurface)),
                  Text(controller.phoneNoise,
                      style: TextStyleHelper.subtitle1(
                              color: Get.theme.colors().onSurface)
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
                            color: controller.codeError.value == true
                                ? Get.theme.colors().colorError
                                : Get.theme.colors().onSurface.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: controller.codeError.value == true
                                ? Get.theme.colors().colorError
                                : Get.theme.colors().onSurface.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      height: h(24),
                      child: controller.codeError.value == true
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                tr('incorrectCode'),
                                style: TextStyleHelper.caption(
                                    color: Get.theme.colors().colorError),
                              ),
                            )
                          : null,
                    ),
                  ),
                  WideButton(
                    text: tr('confirm'),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    onPressed: () {
                      print(codeController.text);
                      controller.onConfirmPressed(codeController.text);
                    },
                  ),
                  TextButton(
                    onPressed: controller.resendSms,
                    child: Text(tr('requestNewCode')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
