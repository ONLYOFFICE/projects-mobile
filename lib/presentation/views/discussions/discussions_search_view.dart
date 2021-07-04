import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussion_search_controller.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/discussions/discussion_tile.dart';

class DiscussionsSearchScreen extends StatelessWidget {
  const DiscussionsSearchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(DiscussionSearchController());

    controller.init();

    return Scaffold(
      appBar: StyledAppBar(
        titleText: tr('discussionsSearch'),
        bottom: SearchField(
          autofocus: true,
          onChanged: (value) {
            controller.searchDiscussions(query: value, needToClear: true);
          },
        ),
      ),
      body: Obx(
        () {
          if (controller.loaded.isFalse)
            return const ListLoadingSkeleton();
          else {
            return PaginationListView(
              paginationController: controller.paginationController,
              child: ListView.builder(
                itemCount: controller.paginationController.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return DiscussionTile(
                    discussion: controller.paginationController.data[index],
                    onTap: () => Get.toNamed('DiscussionDetailed', arguments: {
                      'discussion': controller.paginationController.data[index]
                    }),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
