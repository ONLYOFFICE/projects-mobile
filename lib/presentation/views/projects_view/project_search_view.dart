import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/project_search_controller.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/projects_view/new_project/project_manager_view.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';
import 'package:projects/presentation/shared/widgets/bottomless_appbar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectSearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProjectSearchController());
    controller.clearSearch();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: BottomlessAppBar(
        title: SearchHeader(controller: controller),
      ),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (controller.loaded.isFalse) ListLoadingSkeleton(),
            if (controller.nothingFound.isTrue) NothingFound(),
            if (controller.loaded.isTrue && controller.searchResult.isNotEmpty)
              Expanded(
                child: SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: controller.searchResult.length >= 25,
                  controller: controller.refreshController,
                  onLoading: controller.onLoading,
                  child: ListView.builder(
                    itemBuilder: (c, i) =>
                        ProjectCell(item: controller.searchResult[i]),
                    itemExtent: 100.0,
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

class SearchHeader extends StatelessWidget {
  const SearchHeader({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final ProjectSearchController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        child: Material(
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  controller: controller.searchInputController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter your query',
                  ),
                  onSubmitted: (value) {
                    controller.newSearch(value);
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  controller.clearSearch();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
