import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';

class ColorThemeSelectionScreen extends StatelessWidget {
  const ColorThemeSelectionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyledAppBar(titleText: tr('colorTheme')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _ColorThemeTile(text: tr('sameAsSystem'), isSelected: false),
          const StyledDivider(leftPadding: 16, rightPadding: 16),
          _ColorThemeTile(text: tr('lightTheme'), isSelected: true),
          const StyledDivider(leftPadding: 16, rightPadding: 16),
          _ColorThemeTile(text: tr('darkTheme'), isSelected: false),
        ],
      ),
    );
  }
}

class _ColorThemeTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function() onTap;
  const _ColorThemeTile({
    Key key,
    @required this.text,
    this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 28, 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyleHelper.projectTitle),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                color: Theme.of(context)
                    .customColors()
                    .onBackground
                    .withOpacity(0.6),
              )
          ],
        ),
      ),
    );
  }
}
