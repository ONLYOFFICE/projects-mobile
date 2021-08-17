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
import 'package:projects/data/enums/user_selection_mode.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/domain/controllers/projects/new_project/users_data_source.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';

class SelectResponsiblesView extends StatelessWidget {
  const SelectResponsiblesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var usersDataSource = Get.find<UsersDataSource>();
    var controller = Get.arguments['controller'];

    controller.setupResponsiblesSelection();

    usersDataSource.selectionMode = UserSelectionMode.Multiple;
    return Scaffold(
      appBar: StyledAppBar(
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr('selectResponsibles')),
              if (controller.responsibles.isNotEmpty)
                Text(plural('usersSelected', controller.responsibles.length),
                    // '${controller.responsibles.length} users selected',
                    style: TextStyleHelper.caption())
            ],
          ),
        ),
        bottom: SearchField(
          hintText: tr('searchUsers'),
          onSubmitted: (value) => usersDataSource.searchUsers(value),
        ),
        backButtonIcon: Get.put(PlatformController()).isMobile
            ? const Icon(Icons.arrow_back_rounded)
            : const Icon(Icons.close),
        onLeadingPressed: controller.leaveResponsiblesSelectionView,
        actions: [
          IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: controller.confirmResponsiblesSelection)
        ],
      ),
      body: Obx(
        () {
          if (usersDataSource.loaded.value == true &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.value == false) {
            return UsersDefault(
              selfUserItem: controller.selfUserItem,
              usersDataSource: usersDataSource,
              onTapFunction: controller.addResponsible,
            );
          }
          if (usersDataSource.nothingFound.value == true) {
            return const NothingFound();
          }
          if (usersDataSource.loaded.value == true &&
              usersDataSource.usersList.isNotEmpty &&
              usersDataSource.isSearchResult.value == true) {
            return UsersSearchResult(
              usersDataSource: usersDataSource,
              onTapFunction: () => controller.addResponsible,
            );
          }
          return const ListLoadingSkeleton();
        },
      ),
    );
  }
}
