import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/discussions/discussions_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/sort_view.dart';

class DiscussionsHeader extends StatelessWidget {
  DiscussionsHeader({
    Key key,
  }) : super(key: key);

  final controller = Get.find<DiscussionsController>();

  @override
  Widget build(BuildContext context) {
    var options = Column(
      children: [
        const SizedBox(height: 14.5),
        const Divider(height: 9, thickness: 1),
        SortTile(
            sortParameter: 'create_on',
            sortController: controller.sortController),
        SortTile(
            sortParameter: 'title', sortController: controller.sortController),
        SortTile(
            sortParameter: 'comments',
            sortController: controller.sortController),
        const SizedBox(height: 20)
      ],
    );
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 4),
              child: TextButton(
                onPressed: () => Get.bottomSheet(
                  SortView(sortOptions: options),
                  isScrollControlled: true,
                ),
                child: Row(
                  children: [
                    Obx(
                      () => Text(
                        controller.sortController.currentSortTitle.value,
                        style: TextStyleHelper.projectsSorting,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => (controller.sortController.currentSortOrder ==
                              'ascending')
                          ? AppIcon(
                              icon: SvgIcons.sorting_4_ascend,
                              width: 20,
                              height: 20,
                            )
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationX(math.pi),
                              child: AppIcon(
                                icon: SvgIcons.sorting_4_ascend,
                                width: 20,
                                height: 20,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Text(
                tr('total', args: [
                  controller.paginationController.total.value.toString()
                ]),
                style: TextStyleHelper.body2(
                  color: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
