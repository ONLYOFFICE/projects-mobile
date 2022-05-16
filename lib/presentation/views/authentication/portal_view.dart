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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/auth/account_controller.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/internal/utils/text_utils.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/privacy_and_terms_footer.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/authentication/widgets/auth_text_field.dart';
import 'package:projects/presentation/views/authentication/widgets/wide_button.dart';

class PortalInputView extends StatelessWidget {
  PortalInputView({Key? key}) : super(key: key) {
    if (Get.isRegistered<AccountManager>()) {
      Get.find<AccountManager>();
    } else {
      Get.put(AccountManager()).setup();
    }

    controller.setup();
  }

  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      controller.checkBoxValue.value = false;
    });

    final height = controller.accountManager.accounts.isEmpty ? Get.height : Get.height - 80;

    return Scaffold(
      appBar: controller.accountManager.accounts.isEmpty
          ? null
          : StyledAppBar(
              leading: PlatformWidget(
                cupertino: (_, __) => CupertinoButton(
                  padding: const EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  onPressed: Get.back,
                  child: Text(
                    tr('cancel').toLowerCase().capitalizeFirst!,
                    style: TextStyleHelper.button(),
                  ),
                ),
                material: (_, __) => IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.close),
                ),
              ),
              titleWidth: TextUtils.getTextWidth(tr('addNewAccount'),
                  TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface)),
              elevation: 1,
              title: Text(
                tr('addNewAccount'),
                style: TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface),
              ),
              titleHeight: Platform.isIOS ? 50 : 56,
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              constraints: BoxConstraints(
                maxWidth: 480,
                maxHeight: height -
                    MediaQuery.of(context).padding.bottom -
                    MediaQuery.of(context).padding.top,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const Spacer(flex: 2),
                  const AppIcon(icon: SvgIcons.app_logo),
                  const SizedBox(height: 10),
                  AppIcon(
                    icon: SvgIcons.app_title,
                    color: Theme.of(context).colors().onSurface,
                  ),
                  const Spacer(),
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
                  const SizedBox(height: 26),
                  Obx(() {
                    final checkboxValue = controller.checkBoxValue.value;
                    return WideButton(
                      text: tr('next'),
                      textColor: controller.needAgreement && !checkboxValue
                          ? Theme.of(context).colors().onBackground.withOpacity(0.5)
                          : null,
                      color: controller.needAgreement && !checkboxValue
                          ? Theme.of(context).colors().bgDescription
                          : null,
                      onPressed: controller.getPortalCapabilities,
                    );
                  }),
                  if (controller.needAgreement)
                    PrivacyAndTermsFooter.withCheckbox()
                  else
                    const Spacer(flex: 3),
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
