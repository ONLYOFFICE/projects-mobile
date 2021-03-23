import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/app_colors.dart';
import 'package:projects/presentation/shared/widgets/header_widget.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWidget(title: 'Dashboard'),
          // Expanded(
          //   child: Obx(() => SmartRefresher(
          //         enablePullDown: true,
          //         enablePullUp: false,
          //         controller: controller.refreshController,
          //         onRefresh: controller.onRefresh,
          //         onLoading: controller.onLoading,
          //         child: ListView.builder(
          //           itemBuilder: (c, i) =>
          //               ProjectItem(item: controller.projects[i]),
          //           itemExtent: 100.0,
          //           itemCount: controller.projects.length,
          //         ),
          //       )),
          // ),
        ],
      ),
    );
  }
}
