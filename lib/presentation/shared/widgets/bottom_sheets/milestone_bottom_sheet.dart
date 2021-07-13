import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/milestones/milestones_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_bottom_sheet.dart';
import 'package:projects/presentation/shared/widgets/list_loading_skeleton.dart';

class MilestonesBottomSheet extends StatelessWidget {
  final selectedId;
  const MilestonesBottomSheet({
    Key key,
    this.selectedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _milestoneController = Get.find<MilestonesController>();

    _milestoneController.getMilestonesByFilter();

    return StyledButtomSheet(
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tr('selectMilestone'), style: TextStyleHelper.h6()),
                // IconButton(
                //     icon: const Icon(Icons.search), onPressed: () => print(''))
              ],
            ),
          ),
          const Divider(height: 1),
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
                      return InkWell(
                        onTap: () => Get.back(result: {
                          'id': _milestoneController.milestones[index].id,
                          'title': _milestoneController.milestones[index].title
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
                                      _milestoneController
                                          .milestones[index].title,
                                      style: TextStyleHelper.projectTitle,
                                    ),
                                    Text(
                                        _milestoneController.milestones[index]
                                            .responsible.displayName,
                                        style: TextStyleHelper.caption(
                                                color: Get.theme
                                                    .colors()
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
