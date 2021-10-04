import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/tasks_search_controller.dart';
import 'package:projects/presentation/shared/widgets/custom_searchbar.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/shared/widgets/paginating_listview.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';
import 'package:projects/presentation/views/tasks/task_cell/task_cell.dart';

class TasksSearchScreen extends StatelessWidget {
  const TasksSearchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TasksSearchController());

    return Scaffold(
      appBar: StyledAppBar(title: CustomSearchBar(controller: controller)),
      body: Obx(
        () {
          if (controller.loaded.value == false)
            return const ListLoadingSkeleton();
          if (controller.nothingFound.isTrue)
            return Column(children: [const NothingFound()]);
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
    );
  }
}
