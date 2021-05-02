import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';

class ProjectsBottomSheet extends StatelessWidget {
  final selectedId;
  const ProjectsBottomSheet({
    Key key,
    this.selectedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _projectsController = Get.find<ProjectsController>();

    _projectsController.loadProjects();

    return StyledButtomSheet(
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select project', style: TextStyleHelper.h6()),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => print(''),
                )
              ],
            ),
          ),
          const Divider(height: 1),
          Obx(
            () {
              if (_projectsController.loaded.isTrue) {
                return Expanded(
                  child: ListView.separated(
                    itemCount:
                        _projectsController.paginationController.data.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Material(
                        child: InkWell(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _projectsController.paginationController
                                            .data[index].title,
                                        style: TextStyleHelper.projectTitle,
                                      ),
                                      Text(
                                          _projectsController
                                              .paginationController
                                              .data[index]
                                              .milestoneResponsible
                                              .displayName,
                                          style: TextStyleHelper.caption(
                                                  color: Theme.of(context)
                                                      .customColors()
                                                      .onSurface
                                                      .withOpacity(0.6))
                                              .copyWith(height: 1.667)),
                                    ],
                                  ),
                                ),
                                // Icon(Icons.check_rounded)
                              ],
                            ),
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
