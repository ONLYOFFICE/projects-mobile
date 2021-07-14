import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/custom_tab.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_comments_view.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_overview.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_subscribers_view.dart';
import 'package:projects/presentation/views/discussions/widgets/app_bar_menu_button.dart';
import 'package:projects/presentation/views/documents/entity_documents_view.dart';

class DiscussionDetailed extends StatefulWidget {
  DiscussionDetailed({Key key}) : super(key: key);

  @override
  _DiscussionDetailedState createState() => _DiscussionDetailedState();
}

class _DiscussionDetailedState extends State<DiscussionDetailed>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activeIndex = 0;
  DiscussionItemController controller;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4);
    var discussion = Get.arguments['discussion'];
    controller = Get.put(DiscussionItemController(discussion));
    controller.getDiscussionDetailed();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _activeIndex = _tabController.index;
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
                      count: controller.discussion.value.commentsCount),
                  CustomTab(
                      title: tr('subscribers'),
                      currentTab: _activeIndex == 2,
                      count:
                          controller?.discussion?.value?.subscribers?.length),
                  CustomTab(
                      title: tr('documents'),
                      currentTab: _activeIndex == 3,
                      count: controller?.discussion?.value?.files?.length),
                  Tab(text: tr('overview')),
                ]),
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          DiscussionCommentsView(controller: controller),
          DiscussionSubscribersView(controller: controller),
          DiscussionsDocumentsView(files: controller?.discussion?.value?.files),
          DiscussionOverview(controller: controller),
        ]),
      ),
    );
  }
}
