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
import 'package:projects/data/api/core_api.dart';
import 'package:projects/data/models/from_api/portal_comment.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TaskCommentsView extends StatelessWidget {
  final TaskItemController controller;
  const TaskCommentsView({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var _commentsC = Get.find<CommentsController>();
    var _coreApi = locator<CoreApi>();
    var _comments = controller.task.value.comments;
    return FutureBuilder(
      future: Future.wait([_coreApi.getPortalURI(), _coreApi.getHeaders()]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Obx(
            () {
              if (controller.loaded.isTrue) {
                return SmartRefresher(
                  controller: controller.refreshController,
                  onRefresh: () async => await controller.reloadTask(),
                  child: ListView.separated(
                    itemCount: _comments.length,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 21);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommentAuthor(
                            comment: _comments[index],
                            portalUri: snapshot.data[0],
                            headers: snapshot.data[1],
                          ),
                          const SizedBox(height: 28),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(_comments[index].commentBody,
                                style: TextStyleHelper.body2()),
                          ),
                          // const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => print('da'),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Ответить',
                                  style: TextStyleHelper.caption(
                                      color: Theme.of(context)
                                          .customColors()
                                          .primary)),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                );
              } else {
                return const ListLoadingSkeleton();
              }
            },
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}

class CommentAuthor extends StatelessWidget {
  final PortalComment comment;
  final String portalUri;
  final headers;
  const CommentAuthor({
    Key key,
    @required this.comment,
    this.portalUri,
    this.headers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        const SizedBox(width: 16),
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
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
        ),
      ],
    ));
  }
}
