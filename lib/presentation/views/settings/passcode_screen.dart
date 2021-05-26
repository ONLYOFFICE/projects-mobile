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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/passcode_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class PasscodeScreen extends StatelessWidget {
  const PasscodeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PasscodeController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 62),
              Text('Enter passcode',
                  style: TextStyleHelper.headline6(
                      color: Theme.of(context).customColors().onBackground)),
              const SizedBox(height: 16),
              Text('Choose passcode to unlock app',
                  style: TextStyleHelper.subtitle1(
                      color: Theme.of(context).customColors().onBackground)),
              const SizedBox(height: 36),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 4; i++)
                      Container(
                        height: 16,
                        width: 16,
                        margin: i != 0 ? const EdgeInsets.only(left: 32) : null,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.passcodeLen >= i + 1
                              ? Theme.of(context).customColors().onBackground
                              : Theme.of(context)
                                  .customColors()
                                  .onBackground
                                  .withOpacity(0.4),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 140),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _PasscodeNumber(number: 1),
                  const SizedBox(width: 20),
                  const _PasscodeNumber(number: 2),
                  const SizedBox(width: 20),
                  const _PasscodeNumber(number: 3),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _PasscodeNumber(number: 4),
                  const SizedBox(width: 20),
                  const _PasscodeNumber(number: 5),
                  const SizedBox(width: 20),
                  const _PasscodeNumber(number: 6),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _PasscodeNumber(number: 7),
                  const SizedBox(width: 20),
                  const _PasscodeNumber(number: 8),
                  const SizedBox(width: 20),
                  const _PasscodeNumber(number: 9),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 59),
                  const _PasscodeNumber(number: 0),
                  IconButton(
                      icon: AppIcon(icon: SvgIcons.delete_number),
                      onPressed: () => controller.deleteNumber())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasscodeNumber extends StatelessWidget {
  final int number;
  // final PasscodeController controller;

  const _PasscodeNumber({
    Key key,
    this.number,
    // this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PasscodeController>();

    return TextButton(
      onPressed: () {
        controller.addNumberToPasscode(number);
        print(controller.passcodeLen);
      },
      child: Text(
        number.toString(),
        style: TextStyleHelper.headline3(
            color: Theme.of(context).customColors().onBackground),
      ),
    );
  }
}
