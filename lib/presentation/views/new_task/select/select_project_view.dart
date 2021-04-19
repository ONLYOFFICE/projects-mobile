import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/projects/projects_controller.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';

class SelectProjectView extends StatelessWidget {
  const SelectProjectView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _projectsController = Get.find<ProjectsController>();
    _projectsController.setupProjects();

    var controller = Get.find<NewTaskController>();

    return Scaffold(
      appBar: StyledAppBar(
        titleText: 'Select project',
        actions: [
          IconButton(
              icon: Icon(Icons.check_rounded), onPressed: () => print('da'))
        ],
      ),
      body: Obx(() {
        if (_projectsController.loaded.isTrue) {
          return ListView.separated(
            itemCount: _projectsController.paginationController.data.length,
            padding: const EdgeInsets.only(bottom: 16),
            separatorBuilder: (BuildContext context, int index) {
              return StyledDivider(leftPadding: 16, rightPadding: 16);
            },
            itemBuilder: (BuildContext context, int index) {
              return Material(
                child: InkWell(
                  onTap: () {
                    controller.changeProjectSelection(
                        id: _projectsController
                            .paginationController.data[index].id,
                        title: _projectsController
                            .paginationController.data[index].title);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _projectsController
                                    .paginationController.data[index].title,
                                style: TextStyleHelper.projectTitle,
                              ),
                              Text(
                                  _projectsController.paginationController
                                      .data[index].responsible.displayName,
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
          );
        } else {
          return ListLoadingSkeleton();
        }
      }),
    );
  }
}
