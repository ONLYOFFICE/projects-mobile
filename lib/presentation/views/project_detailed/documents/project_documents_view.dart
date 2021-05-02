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
