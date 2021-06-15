import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/portalInfoController.dart';
import 'package:projects/domain/controllers/profile_controller.dart';
import 'package:projects/domain/controllers/user_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/custom_network_image.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userController = Get.find<UserController>();
    var portalInfoController = Get.find<PortalInfoController>();

    var profileController = Get.put(ProfileController());

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: StyledAppBar(
          showBackButton: false,
          titleText: 'Profile',
          actions: [
            IconButton(
              icon: AppIcon(icon: SvgIcons.settings),
              onPressed: () => Get.toNamed('SettingsScreen'),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.grey, shape: BoxShape.circle),
                height: 120,
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: CustomNetworkImage(
                    image: userController.user?.avatar ??
                        userController.user?.avatarMedium ??
                        userController.user?.avatarSmall,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  userController.user?.displayName,
                  style: TextStyleHelper.headline6(
                    color: Theme.of(context).customColors().onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 68),
              _ProfileInfoTile(
                caption: 'Email:',
                text: userController.user?.email ?? '',
                icon: SvgIcons.message,
              ),
              _ProfileInfoTile(
                caption: 'Portal adress:',
                text: portalInfoController.portalName ?? '',
                icon: SvgIcons.cloud,
              ),
              _ProfileInfoTile(
                text: 'Log out',
                textColor: Theme.of(context).customColors().error,
                icon: SvgIcons.logout,
                iconColor:
                    Theme.of(context).customColors().error.withOpacity(0.6),
                onTap: () async => profileController.logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO instead crerate shared styledTile
class _ProfileInfoTile extends StatelessWidget {
  final int maxLines;
  final bool enableBorder;
  final TextStyle textStyle;
  final String text;
  final String icon;
  final Color iconColor;
  final String caption;
  final Function() onTap;
  final Color textColor;
  final EdgeInsetsGeometry suffixPadding;
  final TextOverflow textOverflow;

  const _ProfileInfoTile({
    Key key,
    this.caption,
    this.enableBorder = true,
    this.icon,
    this.iconColor,
    this.maxLines,
    this.onTap,
    this.suffixPadding = const EdgeInsets.symmetric(horizontal: 25),
    this.textOverflow = TextOverflow.ellipsis,
    this.textColor,
    this.textStyle,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: InkResponse(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 56,
                  child: icon != null
                      ? AppIcon(
                          icon: icon,
                          color: iconColor ??
                              Theme.of(context)
                                  .customColors()
                                  .onSurface
                                  .withOpacity(0.6))
                      : null,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            caption != null && caption.isNotEmpty ? 10 : 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (caption != null && caption.isNotEmpty)
                          Text(caption,
                              style: TextStyleHelper.caption(
                                  color: Theme.of(context)
                                      .customColors()
                                      .onBackground
                                      .withOpacity(0.75))),
                        Text(text,
                            maxLines: maxLines,
                            overflow: textOverflow,
                            style: textStyle ??
                                TextStyleHelper.subtitle1(
                                    // ignore: prefer_if_null_operators
                                    color: textColor ??
                                        Theme.of(context)
                                            .customColors()
                                            .onSurface))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
