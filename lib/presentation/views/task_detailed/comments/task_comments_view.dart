import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/api/core_api.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
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
              if (controller.loaded.isTrue) {
                return Stack(
                  children: [
                    SmartRefresher(
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
                            headers: snapshot.data[1],
                            portalUri: snapshot.data[0],
                            taskId: controller.task.value.id,
                          );
                        },
                      ),
                    ),
                    if (controller?.task?.value?.canCreateComment == null ||
                        controller?.task?.value?.canCreateComment == true)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: SizedBox(
                            height: 32,
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              minWidth: double.infinity,
                              padding: const EdgeInsets.only(left: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                      color: Theme.of(context)
                                          .customColors()
                                          .outline)),
                              color: Theme.of(context)
                                  .customColors()
                                  .bgDescription,
                              onPressed: () => Get.toNamed(
                                'NewCommentView',
                                arguments: {'taskId': controller.task.value.id},
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Add comment...',
                                    style: TextStyleHelper.body2(
                                        color: Theme.of(context)
                                            .customColors()
                                            .onBackground
                                            .withOpacity(0.4))),
                              ),
                            ),
                          ),
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
