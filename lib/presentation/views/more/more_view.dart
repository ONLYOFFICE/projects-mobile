import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class MoreView extends StatelessWidget {
  const MoreView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userController = Get.find<UserController>();
    var portalInfoController = Get.find<PortalInfoController>();

    userController.getUserInfo();
    portalInfoController.getPortalInfo();

    var imageAdress = _getImageAdress(
      portalAdress: portalInfoController.portalUri,
      imageAdress: userController.user?.avatarMedium,
    );

    return Container(
      height: 312,
      decoration: BoxDecoration(
        color: Theme.of(context).customColors().primarySurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Obx(
            () => GestureDetector(
              onTap: () => Get.find<NavigationController>().changeTabIndex(4),
              child: Container(
                  height: 76,
                  padding: const EdgeInsets.fromLTRB(12, 16, 10, 15),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffD8D8D8), width: 0.5),
                    ),
                  ),
                  child: userController.loaded.isTrue &&
                          portalInfoController.loaded.isTrue
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              maxRadius: 20,
                              minRadius: 20,
                              backgroundImage: NetworkImage(
                                imageAdress,
                                headers: portalInfoController.headers,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userController.user?.displayName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyleHelper.subtitle1(
                                        color: Theme.of(context)
                                            .customColors()
                                            .onNavBar),
                                  ),
                                  Text(
                                    portalInfoController.portalName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyleHelper.body2(
                                        color: Theme.of(context)
                                            .customColors()
                                            .onNavBar
                                            .withOpacity(0.6)),
                                  ),
                                  // Text(),
                                ],
                              ),
                            )
                          ],
                        )
                      : const Center(
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator()))),
            ),
          ),
          _MoreTile(
              iconPath: SvgIcons.discussions,
              text: 'Discussions',
              onTap: () => Get.find<NavigationController>().changeTabIndex(5)),
          _MoreTile(
              iconPath: SvgIcons.documents,
              text: 'Documents',
              onTap: () => Get.find<NavigationController>().changeTabIndex(6)),
        ],
      ),
    );
  }
}

// TODO use shared
String _getImageAdress({String portalAdress, String imageAdress}) {
  if (imageAdress?.startsWith('http') != null &&
      imageAdress.startsWith('http')) {
    return imageAdress;
  }
  return '$portalAdress$imageAdress';
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
    return InkResponse(
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
                    color: Theme.of(context).customColors().onNavBar)),
          ],
        ),
      ),
    );
  }
}
