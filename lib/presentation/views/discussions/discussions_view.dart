import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/filters_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_floating_action_button.dart';
import 'package:projects/presentation/views/discussions/discussion_tile.dart';
import 'package:projects/presentation/views/discussions/widgets/discussions_header.dart';

class PortalDiscussionsView extends StatelessWidget {
  const PortalDiscussionsView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<DiscussionsController>();

    controller.loadDiscussions();

    return Obx(
      () => Scaffold(
          appBar: StyledAppBar(
            titleHeight: 101,
            bottomHeight: 0,
            showBackButton: false,
            titleText: tr('discussions'),
            elevation: controller.needToShowDivider.isTrue ? 1 : 0,
            actions: [
              IconButton(
                icon: AppIcon(
                  width: 24,
                  height: 24,
                  icon: SvgIcons.search,
                  color: Get.theme.colors().primary,
                ),
                onPressed: controller.showSearch,
                // onPressed: () => controller.showSearch(),
              ),
              IconButton(
                icon: FiltersButton(controler: controller),
                onPressed: () async => Get.toNamed(
                  'DiscussionsFilterScreen',
                  preventDuplicates: false,
                  arguments: {'filterController': controller.filterController},
                ),
              ),
              const SizedBox(width: 3),
            ],
            bottom: DiscussionsHeader(),
          ),
          floatingActionButton: StyledFloatingActionButton(
            onPressed: controller.toNewDiscussionScreen,
            child: AppIcon(icon: SvgIcons.add_discussion),
          ),
          body: DiscussionsList(controller: controller)),
    );
  }
}

class DiscussionsList extends StatelessWidget {
  final controller;
  const DiscussionsList({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loaded == false) {
        return const ListLoadingSkeleton();
      } else {
        return PaginationListView(
          paginationController: controller.paginationController,
          child: ListView.separated(
            itemCount: controller.paginationController.data.length,
            padding: const EdgeInsets.only(bottom: 65),
            controller: controller.scrollController,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 12);
            },
            itemBuilder: (BuildContext context, int index) {
              return DiscussionTile(
                discussion: controller.paginationController.data[index],
                onTap: () => controller
                    .toDetailed(controller.paginationController.data[index]),
              );
            },
          ),
        );
      }
    });
  }
}
