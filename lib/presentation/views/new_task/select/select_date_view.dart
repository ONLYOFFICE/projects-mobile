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
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

class SelectDateView extends StatelessWidget {
  const SelectDateView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments ?? Get.arguments;
    final controller = args['controller'];
    final startDate = args['startDate'] as bool;
    final initialDate = args['initialDate'] as DateTime?;
    final previousPage = args['previousPage'] as String?;

    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
      appBar: StyledAppBar(
        backgroundColor: platformController.isMobile ? null : Theme.of(context).colors().surface,
        titleText: startDate ? tr('selectStartDate') : tr('selectDueDate'),
        previousPageTitle: previousPage,
      ),
      body: CalendarDatePicker(
          initialDate: initialDate ?? DateTime.now(),
          currentDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(3000),
          onDateChanged: (value) {
            startDate ? controller.changeStartDate(value) : controller.changeDueDate(value);
          }),
      // ),
    );
  }
}
