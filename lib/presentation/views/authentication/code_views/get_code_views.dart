import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/internal/constants.dart';
import 'package:projects/internal/utils/adaptive_size.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:launch_review/launch_review.dart';

part 'page_switcher.dart';
part 'steps/step1.dart';
part 'steps/step2.dart';
part 'steps/step3.dart';
part 'steps/step4.dart';

class GetCodeViews extends StatefulWidget {
  const GetCodeViews({Key key}) : super(key: key);

  @override
  _GetCodeViewsState createState() => _GetCodeViewsState();
}

class _GetCodeViewsState extends State<GetCodeViews> {
  ValueNotifier<double> page = ValueNotifier<double>(0);

  final _pageController = PageController(keepPage: true);
  final _platformController = Get.find<PlatformController>();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() => page.value = _pageController.page);
  }

  @override
  Widget build(BuildContext context) {
    // additional padding at the top on tablets
    // ignore: omit_local_variable_types
    double padding = getTopPadding(
        _platformController.isMobile, MediaQuery.of(context).size.height);

    var pages = [
      _Step1(topPadding: padding),
      _Step2(topPadding: padding),
      _Step3(topPadding: padding),
      _Step4(topPadding: padding),
    ];

    return Scaffold(
      appBar: StyledAppBar(
          leading: IconButton(
              icon: const Icon(Icons.close_rounded), onPressed: Get.back)),
      body: SizedBox(
        height: Get.height - MediaQuery.of(context).padding.top - 56,
        child: Stack(
          children: [
            PageView.builder(
              itemCount: pages.length,
              controller: _pageController,
              itemBuilder: (context, index) => pages[index],
            ),
            _PageSwitcher(
              pageController: _pageController,
              page: page,
            ),
          ],
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
