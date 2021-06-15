import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';

class TagsBottomSheet extends StatelessWidget {
  const TagsBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _projectsController = Get.put(
        ProjectsController(
          Get.put(ProjectsFilterController(), tag: 'TagsBottomSheet'),
          Get.put(PaginationController(), tag: 'TagsBottomSheet'),
        ),
        tag: 'TagsBottomSheet');

    _projectsController.getProjectTags();

    return StyledButtomSheet(
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select tag', style: TextStyleHelper.h6()),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => print(''),
                )
              ],
            ),
          ),
          const Divider(height: 1),
          Obx(() {
            if (_projectsController.loaded.isTrue) {
              return Expanded(
                child: ListView.separated(
                  itemCount: _projectsController.tags.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      child: InkResponse(
                        onTap: () => Get.back(result: {
                          'id': _projectsController.tags[index].id,
                          'title': _projectsController.tags[index].title
                        }),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Flexible(
                                      child: Text(
                                          _projectsController.tags[index].title,
                                          style: TextStyleHelper.projectTitle)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const ListLoadingSkeleton();
            }
          })
        ],
      ),
    );
  }
}
