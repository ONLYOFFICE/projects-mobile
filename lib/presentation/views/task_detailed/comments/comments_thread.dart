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
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/presentation/shared/widgets/comment.dart';

class CommentsThread extends StatelessWidget {
  final PortalComment comment;
  final int discussionId;
  final int taskId;
  const CommentsThread({
    Key key,
    @required this.comment,
    this.discussionId,
    this.taskId,
  })  : assert(discussionId == null || taskId == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var padding = <int, EdgeInsetsGeometry>{
      0: const EdgeInsets.fromLTRB(12, 0, 16, 0),
      1: const EdgeInsets.fromLTRB(20, 29, 16, 0),
      2: const EdgeInsets.fromLTRB(44, 29, 16, 0)
    };

    // ignore: omit_local_variable_types
    List<_SortedComment> visited = sortComments(comment);

    return Column(
      children: [
        for (var i = 0; i < visited.length; i++)
          Padding(
            padding: padding[visited[i].paddingLevel],
            child: Comment(
              comment: visited[i].comment,
              taskId: taskId,
              discussionId: discussionId,
            ),
          ),
      ],
    );
  }
}

List<_SortedComment> sortComments(PortalComment initComment) {
  var visited = <_SortedComment>[];

  visited.add(_SortedComment(initComment, 0));

  void dfs(PortalComment comment, paddingLevel) {
    var a = visited.firstWhere(
      (element) {
        return element.comment.commentId == comment.commentId;
      },
      orElse: () => null,
    );

    if (a == null) {
      visited.add(_SortedComment(comment, paddingLevel));
      for (var item in comment.commentList) {
        dfs(item, 2);
      }
    }
  }

  for (var comment in initComment.commentList) {
    dfs(comment, 1);
  }
  return visited;
}

class _SortedComment {
  int paddingLevel;
  PortalComment comment;

  _SortedComment(
    this.comment,
    this.paddingLevel,
  );
}
