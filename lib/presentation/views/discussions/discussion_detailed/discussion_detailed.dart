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
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_tab.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_comments_view.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_overview.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_subscribers_view.dart';
import 'package:projects/presentation/views/discussions/widgets/app_bar_menu_button.dart';
import 'package:projects/presentation/views/documents/entity_documents_view.dart';

class DiscussionDetailed extends StatefulWidget {
  DiscussionDetailed({Key? key}) : super(key: key);

  @override
  _DiscussionDetailedState createState() => _DiscussionDetailedState();
}

class _DiscussionDetailedState extends State<DiscussionDetailed>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _activeIndex = 0;
  DiscussionItemController? controller;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4);
    var discussion = Get.arguments['discussion'];
    controller = Get.put(DiscussionItemController(discussion));
    controller!.getDiscussionDetailed();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        setState(() {
          _activeIndex = _tabController!.index;
        });
      }
    });
    return Obx(
      () => Scaffold(
        appBar: StyledAppBar(
          actions: [AppBarMenuButton(controller: controller)],
          bottom: SizedBox(
            height: 40,
            child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicatorColor: Get.theme.colors().primary,
                labelColor: Get.theme.colors().onSurface,
                unselectedLabelColor:
                    Get.theme.colors().onSurface.withOpacity(0.6),
                labelStyle: TextStyleHelper.subtitle2(),
                tabs: [
                  CustomTab(
                      title: tr('comments'),
                      currentTab: _activeIndex == 1,
                      count: controller!.discussion.value.commentsCount),
                  CustomTab(
                      title: tr('subscribers'),
                      currentTab: _activeIndex == 2,
                      count:
                          controller?.discussion.value.subscribers?.length),
                  CustomTab(
                      title: tr('documents'),
                      currentTab: _activeIndex == 3,
                      count: controller?.discussion.value.files?.length),
                  Tab(text: tr('overview')),
                ]),
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          DiscussionCommentsView(controller: controller),
          DiscussionSubscribersView(controller: controller),
          DiscussionsDocumentsView(files: controller?.discussion.value.files),
          DiscussionOverview(controller: controller),
        ]),
      ),
    );
  }
}
