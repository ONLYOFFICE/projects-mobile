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
    var controller = Get.put(LoginController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(
          () => controller.state.value == ViewState.Busy
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: Get.height * 0.165),
                      AppIcon(icon: SvgIcons.logo_big),
                      SizedBox(height: Get.height * 0.044),
                      Text('ONLYOFFICE\nProjects',
                          textAlign: TextAlign.center,
                          style: TextStyleHelper.headline6()),
                      SizedBox(height: Get.height * 0.111),
                      AuthTextField(
                        controller: controller.portalAdressController,
                        hintText: 'Portal address',
                        autofillHint: AutofillHints.url,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            controller.portalFieldIsEmpty.value = false;
                          } else {
                            controller.portalFieldIsEmpty.value = true;
                          }
                        },
                      ),
                      SizedBox(height: Get.height * 0.033),
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
                            text: 'LOG IN',
                            onPressed: controller.portalFieldIsEmpty.isTrue
                                ? null
                                : () async =>
                                    await controller.getPortalCapabilities(),
                            color: controller.portalFieldIsEmpty.isFalse
                                ? Theme.of(context).customColors().primary
                                : Theme.of(context).customColors().surface,
                            textColor: controller.portalFieldIsEmpty.isFalse
                                ? Theme.of(context).customColors().onNavBar
                                : Theme.of(context)
                                    .customColors()
                                    .onSurface
                                    .withOpacity(0.4),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.222),
                      Text(
                        decsription,
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.body2(
                            color: Theme.of(context)
                                .customColors()
                                .onSurface
                                .withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

String decsription =
    'ONLYOFFICE portal provide saving filesin cloud storage, share it with co-workersand co-editing in realtime';
