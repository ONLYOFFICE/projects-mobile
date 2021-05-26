import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled_app_bar.dart';
import 'package:projects/presentation/shared/widgets/styled_divider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyledAppBar(titleText: 'Settings'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            NewTaskInfo(
              text: 'Passcode Lock',
              loverText: 'Disabled',
              icon: SvgIcons.passcode,
              onTap: () => Get.toNamed('PasscodeScreen'),
            ),
            NewTaskInfo(
              text: 'Color theme',
              loverText: 'Same as System',
              icon: SvgIcons.color_scheme,
              onTap: () => Get.toNamed('ColorThemeSelectionScreen'),
            ),
            const NewTaskInfo(
              text: 'Clear cache',
              icon: SvgIcons.clean,
            ),
            const SizedBox(height: 70),
            const NewTaskInfo(
              text: 'Support',
              icon: SvgIcons.support,
            ),
            const NewTaskInfo(
              text: 'Feedback',
              icon: SvgIcons.feedback,
            ),
            const NewTaskInfo(
              text: 'About App',
              icon: SvgIcons.about_app,
            ),
          ],
        ),
      ),
    );
  }
}

class NewTaskInfo extends StatelessWidget {
  final bool enableBorder;
  final TextStyle textStyle;
  final String text;
  final String loverText;
  final String icon;
  final Function() onTap;
  final Color textColor;
  final Widget suffix;
  final EdgeInsetsGeometry suffixPadding;
  final TextOverflow textOverflow;

  const NewTaskInfo({
    Key key,
    this.enableBorder = true,
    this.icon,
    this.loverText,
    this.onTap,
    this.suffix,
    this.suffixPadding = const EdgeInsets.symmetric(horizontal: 25),
    this.textOverflow = TextOverflow.ellipsis,
    this.textColor,
    this.textStyle,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 61,
      // constraints: const BoxConstraints(minHeight: 56),
      child: InkWell(
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
                          color: Theme.of(context)
                              .customColors()
                              .onSurface
                              .withOpacity(0.6))
                      : null,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            loverText != null && loverText.isNotEmpty ? 8 : 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(text,
                            overflow: textOverflow,
                            style: textStyle ??
                                TextStyleHelper.subtitle1(
                                    // ignore: prefer_if_null_operators
                                    color: textColor != null
                                        ? textColor
                                        : Theme.of(context)
                                            .customColors()
                                            .onBackground)),
                        if (loverText != null && loverText.isNotEmpty)
                          Text(loverText,
                              style: TextStyleHelper.body2(
                                  color: Theme.of(context)
                                      .customColors()
                                      .onBackground
                                      .withOpacity(0.75))),
                      ],
                    ),
                  ),
                ),
                if (suffix != null)
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(padding: suffixPadding, child: suffix)),
              ],
            ),
            if (enableBorder) const StyledDivider(leftPadding: 56.5),
          ],
        ),
      ),
    );
  }
}
