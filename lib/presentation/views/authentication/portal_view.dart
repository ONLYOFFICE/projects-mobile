import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/viewstate.dart';
import 'package:projects/domain/controllers/login_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/views/authentication/widgets/auth_text_field.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class PortalView extends StatelessWidget {
  PortalView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      Get.find<LoginController>().onClose();
    } catch (e) {
      debugPrint(e);
    }
    var controller = Get.put(LoginController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(
          () => controller.state.value == ViewState.Busy
              ? SizedBox(
                  height: Get.height,
                  child: const Center(child: CircularProgressIndicator()))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: Get.height * 0.165),
                      AppIcon(icon: SvgIcons.logo_big),
                      SizedBox(height: Get.height * 0.044),
                      Text(tr('appName'),
                          textAlign: TextAlign.center,
                          style: TextStyleHelper.headline6()),
                      SizedBox(height: Get.height * 0.111),
                      Obx(
                        () => AuthTextField(
                          controller: controller.portalAdressController,
                          autofillHint: AutofillHints.url,
                          hintText: tr('portalAdress'),
                          validator: controller.emailValidator,
                          haveError: controller.portalFieldError.value == true,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.033),
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
                              await controller.getPortalCapabilities(),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.222),
                      Text(
                        tr('appDescription'),
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.body2(
                            color:
                                Get.theme.colors().onSurface.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
