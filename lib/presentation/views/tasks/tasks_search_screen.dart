import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/tasks_search_controller.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/search_field.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/views/tasks/task_cell.dart';

class TasksSearchScreen extends StatelessWidget {
  const TasksSearchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TasksSearchController());

    controller.init();

    return Scaffold(
      appBar: StyledAppBar(
        titleText: tr('tasksSearch'),
        bottom: SearchField(
          autofocus: true,
          onChanged: (value) {
            controller.searchTasks(query: value, needToClear: true);
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
                  return TaskCell(
                      task: controller.paginationController.data[index]);
                },
              ),
            );
          }
        },
      ),
      // body: Container(
      //   child: ListView.separated(
      //     itemCount: 10,
      //     separatorBuilder: (BuildContext context, int index) {
      //       return const SizedBox(height: 10);
      //     },
      //     itemBuilder: (BuildContext context, int index) {
      //       return Container();
      //     },
      //   ),
      // ),
    );
  }
}
