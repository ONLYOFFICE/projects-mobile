import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:only_office_mobile/domain/controllers/projects_controller.dart';

import 'package:only_office_mobile/presentation/shared/app_colors.dart';
import 'package:only_office_mobile/presentation/shared/widgets/header_widget.dart';
import 'package:only_office_mobile/presentation/views/projects_view/project_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProjectsController controller = Get.put(ProjectsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWidget(),
          Expanded(
            child: Obx(() => SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  controller: controller.refreshController,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading,
                  child: ListView.builder(
                    itemBuilder: (c, i) =>
                        ProjectItem(project: controller.projects[i]),
                    itemExtent: 100.0,
                    itemCount: controller.projects.length,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
