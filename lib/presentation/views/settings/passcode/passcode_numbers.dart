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
import 'package:projects/domain/controllers/passcode/passcode_settings_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class PasscodeNumber extends StatelessWidget {
  final int number;
  final Function(int number) onPressed;
  final PasscodeSettingsController controller;

  const PasscodeNumber({
    Key key,
    @required this.number,
    @required this.onPressed,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onPressed(number),
      iconSize: 60,
      icon: Text(
        number.toString(),
        style: TextStyleHelper.headline3(
          color: Theme.of(context).customColors().onBackground,
        ).copyWith(height: 1),
      ),
    );
  }
}

class PasscodeNumbersRow extends StatelessWidget {
  final List<int> numbers;
  final Function(int number) onPressed;
  const PasscodeNumbersRow({
    Key key,
    @required this.numbers,
    @required this.onPressed,
  })  : assert(numbers.length == 3),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PasscodeNumber(
          number: numbers[0],
          onPressed: (number) => onPressed(numbers[0]),
        ),
        const SizedBox(width: 30),
        PasscodeNumber(
          number: numbers[1],
          onPressed: (number) => onPressed(numbers[1]),
        ),
        const SizedBox(width: 30),
        PasscodeNumber(
          number: numbers[2],
          onPressed: (number) => onPressed(numbers[2]),
        ),
      ],
    );
  }
}
