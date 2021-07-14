import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/login_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';
import 'package:projects/presentation/shared/widgets/styled_snackbar.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:launch_review/launch_review.dart';

part 'page_switcher.dart';
part 'steps/step1.dart';
part 'steps/step2.dart';
part 'steps/step3.dart';
part 'steps/step4.dart';

class GetCodeViews extends StatelessWidget {
  const GetCodeViews({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pageController = PageController();
    const pages = [
      _Step1(),
      _Step2(),
      _Step3(),
      _Step4(),
    ];

    return Scaffold(
      appBar: StyledAppBar(
          leading: IconButton(
              icon: const Icon(Icons.close_rounded), onPressed: Get.back)),
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height - MediaQuery.of(context).padding.top - 56,
          child: Stack(
            children: [
              PageView.builder(
                itemCount: 4,
                controller: pageController,
                itemBuilder: (context, index) {
                  return pages[index];
                },
              ),
              _PageSwitcher(pageController: pageController),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle _stepStyle(context) =>
    TextStyleHelper.headline6(color: Get.theme.colors().onSurface);

TextStyle _setup1Style(context) =>
    TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface);

TextStyle _setup2Style(context) =>
    TextStyleHelper.body2(color: Get.theme.colors().onSurface.withOpacity(0.6));
