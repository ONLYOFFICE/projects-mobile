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
import 'package:projects/domain/controllers/detailed_task_controller.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/views/task_detailed/detailed_task_app_bar.dart';
import 'package:projects/presentation/views/task_detailed/overview/overview_screen.dart';

class TaskDetailedView extends StatelessWidget {

  const TaskDetailedView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(DetailedTaskController());
    controller.getTask(int.parse(Get.parameters['taskID']));

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: DetailedTaskAppBar(
          bottom: SizedBox(
            height: 25,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TabBar(
                isScrollable: true,
                indicatorColor: Theme.of(context).customColors().onPrimary,
                labelColor: Theme.of(context).customColors().onPrimary,
                unselectedLabelColor: 
                    Theme.of(context).customColors().onPrimary.withOpacity(0.6),
                labelStyle: TextStyleHelper.subtitle2,
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Subtasks'),
                  Tab(text: 'Documents'),
                  Tab(text: 'Related Tasks'),
                  Tab(text: 'Comments'),
                  Tab(text: 'Gantt Chart'),
                ]
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            for (var i = 0; i < 6; i++)
              OverviewScreen()
          ]
        ),
      ),
    );
  }
}
