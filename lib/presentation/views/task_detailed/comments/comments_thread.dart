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
            padding: visited[i].comment.show
                ? padding[visited[i].paddingLevel]
                : EdgeInsets.zero,
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
