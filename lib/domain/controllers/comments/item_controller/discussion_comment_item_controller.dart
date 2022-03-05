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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/domain/controllers/comments/item_controller/abstract_comment_item_controller.dart';
import 'package:projects/domain/controllers/discussions/discussion_item_controller.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_alert_dialog.dart';
import 'package:projects/presentation/views/task_detailed/comments/comment_editing_view.dart';

class DiscussionCommentItemController extends GetxController implements CommentItemController {
  final CommentsService _api = locator<CommentsService>();

  @override
  late final Rx<PortalComment> comment;
  final int? discussionId;

  DiscussionCommentItemController({required this.comment, this.discussionId});

  @override
  Future<void> copyLink() async {
    final projectId = Get.find<DiscussionItemController>().discussion.value.projectOwner!.id;

    final link = await _api.getDiscussionCommentLink(
      commentId: comment.value.commentId!,
      discussionId: discussionId!,
      projectId: projectId!,
    );

    if (link.isURL) {
      await Clipboard.setData(ClipboardData(text: link));
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('linkCopied'));
    } else
      MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
  }

  @override
  Future deleteComment() async {
    await Get.dialog(StyledAlertDialog(
      titleText: tr('deleteCommentTitle'),
      contentText: tr('deleteCommentWarning'),
      acceptText: tr('delete').toUpperCase(),
      acceptColor: Get.theme.colors().colorError,
      onCancelTap: Get.back,
      onAcceptTap: () async {
        final response = await _api.deleteComment(commentId: comment.value.commentId!);
        if (response != null) {
          // ignore: unawaited_futures
          Get.find<DiscussionItemController>().onRefresh(showLoading: false);
          Get.back();
          MessagesHandler.showSnackBar(
            context: Get.context!,
            text: tr('commentDeleted'),
            buttonText: tr('confirm'),
            buttonOnTap: ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar,
          );
        }
      },
    ));
  }

  @override
  void toCommentEditingView() {
    Get.find<NavigationController>().toScreen(const CommentEditingView(), arguments: {
      'commentId': comment.value.commentId,
      'commentBody': comment.value.commentBody,
      'itemController': this,
    });
  }
}
