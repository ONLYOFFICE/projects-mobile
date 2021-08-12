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
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode/passcode_settings_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';

class PasscodeSettingsScreen extends StatelessWidget {
  const PasscodeSettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PasscodeSettingsController());

    return WillPopScope(
      onWillPop: () async {
        controller.leavePasscodeSettingsScreen();
        // controller.leave();
        return true;
      },
      child: Scaffold(
        appBar: StyledAppBar(
            titleText: tr('passcodeLock'),
            onLeadingPressed: controller.leavePasscodeSettingsScreen,
            backButtonIcon: const Icon(Icons.arrow_back_rounded)

            // onLeadingPressed: controller.leave,
            ),
        body: Obx(
          () {
            if (controller.loaded.value == true) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Obx(
                      () => SwitchListTile(
                        value: controller.isPasscodeEnable.value,
                        onChanged: (value) async =>
                            controller.onPasscodeTilePressed(value),
                        // controller.tryEnablingPasscode(),
                        title: Text(
                          tr('enablePasscode'),
                          style: TextStyleHelper.projectTitle,
                        ),
                      ),
                    ),
                    if (controller.isPasscodeEnable == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: TextButton(
                          onPressed: controller.tryChangingPasscode,
                          child: Text(
                            tr('changePasscode'),
                            style: TextStyleHelper.projectTitle
                                .copyWith(color: Get.theme.colors().primary),
                          ),
                        ),
                      ),
                    const StyledDivider(leftPadding: 16, rightPadding: 16),
                    const SizedBox(height: 17),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 12),
                      child: RichText(
                        text: TextSpan(
                          text: tr('passcodeLock'),
                          style: TextStyleHelper.caption().copyWith(
                            color: Get.theme.colors().onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: " - ${tr('passcodeLockDescription')}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (controller.isFingerprintAvailable.value == true &&
                        controller.isPasscodeEnable.value == true)
                      SwitchListTile(
                        value: controller.isFingerprintEnable.value,
                        onChanged: controller.toggleFingerprintStatus,
                        title: Text(
                          tr('fingerprint'),
                          style: TextStyleHelper.projectTitle,
                        ),
                      ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
