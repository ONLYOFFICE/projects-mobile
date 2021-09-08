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
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/internal/constants.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_snackbar.dart';
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
