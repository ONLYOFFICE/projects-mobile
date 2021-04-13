import 'package:flutter/material.dart';
<<<<<<< HEAD
=======

>>>>>>> ccfb5567664e5f15dcef505650755e232f6197fe
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';

class Comment extends StatelessWidget {
  final PortalComment comment;
  final String portalUri;
  final headers;
  const Comment({
    Key key,
    @required this.comment,
    @required this.portalUri,
    @required this.headers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CommentAuthor(
              comment: comment, headers: headers, portalUri: portalUri),
          const SizedBox(height: 28),
          Text(comment.commentBody, style: TextStyleHelper.body2()),
          // Html(data: comment.commentBody),
          GestureDetector(
            onTap: () => print('da'),
            child: Text('Ответить',
                style: TextStyleHelper.caption(
                    color: Theme.of(context).customColors().primary)),
          ),
        ],
      ),
    );
  }
}

class _CommentAuthor extends StatelessWidget {
  final PortalComment comment;
  final String portalUri;
  final headers;
  const _CommentAuthor({
    Key key,
    @required this.comment,
    @required this.portalUri,
    @required this.headers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        const SizedBox(width: 4),
        SizedBox(
          width: 40,
          height: 40,
          child: CircleAvatar(
              backgroundImage: NetworkImage(portalUri + comment.userAvatarPath,
                  headers: headers),
              backgroundColor: Colors.transparent),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(comment.userFullName, style: TextStyleHelper.projectTitle),
              Text(comment.timeStampStr,
                  style: TextStyleHelper.caption(
                      color: Theme.of(context)
                          .customColors()
                          .onBackground
                          .withOpacity(0.6))),
            ],
          ),
        ),
        SizedBox(
          width: 60,
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: PopupMenuButton(
              icon: Icon(Icons.more_vert_rounded,
                  size: 25,
                  color: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.5)),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(child: Text('Copy link')),
                  PopupMenuItem(child: Text('Edit')),
                  PopupMenuItem(child: Text('Delete')),
                ];
              },
            ),
          ),
        ),
      ],
    ));
  }
}
