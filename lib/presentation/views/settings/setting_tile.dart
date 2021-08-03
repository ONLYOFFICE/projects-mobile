import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';

class SettingTile extends StatelessWidget {
  final bool enableUnderline;
  // Some icons are black, so we need to use opacity to make all the
  // icons the same
  final bool enableIconOpacity;
  final TextStyle textStyle;
  final String text;
  final String suffixText;
  final String loverText;
  final String icon;
  final Function() onTap;
  final Color textColor;
  final Widget suffix;
  final EdgeInsetsGeometry suffixPadding;
  final TextOverflow textOverflow;

  const SettingTile({
    Key key,
    this.enableUnderline = false,
    this.enableIconOpacity = false,
    this.icon,
    this.loverText,
    this.onTap,
    this.suffix,
    this.suffixPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.suffixText,
    this.textOverflow = TextOverflow.ellipsis,
    this.textColor,
    this.textStyle,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: enableUnderline
            ? Border(
                bottom: BorderSide(
                    color: Theme.of(context).colors().outline.withOpacity(0.5)))
            : null,
      ),
      child: SizedBox(
        height: 60,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 72,
                    child: icon != null
                        ? AppIcon(
                            icon: icon,
                            color: Get.theme
                                .colors()
                                .onBackground
                                .withOpacity(enableIconOpacity ? 0.6 : 1))
                        : null,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: loverText != null && loverText.isNotEmpty
                              ? 8
                              : 18),
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
                                          : Get.theme.colors().onBackground)),
                          if (loverText != null && loverText.isNotEmpty)
                            Text(loverText,
                                style: TextStyleHelper.body2(
                                    color: Get.theme
                                        .colors()
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
                  if (suffixText != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: suffixPadding,
                        child: Text(
                          suffixText,
                          style: TextStyleHelper.body2(
                              color: Theme.of(context)
                                  .colors()
                                  .onSurface
                                  .withOpacity(0.6)),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
