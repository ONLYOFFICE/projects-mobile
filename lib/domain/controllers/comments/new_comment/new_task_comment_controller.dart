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
import 'package:get/get.dart';
import 'package:projects/data/services/comments_service.dart';
import 'package:projects/domain/controllers/comments/new_comment/abstract_new_comment.dart';
import 'package:projects/domain/controllers/messages_handler.dart';
import 'package:projects/internal/locator.dart';

class NewTaskCommentController extends NewCommentController {
  final CommentsService _api = locator<CommentsService>();

  NewTaskCommentController({
    String? parentId,
    int? idFrom,
  }) : super(idFrom: idFrom, parentId: parentId);

  @override
  Future addComment() async {
    final text = await textController.getText();
    if (text.isEmpty || text == '<br>') {
      await emptyTitleError();
    } else {
      setTitleError.value = false;

      final newComment = await _api.addTaskComment(content: text, taskId: idFrom!);
      if (newComment != null) {
        textController.clear();

        locator<EventHub>().fire('needToRefreshParentTask', [idFrom]);
        locator<EventHub>().fire('scrollToLastComment', [idFrom]);

        Get.back();

        MessagesHandler.showSnackBar(context: Get.context!, text: tr('commentCreated'));
      } else
        MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
    }
  }

  @override
  Future addReplyComment() async {
    final text = await textController.getText();
    if (text.isEmpty || text == '<br>') {
      await emptyTitleError();
    } else {
      setTitleError.value = false;

      final newComment = await _api.addTaskReplyComment(
        content: text,
        taskId: idFrom!,
        parentId: parentId!,
      );
      if (newComment != null) {
        textController.clear();

        locator<EventHub>().fire('needToRefreshParentTask', [idFrom, true]);

        Get.back();

        MessagesHandler.showSnackBar(context: Get.context!, text: tr('commentCreated'));
      } else
        MessagesHandler.showSnackBar(context: Get.context!, text: tr('error'));
    }
  }
}
