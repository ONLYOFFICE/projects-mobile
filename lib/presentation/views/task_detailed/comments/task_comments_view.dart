/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/comments/new_comment/new_task_comment_controller.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/presentation/shared/widgets/add_comment_button.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
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
              Expanded(
                child: SmartRefresher(
                  controller: controller.refreshController,
                  onRefresh: () async =>
                      await controller.reloadTask(showLoading: true),
                  child: ListView.separated(
                    itemCount: comments.length,
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
                  onPressed: () => Get.find<NavigationController>().navigateTo(
                    const NewCommentView(),
                    arguments: {
                      'controller': Get.put(NewTaskCommentController(
                          idFrom: controller.task.value.id))
                    },

                    //  Get.toNamed('NewCommentView', arguments: {
                    //   'controller': Get.put(NewTaskCommentController(
                    //       idFrom: controller.task.value.id))
                    // // },),
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
