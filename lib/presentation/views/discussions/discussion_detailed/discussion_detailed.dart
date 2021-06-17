import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_comments_view.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_overview.dart';
import 'package:projects/presentation/views/discussions/discussion_detailed/discussion_subscribers_view.dart';
import 'package:projects/presentation/views/task_detailed/task_detailed_view.dart';

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
          bottom: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 40,
              child: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  indicatorColor: Theme.of(context).customColors().primary,
                  labelColor: Theme.of(context).customColors().onSurface,
                  unselectedLabelColor: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.6),
                  labelStyle: TextStyleHelper.subtitle2(),
                  tabs: [
                    CustomTab(
                        title: 'Comments',
                        currentTab: _activeIndex == 1,
                        count: controller.discussion.value.commentsCount),
                    CustomTab(
                        title: 'Subscribers',
                        currentTab: _activeIndex == 2,
                        count:
                            controller?.discussion?.value?.subscribers?.length),
                    // CustomTab(
                    //     title: 'Overview',
                    //     currentTab: _activeIndex == 3,
                    //     count: 1),
                    const Tab(text: 'Overview'),
                    const Tab(text: 'Overview'),
                  ]),
            ),
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          DiscussionCommentsView(controller: controller),
          DiscussionSubscribersView(controller: controller),
          DiscussionOverview(controller: controller),
          Container(color: Colors.blue),
        ]),
      ),
    );
  }
}
