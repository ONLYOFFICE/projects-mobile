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
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/services/remote_config_service.dart';
import 'package:projects/domain/controllers/auth/login_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyAndTermsFooter extends StatelessWidget {
  PrivacyAndTermsFooter({
    Key? key,
  })  : needCheckbox = false,
        super(key: key);

  PrivacyAndTermsFooter.withCheckbox({
    Key? key,
  })  : needCheckbox = true,
        super(key: key);

  final bool needCheckbox;
  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    final needAgreement = controller.needAgreement && needCheckbox;

    final fullText = tr('privacyAndTermsFooter.total');
    final textPrivacyPolicy = tr('privacyAndTermsFooter.privacyPolicyWithLink');
    final textTermsOfService = tr('privacyAndTermsFooter.termsOfServiceWithLink');

    final beforeText = needAgreement
        ? tr('privacyAndTermsAgreement.beforeText')
        : fullText.substring(0, fullText.indexOf(textPrivacyPolicy));
    final betweenText = needAgreement
        ? tr('privacyAndTermsAgreement.betweenText')
        : fullText.substring(fullText.indexOf(textPrivacyPolicy) + textPrivacyPolicy.length,
            fullText.indexOf(textTermsOfService));
    final afterText =
        fullText.substring(fullText.indexOf(textTermsOfService) + textTermsOfService.length);

    final textSpanPrivacyPolicy = TextSpan(
      style: TextStyle(
        decoration: TextDecoration.underline,
        color: Theme.of(context).colors().links,
      ),
      text: textPrivacyPolicy,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          launch(
            RemoteConfigService.getString(RemoteConfigService.Keys.linkPrivacyPolicy),
          );
        },
    );
    final textSpanTermsOfService = TextSpan(
      style: TextStyle(
        decoration: TextDecoration.underline,
        color: Theme.of(context).colors().links,
      ),
      text: textTermsOfService,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          launch(
            RemoteConfigService.getString(RemoteConfigService.Keys.linkTermsOfService),
          );
        },
    );
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 36),
      child: Row(
        children: [
          if (needAgreement)
            Obx(
              () => Checkbox(
                activeColor: Get.theme.colors().primary,
                value: controller.checkBoxValue.value,
                onChanged: (bool? value) {
                  controller.checkBoxValue.value = value ?? false;
                },
              ),
            ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: RichText(
                textAlign: needAgreement ? TextAlign.left : TextAlign.center,
                text: TextSpan(
                  style: TextStyleHelper.body2(
                    color: Get.theme.colors().onSurface.withOpacity(0.6),
                  ),
                  children: [
                    TextSpan(text: beforeText),
                    textSpanPrivacyPolicy,
                    TextSpan(text: betweenText),
                    textSpanTermsOfService,
                    TextSpan(text: afterText),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
