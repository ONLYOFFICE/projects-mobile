import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/profile_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class MoreView extends StatelessWidget {
  const MoreView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.setup();
    });

    return Container(
      height: 312,
      decoration: BoxDecoration(
        color: Get.theme.colors().primarySurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Get.find<NavigationController>().changeTabIndex(4),
            child: Container(
                height: 76,
                padding: const EdgeInsets.fromLTRB(12, 16, 10, 15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Get.theme.colors().outline, width: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Get.theme.colors().bgDescription,
                        child: ClipOval(
                          child: Obx(() {
                            return controller.avatar.value;
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return Text(
                              controller.username.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleHelper.subtitle1(
                                  color: Get.theme.colors().onNavBar),
                            );
                          }),
                          Obx(() {
                            return Text(
                              controller.portalName.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleHelper.body2(
                                  color: Get.theme
                                      .colors()
                                      .onNavBar
                                      .withOpacity(0.6)),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                )),
          ),
          _MoreTile(
              iconPath: SvgIcons.discussions,
              text: tr('discussions'),
              onTap: () => Get.find<NavigationController>().changeTabIndex(5)),
          _MoreTile(
              iconPath: SvgIcons.documents,
              text: tr('documents'),
              onTap: () => Get.find<NavigationController>().changeTabIndex(6)),
        ],
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final String iconPath;
  final String text;
  final Function() onTap;

  const _MoreTile({
    Key key,
    @required this.iconPath,
    @required this.onTap,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: AppIcon(icon: iconPath),
            ),
            Text(text,
                style: TextStyleHelper.subtitle1(
                    color: Get.theme.colors().onNavBar)),
          ],
        ),
      ),
    );
  }
}
