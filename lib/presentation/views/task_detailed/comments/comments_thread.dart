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
  final String portalUri;
  final int taskId;
  final headers;
  const CommentsThread({
    Key key,
    @required this.comment,
    @required this.portalUri,
    @required this.headers,
    @required this.taskId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO fix comments list
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 23, 10),
      child: Column(
        children: [
          Comment(
            comment: comment,
            portalUri: portalUri,
            headers: headers,
            taskId: taskId,
          ),
          for (var i = 0; i < comment.commentList.length; i++)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 15, 0, 10),
              child: Column(
                children: [
                  Comment(
                    comment: comment.commentList[i],
                    portalUri: portalUri,
                    headers: headers,
                    taskId: taskId,
                  ),
                  for (var j = 0;
                      j < comment.commentList[i].commentList.length;
                      j++)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                      child: Column(
                        children: [
                          Comment(
                            comment: comment.commentList[i].commentList[j],
                            portalUri: portalUri,
                            headers: headers,
                            taskId: taskId,
                          ),
                          Builder(
                            builder: (context) {
                              // ignore: omit_local_variable_types
                              Set visited = {};

                              List graph = comment
                                  .commentList[i].commentList[j].commentList;

                              for (PortalComment comment in graph) {
                                dfs(visited, comment.commentList, graph);
                              }

                              return Column(
                                children: [
                                  for (var item in visited)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Comment(
                                          comment: item,
                                          portalUri: portalUri,
                                          headers: headers,
                                          taskId: taskId),
                                    ),
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

void dfs(Set visited, List<PortalComment> comments, List graph) {
  if (!visited.contains(comments)) {
    // ignore: omit_local_variable_types
    for (PortalComment comment in comments) {
      // visited.add(comment);
      // dfs(visited, comment.commentList, graph);

      if (comment.commentList.isNotEmpty) {
        // visited.add(comment);
        dfs(visited, comment.commentList, graph);
      } else
        visited.add(comment);
    }
  }
}
