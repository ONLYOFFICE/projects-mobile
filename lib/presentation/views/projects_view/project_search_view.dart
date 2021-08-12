import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/project_search_controller.dart';
import 'package:projects/presentation/shared/widgets/custom_searchbar.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectSearchView extends StatelessWidget {
  ProjectSearchView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProjectSearchController());
    controller.clearSearch();
    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      appBar: StyledAppBar(
        title: CustomSearchBar(controller: controller),
      ),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (controller.loaded.value == false) const ListLoadingSkeleton(),
            if (controller.nothingFound.value == true) const NothingFound(),
            if (controller.loaded.value == true &&
                controller.searchResult.isNotEmpty)
              Expanded(
                child: SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: controller.searchResult.length >= 25,
                  controller: controller.refreshController,
                  onLoading: controller.onLoading,
                  child: ListView.builder(
                    itemBuilder: (c, i) =>
                        ProjectCell(item: controller.searchResult[i]),
                    itemCount: controller.searchResult.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
