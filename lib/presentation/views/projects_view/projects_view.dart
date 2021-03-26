import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';

import 'package:projects/presentation/shared/widgets/header_widget.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProjectsController());
    controller.setupProjects();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeaderWidget(controller: controller),
            if (controller.loaded.isFalse) ListLoadingSkeleton(),
            if (controller.loaded.isTrue)
              Expanded(
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: controller.pullUpEnabled,
                  controller: controller.refreshController,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading,
                  child: ListView.builder(
                    itemBuilder: (c, i) =>
                        ProjectCell(item: controller.projects[i]),
                    itemExtent: 100.0,
                    itemCount: controller.projects.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
