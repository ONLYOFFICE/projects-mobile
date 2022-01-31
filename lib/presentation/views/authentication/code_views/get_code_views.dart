/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
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
import 'package:launch_review/launch_review.dart';

part 'page_switcher.dart';
part 'steps/step1.dart';
part 'steps/step2.dart';
part 'steps/step3.dart';
part 'steps/step4.dart';

class GetCodeViews extends StatefulWidget {
  const GetCodeViews({Key? key}) : super(key: key);

  @override
  _GetCodeViewsState createState() => _GetCodeViewsState();
}

class _GetCodeViewsState extends State<GetCodeViews> {
  ValueNotifier<double> page = ValueNotifier<double>(0);

  final _pageController = PageController();
  final _platformController = Get.find<PlatformController>();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() => page.value = _pageController.page ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    // additional padding at the top on tablets
    // ignore: omit_local_variable_types
    final double padding =
        getTopPadding(_platformController.isMobile, MediaQuery.of(context).size.height);

    final pages = [
      _Step1(topPadding: padding),
      _Step2(topPadding: padding),
      _Step3(topPadding: padding),
      _Step4(topPadding: padding),
    ];

    return Scaffold(
      appBar: StyledAppBar(
          leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: Get.back)),
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

TextStyle _stepStyle(BuildContext context) =>
    TextStyleHelper.headline6(color: Get.theme.colors().onSurface);

TextStyle _setup1Style(BuildContext context) =>
    TextStyleHelper.subtitle1(color: Get.theme.colors().onSurface);

TextStyle _setup2Style(BuildContext context) =>
    TextStyleHelper.body2(color: Get.theme.colors().onSurface.withOpacity(0.6));
