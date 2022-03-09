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

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/account_controller.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/privacy_and_terms_footer.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/views/authentication/widgets/auth_text_field.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class PortalInputView extends StatelessWidget {
  const PortalInputView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      controller
        ..setup()
        ..checkBoxValue.value = false;
    });

    if (Get.isRegistered<AccountManager>()) {
      Get.find<AccountManager>();
    } else {
      Get.put(AccountManager()).setup();
    }

    final height = controller.accountManager.accounts.isEmpty ? Get.height : Get.height - 80;

    return Scaffold(
      appBar: controller.accountManager.accounts.isEmpty
          ? null
          : StyledAppBar(
              backButtonIcon: Platform.isAndroid ? Icon(PlatformIcons(context).clear) : null,
              leading: Platform.isIOS
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: CupertinoNavigationBarBackButton(
                        onPressed: Get.back,
                        previousPageTitle: tr('back').toLowerCase().capitalizeFirst,
                      ),
                    )
                  : null,
              leadingWidth: Platform.isIOS ? 150 : null,
              elevation: Platform.isAndroid ? 1 : 0,
              title: Platform.isAndroid
                  ? Text(
                      tr('addNewAccount'),
                      style: TextStyleHelper.headline6(color: Get.theme.colors().onSurface),
                    )
                  : null,
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              constraints: BoxConstraints(
                  maxWidth: 480, maxHeight: height - MediaQuery.of(context).padding.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  if (controller.accountManager.accounts.isEmpty)
                    SizedBox(height: height * 0.2)
                  else
                    SizedBox(height: height * 0.1),
                  const AppIcon(icon: SvgIcons.app_logo),
                  SizedBox(height: height * 0.01),
                  AppIcon(
                    icon: SvgIcons.app_title,
                    color: Get.theme.colors().onSurface,
                  ),
                  SizedBox(height: height * 0.111),
                  Obx(
                    () => AuthTextField(
                      controller: controller.portalAdressController,
                      autofillHint: AutofillHints.url,
                      hintText: tr('portalAdress'),
                      hasError: controller.portalFieldError.value,
                      keyboardType: TextInputType.url,
                      onSubmitted: (_) => controller.getPortalCapabilities(),
                    ),
                  ),
                  SizedBox(height: height * 0.033),
                  WideButton(
                    text: tr('next'),
                    textColor: controller.needAgreement && !controller.checkBoxValue.value
                        ? Get.theme.colors().onBackground.withOpacity(0.5)
                        : null,
                    color: controller.needAgreement && !controller.checkBoxValue.value
                        ? Get.theme.colors().bgDescription
                        : null,
                    onPressed: controller.getPortalCapabilities,
                  ),
                  if (controller.needAgreement)
                    PrivacyAndTermsFooter.withCheckbox()
                  else
                    const Spacer(),
                  if (controller.needAgreement) const Spacer() else PrivacyAndTermsFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
