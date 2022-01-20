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
import 'package:projects/domain/controllers/base/base_filter_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_filter_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/filters/confirm_filters_button.dart';
import 'package:projects/presentation/shared/widgets/filters/filters_row.dart';
import 'package:projects/presentation/shared/widgets/filters/filter_element_widget.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/select_project_screen.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/select_tag_screen.dart';
import 'package:projects/presentation/shared/widgets/select_item_screens/users/select_user_screen.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_date_range_picker.dart';
import 'package:projects/presentation/shared/wrappers/platform_icons.dart';
import 'package:projects/presentation/shared/wrappers/platform_text_button.dart';

part 'filters/author.dart';
part 'filters/status.dart';
part 'filters/creation_date.dart';
part 'filters/project.dart';
part 'filters/other.dart';

class DiscussionsFilterScreen extends StatelessWidget {
  const DiscussionsFilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterController = Get.arguments['filterController'] as BaseFilterController;

    final platformController = Get.find<PlatformController>();

    return Scaffold(
      backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
      appBar: StyledAppBar(
        onLeadingPressed: () {
          filterController.restoreFilters();
          Get.back();
        },
        titleText: tr('filter'),
        showBackButton: true,
        backgroundColor: platformController.isMobile ? null : Get.theme.colors().surface,
        backButtonIcon: Get.put(PlatformController()).isMobile
            ? Icon(PlatformIcons(context).back)
            : Icon(PlatformIcons(context).clear),
        actions: [
          PlatformTextButton(
              onPressed: () async => filterController.resetFilters(),
              child: Text(tr('reset'),
                  style: TextStyleHelper.button(color: Get.theme.colors().systemBlue))),
          SizedBox(width: platformController.isMobile ? 8 : 12),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12.5),
                  _Author(filterController: filterController as DiscussionsFilterController),
                  _Status(filterController: filterController),
                  _CreatingDate(filterController: filterController),
                  if (filterController.projectId == null)
                    _Project(filterController: filterController),
                  _Other(filterController: filterController),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
          Obx(() {
            if (filterController.suitableResultCount.value != -1)
              return ConfirmFiltersButton(filterController: filterController);
            return const SizedBox();
          }),
        ],
      ),
    );
  }
}
