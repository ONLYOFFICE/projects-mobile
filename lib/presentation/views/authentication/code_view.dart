import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class CodeView extends StatefulWidget {
  CodeView({Key key}) : super(key: key);

  @override
  _CodeViewState createState() => _CodeViewState();
}

class _CodeViewState extends State<CodeView> {
  var controller;

  var codeController;

  @override
  void initState() {
    controller = Get.find<LoginController>();
    codeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          appBar: StyledAppBar(),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                color: Get.theme.backgroundColor,
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    AppIcon(
                      icon: PngIcons.code_light,
                      isPng: true,
                      height: 200,
                      width: 200,
                    ),
                    SizedBox(height: Get.height * 0.0347),
                    Text(tr('tfaTitle'),
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.headline5(
                            color: Get.theme.colors().onSurface)),
                    SizedBox(height: Get.height * 0.0222),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        tr('tfaGAcodeDescription'),
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.body2(
                            color:
                                Get.theme.colors().onSurface.withOpacity(0.6)),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.0333),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: TextField(
                        controller: codeController,
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.subtitle1(),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.055),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: WideButton(
                        text: tr('confirm'),
                        onPressed: () async =>
                            await controller.sendCode(codeController.text),
                      ),
                    ),
                    // Center(
                    //   child: Container(
                    //     color: Get.theme.backgroundColor,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(36.0),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: <Widget>[
                    //           const SizedBox(height: 10.0),
                    // CodeForm()
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
