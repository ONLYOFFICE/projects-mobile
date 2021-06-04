import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(icon: SvgIcons.logo_big),
          const SizedBox(height: 32),
          AppIcon(icon: SvgIcons.title),
        ],
      ),
    );
  }
}
