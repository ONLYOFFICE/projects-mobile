import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/models/from_api/milestone.dart';
import 'package:projects/domain/controllers/milestones/milestones_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_app_bar.dart';

class SelectMilestoneView extends StatelessWidget {
  final selectedId;
  const SelectMilestoneView({
    Key key,
    this.selectedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _milestoneController = Get.find<MilestonesController>();

    _milestoneController.getAllMilestones();

    var controller = Get.arguments['controller'];

    return Scaffold(
      appBar: StyledAppBar(titleText: tr('selectMilestone')),
      body: Column(
        children: [
          Obx(
            () {
              if (_milestoneController.loaded.value == true) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: _milestoneController.milestones.length + 1,
                    padding: const EdgeInsets.only(bottom: 16),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        indent: 16,
                        endIndent: 16,
                        height: 1,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return _None(
                          onTap: controller.changeMilestoneSelection,
                          isSelected: controller.newMilestoneId == null,
                        );
                      }
                      return _MilestoneSelectionTile(
                        onTap: () {
                          return controller.changeMilestoneSelection(
                            id: _milestoneController.milestones[index - 1].id,
                            title: _milestoneController
                                .milestones[index - 1].title,
                          );
                        },
                        milestone: _milestoneController.milestones[index - 1],
                        isSelected:
                            _milestoneController.milestones[index - 1].id ==
                                controller.newMilestoneId,
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

class _None extends StatelessWidget {
  const _None({
    Key key,
    @required this.isSelected,
    @required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 36, 16, 26),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(tr('none'),
                style: TextStyleHelper.subtitle1(
                    color: Get.theme.colors().onSurface)),
            if (isSelected)
              Icon(Icons.check_rounded,
                  color: Get.theme.colors().onBackground.withOpacity(0.6))
          ],
        ),
      ),
    );
  }
}

class _MilestoneSelectionTile extends StatelessWidget {
  const _MilestoneSelectionTile({
    Key key,
    @required this.milestone,
    @required this.isSelected,
    @required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final Function() onTap;
  final Milestone milestone;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone.title,
                    style: TextStyleHelper.projectTitle,
                  ),
                  Text(milestone.responsible.displayName,
                      style: TextStyleHelper.caption(
                              color:
                                  Get.theme.colors().onSurface.withOpacity(0.6))
                          .copyWith(height: 1.667)),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded,
                  color: Get.theme.colors().onBackground.withOpacity(0.6))
          ],
        ),
      ),
    );
  }
}
