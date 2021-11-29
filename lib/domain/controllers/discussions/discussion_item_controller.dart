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

import 'package:easy_localization/easy_localization.dart';
import 'package:event_hub/event_hub.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/services/discussion_item_service.dart';
import 'package:projects/data/services/project_service.dart';
import 'package:projects/domain/controllers/comments/item_controller/discussion_comment_item_controller.dart';
import 'package:projects/domain/controllers/comments/new_comment/new_discussion_comment_controller.dart';
import 'package:projects/domain/controllers/discussions/actions/discussion_editing_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_discussions_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/internal/utils/debug_print.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/discussion_editing/discussion_editing_screen.dart';
import 'package:projects/presentation/views/discussions/creating_and_editing/discussion_editing/select/manage_discussion_subscribers_screen.dart';
import 'package:projects/presentation/views/discussions/widgets/discussion_status_BS.dart';
import 'package:projects/presentation/views/project_detailed/project_detailed_view.dart';
import 'package:projects/presentation/views/task_detailed/comments/new_comment_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DiscussionItemController extends GetxController {
  final DiscussionItemService _api = locator<DiscussionItemService>();

  final discussion = Discussion().obs;
  final status = 0.obs;

  final loaded = true.obs;
  final refreshController = RefreshController();
  final subscribersRefreshController = RefreshController();
  final commentsRefreshController = RefreshController();
  var selfId;

  final statusImageString = ''.obs;

  // to show overview screen without loading
  final firstReload = true.obs;

  final fabIsVisible = false.obs;

  DiscussionItemController(Discussion discussion) {
    this.discussion.value = discussion;
    status.value = discussion.status!;

    fabIsVisible.value = discussion.canEdit! && discussion.status == 0;
  }

  final commentsListController = ScrollController();

  @override
  Future<void> onInit() async {
    selfId = await Get.find<UserController>().getUserId();
    super.onInit();
  }

  void scrollToLastComment() {
    commentsListController
        .jumpTo(commentsListController.position.maxScrollExtent);
  }

  bool get isSubscribed {
    for (final item in discussion.value.subscribers!) {
      if (item.id == selfId) return true;
    }
    return false;
  }

  Future<void> onRefresh({bool showLoading = true}) async {
    await getDiscussionDetailed(showLoading: showLoading);

    // update the user data in case of changing user rights on the server side
    Get.find<UserController>()
      ..clear()
      // ignore: unawaited_futures
      ..getUserInfo()
      // ignore: unawaited_futures
      ..getSecurityInfo();

    refreshController.refreshCompleted();
    subscribersRefreshController.refreshCompleted();
    commentsRefreshController.refreshCompleted();
  }

  Future<void> getDiscussionDetailed({bool showLoading = true}) async {
    if (showLoading) loaded.value = false;
    final result = await _api.getMessageDetailed(id: discussion.value.id!);

    if (result != null) {
      try {
        await Get.delete<DiscussionCommentItemController>();
        discussion.value = result;
        status.value = result.status!;
      } catch (_) {}
    }
    if (showLoading) loaded.value = true;
  }

  Future<void> tryChangingStatus(BuildContext context) async {
    if (discussion.value.canEdit!) {
      await showsDiscussionStatusesBS(context: context, controller: this);
    }
  }

  Future<void> updateMessageStatus(int newStatus) async {
    final newStatusStr = newStatus == 1 ? 'archived' : 'open';

    try {
      final result = await _api.updateMessageStatus(
          id: discussion.value.id!, newStatus: newStatusStr);
      if (result != null) {
        discussion.value.setStatus = result.status;
        status.value = result.status!;
        // ignore: unawaited_futures
        getDiscussionDetailed();
        Get.back();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> toDiscussionEditingScreen() async {
    Get.find<NavigationController>().to(
      const DiscussionEditingScreen(),
      arguments: {'discussion': discussion.value},
    );
  }

  Future<void> subscribeToMessageAction() async {
    try {
      final result = await _api.subscribeToMessage(id: discussion.value.id!);
      if (result != null) {
        discussion.value.setSubscribers = result.subscribers;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteMessage(BuildContext context) async {
    await Get.dialog(StyledAlertDialog(
      titleText: tr('deleteDiscussionTitle'),
      contentText: tr('deleteDiscussionAlert'),
      acceptText: tr('delete').toUpperCase(),
      onCancelTap: () async => Get.back(),
      onAcceptTap: () async {
        try {
          final result = await _api.deleteMessage(id: discussion.value.id!);
          if (result != null) {
            Get.back();
            Get.back();
            MessagesHandler.showSnackBar(
                context: context, text: tr('discussionDeleted'));
            await Get.find<DiscussionsController>().loadDiscussions();
            //TODO refactoring needed
            try {
              locator<EventHub>().fire('needToRefreshProjects');
              // ignore: unawaited_futures
              Get.find<ProjectDiscussionsController>().loadProjectDiscussions();
            } catch (e) {
              printError(e);
            }
          }
        } catch (e) {
          printError(e);
        }
      },
    ));
  }

  void handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) update();
  }

  void toNewCommentView() {
    Get.find<NavigationController>().toScreen(
      const NewCommentView(),
      arguments: {
        'controller':
            Get.put(NewDiscussionCommentController(idFrom: discussion.value.id))
      },
    );
  }

  void toSubscribersManagingScreen(BuildContext context) {
    try {
      Get.find<DiscussionEditingController>().dispose();
    } catch (_) {}

    //TODO: refactor parameters
    final controller = Get.put(
      DiscussionEditingController(
        id: discussion.value.id!,
        title: discussion.value.title!.obs,
        text: discussion.value.text!.obs,
        projectId: discussion.value.project!.id!,
        selectedProjectTitle: discussion.value.project!.title!.obs,
        initialSubscribers: discussion.value.subscribers!,
      ),
    );

    Get.find<NavigationController>().to(
      const ManageDiscussionSubscribersScreen(),
      arguments: {
        'controller': controller,
        'onConfirm': () => controller.confirm(context),
      },
    );
  }

  Future<void> toProjectOverview() async {
    final projectService = locator<ProjectService>();
    final project = await projectService.getProjectById(
      projectId: discussion.value.projectOwner!.id!,
    );
    if (project != null) {
      Get.find<NavigationController>().to(
        ProjectDetailedView(),
        arguments: {'projectDetailed': project},
      );
    }
  }
}
