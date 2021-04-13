import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projects/domain/controllers/projects/portal_user_item_controller.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/text_styles.dart';
import 'package:projects/presentation/shared/custom_theme.dart';

class PortalUserItem extends StatelessWidget {
  const PortalUserItem({
    Key key,
    @required this.onTapFunction,
    @required this.userController,
  }) : super(key: key);

  final Function onTapFunction;
  final PortalUserItemController userController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        userController.isSelected.value = !userController.isSelected.value;
        onTapFunction(
            userController); // controller.selectTeamMember(userController);
      },
      child: Container(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => userController.avatarImage.value == null
                  ? SizedBox(
                      width: 72,
                      child: AppIcon(
                          width: 40,
                          height: 40,
                          icon: SvgIcons.avatar,
                          color: Theme.of(context).customColors().onSurface),
                    )
                  : SizedBox(
                      width: 72,
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: userController.avatarImage.value,
                          ),
                        ),
                      ),
                    ),
            ),
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
                                userController.portalUser.displayName
                                    .replaceAll(' ', '\u00A0'),
                                overflow: TextOverflow.ellipsis,
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
              if (userController.multipleSelectionEnabled.isTrue) {
                if (userController.isSelected.isTrue) {
                  return SizedBox(width: 72, child: Icon(Icons.check_box));
                } else {
                  return SizedBox(
                      width: 72,
                      child: Icon(Icons.check_box_outline_blank_outlined));
                }
              } else {
                if (userController.isSelected.isTrue) {
                  return SizedBox(
                    width: 72,
                    child: Icon(
                      Icons.check,
                      color: Theme.of(context).customColors().primary,
                    ),
                  );
                } else {
                  return SizedBox(width: 72);
                }
              }
            }),
          ],
        ),
      ),
    );
  }
}
