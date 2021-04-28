import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/documents/document_cell.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DocumentsView extends StatelessWidget {
  final TaskItemController controller;
  const DocumentsView({Key key, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _files = controller.task.value.files;
    return Obx(
      () {
        if (controller.loaded.isTrue) {
          return SmartRefresher(
            controller: controller.refreshController,
            onRefresh: () async => await controller.reloadTask(),
            child: ListView.separated(
              itemCount: _files.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (BuildContext context, int index) {
                return DocumentCell(file: _files[index]);
              },
            ),
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}
