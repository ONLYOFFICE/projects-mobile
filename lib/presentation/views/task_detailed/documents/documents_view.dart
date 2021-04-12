import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/tasks/task_item_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DocumentsView extends StatelessWidget {
  final TaskItemController controller;
  const DocumentsView({Key key, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _now = DateTime.now();
    var _files = controller.task.value.files;
    return Obx(
      () {
        if (controller.loaded.isTrue) {
          return SmartRefresher(
            controller: controller.refreshController,
            onRefresh: () async => await controller.reloadTask(),
            child: ListView.separated(
              itemCount: _files.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Row(
                    children: [
                      SizedBox(
                          width: 72,
                          child: Center(
                              child: Text(_files[index].fileType.toString()))),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_files[index].title),
                            Text(
                                formatedDate(
                                        now: _now,
                                        stringDate:
                                            _files[index].updated.toString()) +
                                    ' • ' +
                                    _files[index].contentLength +
                                    ' • ' +
                                    _files[index].updatedBy.displayName,
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
                                PopupMenuItem(child: Text('Open')),
                                PopupMenuItem(child: Text('Copy link')),
                                PopupMenuItem(child: Text('Download')),
                                PopupMenuItem(child: Text('Move')),
                                PopupMenuItem(child: Text('Copy')),
                                PopupMenuItem(child: Text('Delete')),
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
          return ListLoadingSkeleton();
        }
      },
    );
  }
}
