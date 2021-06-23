import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/projects/new_project/portal_group_item_controller.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class PortalGroupItem extends StatelessWidget {
  const PortalGroupItem({
    Key key,
    @required this.onTapFunction,
    @required this.groupController,
  }) : super(key: key);

  final Function onTapFunction;
  final PortalGroupItemController groupController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CheckboxListTile(
        value: groupController.isSelected.isTrue,
        onChanged: (value) {
          groupController.isSelected.value = !groupController.isSelected.value;
          onTapFunction(groupController);
        },
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.06)),
              child: Center(
                child: AppIcon(
                  icon: SvgIcons.subscribers,
                  color: Theme.of(context)
                      .customColors()
                      .onSurface
                      .withOpacity(0.4),
                  height: 22,
                  width: 14,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                groupController.displayName,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyleHelper.subtitle1(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
