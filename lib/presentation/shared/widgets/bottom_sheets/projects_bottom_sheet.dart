import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/pagination_controller.dart';
import 'package:projects/domain/controllers/projects/project_filter_controller.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';

class ProjectsBottomSheet extends StatelessWidget {
  final selectedId;
  const ProjectsBottomSheet({
    Key key,
    this.selectedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _projectsController = Get.put(
      ProjectsController(
        Get.put(ProjectsFilterController(), tag: 'ProjectsBottomSheet'),
        Get.put(PaginationController(), tag: 'ProjectsBottomSheet'),
      ),
      tag: 'ProjectsBottomSheet',
    );

    _projectsController.loadProjects();

    return StyledButtomSheet(
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tr('selectProject'), style: TextStyleHelper.h6()),
                // IconButton(
                //   icon: const Icon(Icons.search),
                //   onPressed: () => print(''),
                // )
              ],
            ),
          ),
          const Divider(height: 1),
          Obx(
            () {
              if (_projectsController.loaded.value == true) {
                return Expanded(
                  child: ListView.separated(
                    itemCount:
                        _projectsController.paginationController.data.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => Get.back(result: {
                          'id': _projectsController
                              .paginationController.data[index].id,
                          'title': _projectsController
                              .paginationController.data[index].title
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _projectsController.paginationController
                                          .data[index].title,
                                      style: TextStyleHelper.projectTitle,
                                    ),
                                  ],
                                ),
                              ),
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
            },
          ),
        ],
      ),
    );
  }
}
