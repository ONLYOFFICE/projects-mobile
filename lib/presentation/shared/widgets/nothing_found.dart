import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/internal/utils/debug_print.dart';

import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class NothingFound extends StatelessWidget {
  const NothingFound({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: EmptyScreen(
          icon: SvgIcons.not_found,
          text: tr('notFound'),
        ),
      ),
    );
  }
}

class EmptyScreen extends StatelessWidget {
  final String icon;
  final String text;

  const EmptyScreen({
    Key key,
    this.text,
    this.icon,
  }) : super(key: key);

  String get darkThemeIcon {
    return icon.replaceFirst('.', '_dark.');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 144,
            width: 144,
            child: Builder(
              builder: (_) {
                try {
                  return AppIcon(
                    icon: Get.theme.brightness == Brightness.light
                        ? icon
                        : darkThemeIcon,
                  );
                } catch (e) {
                  printError(e);
                  return AppIcon(icon: icon);
                }
              },
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyleHelper.subtitle1(
                color: Get.theme.colors().onSurface.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}
