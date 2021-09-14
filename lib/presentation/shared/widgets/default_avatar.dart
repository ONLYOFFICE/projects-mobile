import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class DefaultAvatar extends StatelessWidget {
  final radius;

  const DefaultAvatar({Key key, this.radius = 20.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Get.theme.colors().bgDescription,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: AppIcon(
          icon: SvgIcons.avatar,
          color: Get.theme.colors().onSurface,
        ),
      ),
    );
  }
}
