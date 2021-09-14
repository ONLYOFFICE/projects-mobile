import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/data/enums/user_selection_mode.dart';

import 'package:projects/domain/controllers/projects/new_project/portal_user_item_controller.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

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
        userController.onTap();
        onTapFunction(userController);
      },
      child: Container(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 72,
              child: CircleAvatar(
                radius: 20.0,
                backgroundColor: Get.theme.colors().bgDescription,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Obx(() {
                    return userController.avatar.value;
                  }),
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
                              Obx(
                                () => userController.userTitle != null &&
                                        userController.userTitle.isNotEmpty
                                    ? Text(
                                        userController.userTitle
                                            .replaceAll(' ', '\u00A0'),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyleHelper.body2(
                                          color:
                                              Get.theme.colors().onBackground,
                                        ),
                                      )
                                    : const SizedBox(),
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
              if (userController.selectionMode.value ==
                  UserSelectionMode.Multiple) {
                if (userController.isSelected.value == true) {
                  return SizedBox(
                      width: 72,
                      child: Icon(Icons.check_box,
                          color: Get.theme.colors().primary));
                } else {
                  return const SizedBox(
                      width: 72,
                      child: Icon(Icons.check_box_outline_blank_outlined));
                }
              } else {
                if (userController.isSelected.value == true) {
                  return SizedBox(
                    width: 72,
                    child: Icon(
                      Icons.check,
                      color: Get.theme.colors().primary,
                    ),
                  );
                } else {
                  return const SizedBox(width: 72);
                }
              }
            }),
          ],
        ),
      ),
    );
  }
}
