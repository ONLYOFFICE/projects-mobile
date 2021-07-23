import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/discussion.dart';
import 'package:projects/data/services/discussion_item_service.dart';
import 'package:projects/domain/controllers/comments/item_controller/discussion_comment_item_controller.dart';
import 'package:projects/domain/controllers/comments/new_comment/new_discussion_comment_controller.dart';
import 'package:projects/domain/controllers/discussions/actions/discussion_editing_controller.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/domain/controllers/projects/detailed_project/project_discussions_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/views/discussions/widgets/discussion_status_BS.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DiscussionItemController extends GetxController {
  final _api = locator<DiscussionItemService>();

  var discussion = Discussion().obs;
  var status = 0.obs;

  var loaded = true.obs;
  var refreshController = RefreshController();
  var selfId;

  RxString statusImageString = ''.obs;
  // to show overview screen without loading
  RxBool firstReload = true.obs;

  DiscussionItemController(Discussion discussion) {
    this.discussion.value = discussion;
    status.value = discussion.status;
  }

  @override
  void onInit() async {
    selfId = await Get.find<UserController>().getUserId();
    super.onInit();
  }

  bool get isSubscribed {
    for (var item in discussion.value.subscribers) {
      if (item.id == selfId) return true;
    }
    return false;
  }

  void onRefresh() async => await getDiscussionDetailed();

  Future<void> getDiscussionDetailed({bool showLoading = true}) async {
    if (showLoading) loaded.value = false;
    var result = await _api.getMessageDetailed(id: discussion.value.id);

    if (result != null) {
      try {
        await Get.delete<DiscussionCommentItemController>();
        discussion.value = result;
        status.value = result.status;
      } catch (_) {}
    }
    if (showLoading) loaded.value = true;
  }

  void tryChangingStatus(context) async {
    if (discussion.value.canEdit) {
      await showsDiscussionStatusesBS(context: context, controller: this);
    }
  }

  Future<void> updateMessageStatus(int newStatus) async {
    var newStatusStr = newStatus == 1 ? tr('archived') : tr('open');

    try {
      Discussion result = await _api.updateMessageStatus(
          id: discussion.value.id, newStatus: newStatusStr);
      if (result != null) {
        discussion.value.setStatus = result.status;
        status.value = result.status;
        // ignore: unawaited_futures
        getDiscussionDetailed(showLoading: true);
        Get.back();
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> toDiscussionEditingScreen() async {
    await Get.toNamed(
      'DiscussionEditingScreen',
      arguments: {'discussion': discussion.value},
    );
  }

  Future<void> subscribeToMessageAction() async {
    try {
      Discussion result =
          await _api.subscribeToMessage(id: discussion.value.id);
      if (result != null) {
        discussion.value.setSubscribers = result.subscribers;
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> deleteMessage() async {
    try {
      Discussion result = await _api.deleteMessage(id: discussion.value.id);
      if (result != null) {
        Get.back();
        await Get.find<DiscussionsController>().loadDiscussions();
        try {
          // ignore: unawaited_futures
          Get.find<ProjectDiscussionsController>().loadProjectDiscussions();
        } catch (e) {
          debugPrint(e);
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  void handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) update();
  }

  void toNewCommentView() {
    Get.toNamed('NewCommentView', arguments: {
      'controller': Get.put(
        NewDiscussionCommentController(idFrom: discussion.value.id),
      )
    });
  }

  void toSubscribersManagingScreen(context) {
    try {
      Get.find<DiscussionEditingController>().dispose();
    } catch (_) {}

    var controller = Get.put(
      DiscussionEditingController(
        id: discussion.value.id,
        title: discussion.value.title.obs,
        text: discussion.value.text.obs,
        projectId: discussion.value.project.id,
        selectedProjectTitle: discussion.value.project.title.obs,
        initialSubscribers: discussion.value.subscribers,
      ),
    );

    Get.toNamed(
      'ManageDiscussionSubscribersScreen',
      arguments: {
        'controller': controller,
        'onConfirm': () => controller.confirm(context),
      },
    );
  }
}
