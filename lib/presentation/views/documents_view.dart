import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/detailed_project/documents/project_doc_datasource.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PortalDocumentsView extends StatelessWidget {
  const PortalDocumentsView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var docsDataSource = Get.put(DocsDataSource());

    docsDataSource.getDocs();

    return Obx(
      () {
        if (docsDataSource.loaded.isTrue) {
          return SmartRefresher(
            controller: docsDataSource.refreshController,
            onRefresh: () async => await docsDataSource.reload(),
            child: docsDataSource.docsList.isNotEmpty
                ? Files(docsDataSource: docsDataSource)
                : Folders(docsDataSource: docsDataSource),
          );
        } else {
          return const ListLoadingSkeleton();
        }
      },
    );
  }
}

class Files extends StatelessWidget {
  const Files({
    Key key,
    @required this.docsDataSource,
  }) : super(key: key);

  final DocsDataSource docsDataSource;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: docsDataSource.docsList.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (BuildContext context, int index) {
        var element = docsDataSource.docsList[index];
        return Container(
          child: Row(
            children: [
              SizedBox(
                width: 72,
                child: Center(
                  child:
                      Text(docsDataSource.docsList[index].fileType.toString()),
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
    );
  }
}

class Folders extends StatelessWidget {
  const Folders({
    Key key,
    @required this.docsDataSource,
  }) : super(key: key);

  final DocsDataSource docsDataSource;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        itemCount: docsDataSource.foldersList.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (BuildContext context, int index) {
          var element = docsDataSource.foldersList[index];
          return Container(
            child: Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Center(
                    child: AppIcon(
                      width: 24,
                      height: 24,
                      icon: SvgIcons.folder,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(element.title),
                      Text(
                          '${formatedDate(element.updated)} • documents:${element.filesCount} • subfolders:${element.foldersCount}',
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
  }
}
