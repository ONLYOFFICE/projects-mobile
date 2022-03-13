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
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/presentation/shared/widgets/comment.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';

class CommentsThread extends StatelessWidget {
  const CommentsThread({
    Key? key,
    required this.comment,
    this.discussionId,
    this.taskId,
  })  : assert(discussionId == null || taskId == null),
        super(key: key);

  final PortalComment comment;
  final int? discussionId;
  final int? taskId;

  static const padding = <int, EdgeInsets>{
    0: EdgeInsets.fromLTRB(16, 0, 16, 8),
    1: EdgeInsets.fromLTRB(32, 0, 16, 8),
    2: EdgeInsets.fromLTRB(48, 0, 16, 8)
  };

  @override
  Widget build(BuildContext context) {
    final visited = sortComments(comment);

    return ListView.separated(
        padding: EdgeInsets.zero,
        controller: null,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (_, int index) {
          if (visited[index].comment.inactive == true) return const SizedBox();

          return StyledDivider(
            leftPadding: padding[visited[index].paddingLevel]!.left,
            rightPadding: 16,
          );
        },
        itemCount: visited.length,
        itemBuilder: (_, int index) {
          if (visited[index].comment.inactive == true) return const SizedBox();

          return Padding(
            padding: visited[index].comment.show
                ? padding[visited[index].paddingLevel]!
                : EdgeInsets.zero,
            child: Comment(
              comment: visited[index].comment,
              taskId: taskId,
              discussionId: discussionId,
            ),
          );
        });
  }
}

List<_SortedComment> sortComments(PortalComment initComment) {
  final visited = <_SortedComment>[];

  visited.add(_SortedComment(initComment, 0));

  void dfs(PortalComment comment, int paddingLevel) {
    final a = visited.firstWhereOrNull(
      (element) {
        return element.comment.commentId == comment.commentId;
      },
    );

    if (a == null) {
      visited.add(_SortedComment(comment, paddingLevel));
      for (final item in comment.commentList!) {
        dfs(item, 2);
      }
    }
  }

  for (final comment in initComment.commentList!) {
    dfs(comment, 1);
  }
  return visited;
}

class _SortedComment {
  PortalComment comment;
  int paddingLevel;

  _SortedComment(
    this.comment,
    this.paddingLevel,
  );
}
