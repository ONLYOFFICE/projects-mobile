// ignore_for_file: file_names

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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/2fa_sms_controller.dart';
import 'package:projects/internal/utils/adaptive_size.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/authentication/2fa_sms/select_country_screen.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class TFASmsScreen extends StatelessWidget {
  const TFASmsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final login = Get.arguments['login'] as String;
    final password = Get.arguments['password'] as String;

    final controller = Get.put(TFASmsController());
    controller.initLoginAndPass(login, password);

    return Scaffold(
      appBar: StyledAppBar(),
      body: Obx(
        () {
          if (controller.loaded.value == true) {
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  //color: Theme.of(context).backgroundColor,
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    children: [
                      SizedBox(height: h(24.71)),
                      AppIcon(
                        icon: SvgIcons.password_recovery,
                        color: Theme.of(context).colors().onBackground,
                      ),
                      SizedBox(height: h(11.54)),
                      Text(tr('tfaSMSTitle'),
                          style: TextStyleHelper.subtitle1(
                              color: Theme.of(context).colors().onSurface)),
                      SizedBox(height: h(12.54)),
                      Text(tr('tfaSMSCaption'),
                          textAlign: TextAlign.center,
                          style: TextStyleHelper.body2(
                              color: Theme.of(context).colors().onSurface.withOpacity(0.6))),
                      SizedBox(height: h(6.54)),
                      const _CountrySelection(),
                      SizedBox(height: h(24)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: WideButton(
                          text: tr('sendCode'),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          onPressed: controller.onSendCodePressed,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(child: PlatformCircularProgressIndicator());
        },
      ),
    );
  }
}

class _CountrySelection extends StatelessWidget {
  const _CountrySelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TFASmsController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: PlatformTextButton(
              onPressed: () => Get.to(const SelectCountryScreen()),
              child: Obx(
                () => Text(
                  controller.deviceCountry.value?.countryName ?? tr('chooseCountry'),
                  style: TextStyleHelper.subtitle1(color: Theme.of(context).colors().primary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Divider(height: 1, thickness: 1),
          Obx(
            () => Row(
              children: [
                Flexible(
                  flex: 1,
                  child: PlatformTextField(
                    makeCupertinoDecorationNull: true,
                    controller: controller.phoneCodeController,
                    autofocus: false,
                    cupertino: (_, __) => CupertinoTextFieldData(
                      padding: const EdgeInsets.only(bottom: 12, top: 16, left: 12, right: 5),
                      prefix: Text(
                        '+',
                        style: TextStyleHelper.subtitle1(),
                      ),
                    ),
                    material: (_, __) => MaterialTextFieldData(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(bottom: 12, top: 16, left: 12, right: 5),
                        prefixIconConstraints: const BoxConstraints(minWidth: 10, minHeight: 0),
                        prefixIcon: Text(
                          '+',
                          style: TextStyleHelper.subtitle1(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  flex: 4,
                  child: PlatformTextField(
                    makeCupertinoDecorationNull: true,
                    autofocus: true,
                    controller: controller.phoneNumberController,
                    keyboardType: TextInputType.number,
                    hintText: controller.numberHint,
                    cupertino: (_, __) => CupertinoTextFieldData(
                      padding: const EdgeInsets.only(bottom: 12, top: 16, left: 12, right: 5),
                    ),
                    material: (_, __) => MaterialTextFieldData(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 12, top: 16, left: 12, right: 5),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
