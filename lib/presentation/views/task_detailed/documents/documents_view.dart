import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/files/files_controller.dart';
import 'package:projects/internal/extentions.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';

class DocumentsView extends StatelessWidget {
  final int taskId;
  const DocumentsView({
    Key key,
    @required this.taskId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _filesC = Get.find<FilesController>();
    _filesC.getTaskFiles(taskId: taskId);

    var _now = DateTime.now();
    return Obx(
      () {
        if (_filesC.loaded.isTrue) {
          return Container(
            child: ListView.separated(
              itemCount: _filesC.files.length,
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
                              child: Text(
                                  _filesC.files[index].fileType.toString()))),
                      SizedBox(
                        width: Get.width * 0.63,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_filesC.files[index].title),
                            Text(
                                formatedDate(
                                        now: _now,
                                        stringDate: _filesC.files[index].updated
                                            .toString()) +
                                    ' • ' +
                                    _filesC.files[index].contentLength +
                                    ' • ' +
                                    _filesC.files[index].updatedBy.displayName,
                                style: TextStyleHelper.caption(
                                    color: Theme.of(context)
                                        .customColors()
                                        .onSurface
                                        .withOpacity(0.6))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(child: Text('Accept task')),
                              PopupMenuItem(child: Text('Copy task')),
                              PopupMenuItem(child: Text('Delete task')),
                            ];
                          },
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
