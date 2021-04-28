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
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

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
              //TODO fix avatars path
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
                  const PopupMenuItem(child: Text('Copy link')),
                  const PopupMenuItem(child: Text('Edit')),
                  const PopupMenuItem(child: Text('Delete')),
                ];
              },
            ),
          ),
        ),
      ],
    ));
  }
}
