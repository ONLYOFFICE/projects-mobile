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
import 'package:projects/data/models/from_api/project_detailed.dart';
import 'package:projects/domain/controllers/projects/detailed_project/documents/project_doc_datasource.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectDocumentsView extends StatelessWidget {
  final ProjectDetailed projectDetailed;
  const ProjectDocumentsView({
    Key key,
    @required this.projectDetailed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var projectDocsDataSource = Get.put(DocsDataSource());
    projectDocsDataSource.projectDetailed = projectDetailed;
    projectDocsDataSource.getDocs();

    return Obx(
      () {
        if (projectDocsDataSource.loaded.isTrue) {
          return SmartRefresher(
            controller: projectDocsDataSource.refreshController,
            onRefresh: () async => await projectDocsDataSource.reload(),
            child: ListView.separated(
              itemCount: projectDocsDataSource.docsList.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (BuildContext context, int index) {
                var element = projectDocsDataSource.docsList[index];
                return Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 72,
                        child: Center(
                          child: Text(projectDocsDataSource
                              .docsList[index].fileType
                              .toString()),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(element.title),
                            Text(
                                '${formatedDate(element.updated)} • ${element.contentLength} • ${element.updatedBy.displayName}',
                                style: TextStyleHelper.caption(
                                    color: Theme.of(context)
                                        .customColors()
                                        .onSurface
                                        .withOpacity(0.6))),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: PopupMenuButton(
                            icon: Icon(Icons.more_vert,
                                color: Theme.of(context)
                                    .customColors()
                                    .onSurface
                                    .withOpacity(0.5)),
                            itemBuilder: (context) {
                              return [
                                const PopupMenuItem(child: Text('Open')),
                                const PopupMenuItem(child: Text('Copy link')),
                                const PopupMenuItem(child: Text('Download')),
                                const PopupMenuItem(child: Text('Move')),
                                const PopupMenuItem(child: Text('Copy')),
                                const PopupMenuItem(child: Text('Delete')),
                              ];
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}
