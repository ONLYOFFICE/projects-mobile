import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects_controller.dart';

import 'package:projects/presentation/shared/app_colors.dart';
import 'package:projects/presentation/shared/widgets/header_widget.dart';
import 'package:projects/presentation/views/projects_view/projects_cell.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProjectsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWidget(title: 'Projects'),
          Expanded(
            child: Obx(
              () => SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
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
          ),
        ],
      ),
    );
  }
}
