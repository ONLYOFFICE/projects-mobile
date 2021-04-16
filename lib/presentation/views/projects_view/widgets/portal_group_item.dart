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
    return InkWell(
      onTap: () {
        groupController.isSelected.value = !groupController.isSelected.value;
        onTapFunction(groupController);
      },
      child: Container(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Obx(
            // () => groupController.avatarImage.value == null
            // ?
            SizedBox(
              width: 72,
              child: AppIcon(
                  width: 40,
                  height: 40,
                  icon: SvgIcons.users,
                  color: Theme.of(context).customColors().onSurface),
            ),
            //       : SizedBox(
            //           width: 72,
            //           child: SizedBox(
            //             height: 40,
            //             width: 40,
            //             child: CircleAvatar(
            //               radius: 40.0,
            //               backgroundColor: Colors.white,
            //               child: ClipOval(
            //                 child: groupController.avatarImage.value,
            //               ),
            //             ),
            //           ),
            //         ),
            // ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                groupController.displayName,
                                // .replaceAll(' ', '\u00A0'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyleHelper.subtitle1(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              // if (groupController.multipleSelectionEnabled.isTrue) {
              if (groupController.isSelected.isTrue) {
                return SizedBox(width: 72, child: Icon(Icons.check_box));
              } else {
                return SizedBox(
                    width: 72,
                    child: Icon(Icons.check_box_outline_blank_outlined));
              }
              // } else {
              //   if (groupController.isSelected.isTrue) {
              //     return SizedBox(
              //       width: 72,
              //       child: Icon(
              //         Icons.check,
              //         color: Theme.of(context).customColors().primary,
              //       ),
              //     );
              //   } else {
              //     return SizedBox(width: 72);
              //   }
              // }
            }),
          ],
        ),
      ),
    );
  }
}
