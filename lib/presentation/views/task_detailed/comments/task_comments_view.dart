import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/comments/new_comment/new_task_comment_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/presentation/shared/widgets/add_comment_button.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/nothing_found.dart';
import 'package:projects/presentation/views/task_detailed/comments/comments_thread.dart';
import 'package:projects/presentation/views/task_detailed/comments/new_comment_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TaskCommentsView extends StatelessWidget {
  final TaskItemController controller;
  const TaskCommentsView({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.loaded.value == true &&
            controller.task.value.comments != null) {
          var comments = controller.task.value.comments;
          return Column(
            children: [
              if (comments.isEmpty)
                Expanded(
                  child: EmptyScreen(
                    icon: AppIcon(icon: SvgIcons.comments_not_created),
                    text: tr('noCommentsCreated'),
                  ),
                ),
              if (comments.isNotEmpty)
                Expanded(
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    onRefresh: () async =>
                        await controller.reloadTask(showLoading: true),
                    child: ListView.separated(
                      itemCount: comments.length,
                      controller: controller.commentsListController,
                      padding: const EdgeInsets.only(top: 32, bottom: 40),
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 21);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return CommentsThread(
                          comment: comments[index],
                          taskId: controller.task.value.id,
                        );
                      },
                    ),
                  ),
                ),
              if (controller?.task?.value?.canCreateComment == null ||
                  controller?.task?.value?.canCreateComment == true)
                AddCommentButton(
                  onPressed: () => Get.find<NavigationController>().toScreen(
                    const NewCommentView(),
                    arguments: {
                      'controller': Get.put(NewTaskCommentController(
                          idFrom: controller.task.value.id))
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
  }
}
