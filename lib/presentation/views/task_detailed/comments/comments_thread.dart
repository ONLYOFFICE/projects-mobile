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
          Comment(comment: comment, taskId: taskId),
          for (var i = 0; i < comment.commentList.length; i++)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 15, 0, 10),
              child: Column(
                children: [
                  Comment(comment: comment.commentList[i], taskId: taskId),
                  for (var j = 0;
                      j < comment.commentList[i].commentList.length;
                      j++)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                      child: Column(
                        children: [
                          Comment(
                            comment: comment.commentList[i].commentList[j],
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
                                            comment: item, taskId: taskId)),
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
