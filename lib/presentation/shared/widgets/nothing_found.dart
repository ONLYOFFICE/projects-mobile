import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
            icon: AppIcon(icon: SvgIcons.not_found), text: 'Not found'),
      ),
    );
  }
}

class EmptyScreen extends StatelessWidget {
  final AppIcon icon;
  final String text;

  const EmptyScreen({
    Key key,
    this.text,
    this.icon,
  }) : super(key: key);

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
            child: icon,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyleHelper.subtitle1(
                color: Theme.of(context)
                    .customColors()
                    .onSurface
                    .withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}
