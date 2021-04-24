import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/milestones/milestones_controller.dart';
import 'package:projects/domain/controllers/tasks/new_task_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

class SelectMilestoneView extends StatelessWidget {
  final selectedId;
  const SelectMilestoneView({
    Key key,
    this.selectedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _milestoneController = Get.find<MilestonesController>();

    _milestoneController.getMilestonesByFilter();

    var controller = Get.find<NewTaskController>();

    return Scaffold(
      appBar: StyledAppBar(titleText: 'Select milestone', actions: [
        IconButton(
            icon: const Icon(Icons.check_rounded), onPressed: () => print('da'))
      ]),
      body: Column(
        children: [
          Obx(
            () {
              if (_milestoneController.loaded.isTrue) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: _milestoneController.milestones.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Material(
                        child: InkWell(
                          onTap: () {
                            controller.changeMilestoneSelection(
                                id: _milestoneController.milestones[index].id,
                                title: _milestoneController
                                    .milestones[index].title);
                          },
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
                                        _milestoneController
                                            .milestones[index].title,
                                        style: TextStyleHelper.projectTitle,
                                      ),
                                      Text(
                                          _milestoneController.milestones[index]
                                              .responsible.displayName,
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
