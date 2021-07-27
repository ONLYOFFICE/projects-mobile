import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/domain/controllers/comments/new_comment/new_task_comment_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/widgets/add_comment_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/task_detailed/comments/comments_thread.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TaskCommentsView extends StatelessWidget {
  final TaskItemController controller;
  const TaskCommentsView({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _coreApi = locator<CoreApi>();
    var _comments = controller.task.value.comments;
    return FutureBuilder(
      future: Future.wait([_coreApi.getPortalURI(), _coreApi.getHeaders()]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Obx(
            () {
              if (controller.loaded.value == true) {
                return Column(
                  children: [
                    Expanded(
                      child: SmartRefresher(
                        controller: controller.refreshController,
                        onRefresh: () async =>
                            await controller.reloadTask(showLoading: true),
                        child: ListView.separated(
                          itemCount: _comments.length,
                          padding: const EdgeInsets.only(top: 32, bottom: 40),
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 21);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return CommentsThread(
                              comment: _comments[index],
                              taskId: controller.task.value.id,
                            );
                          },
                        ),
                      ),
                    ),
                    if (controller?.task?.value?.canCreateComment == null ||
                        controller?.task?.value?.canCreateComment == true)
                      AddCommentButton(
                        onPressed: () => Get.toNamed(
                          'NewCommentView',
                          arguments: {
                            'controller': Get.put(
                              NewTaskCommentController(
                                  idFrom: controller.task.value.id),
                            )
                          },
                        ),
                      ),
                  ],
                );
              } else {
                return const ListLoadingSkeleton();
              }
            },
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}
