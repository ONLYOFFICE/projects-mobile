import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/presentation/shared/widgets/add_comment_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/views/task_detailed/comments/comments_thread.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DiscussionCommentsView extends StatelessWidget {
  final DiscussionItemController controller;
  const DiscussionCommentsView({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(
        () {
          if (controller.loaded.value == false)
            return const ListLoadingSkeleton();
          else {
            return Stack(
              children: [
                SmartRefresher(
                  controller: controller.refreshController,
                  onRefresh: controller.onRefresh,
                  child: ListView.separated(
                    itemCount: controller.discussion.value.comments.length,
                    padding: const EdgeInsets.only(top: 32, bottom: 70),
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 21);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return CommentsThread(
                        comment: controller.discussion.value.comments[index],
                        discussionId: controller.discussion.value.id,
                      );
                    },
                  ),
                ),
                if (controller.discussion.value.canCreateComment == true)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AddCommentButton(
                      onPressed: controller.toNewCommentView,
                    ),
                  )
              ],
            );
          }
        },
      ),
    );
  }
}
