import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var icon = Get.theme.brightness == Brightness.light
        ? PngIcons.splash
        : PngIcons.splash_dark;

    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(
            icon: icon,
            isPng: true,
            height: 141,
          ),
        ],
      ),
    );
  }
}
