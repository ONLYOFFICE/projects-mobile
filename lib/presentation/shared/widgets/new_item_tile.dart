import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';
import 'package:projects/presentation/shared/widgets/app_icons.dart';
import 'package:projects/presentation/shared/widgets/styled/styled_divider.dart';

class NewItemTile extends StatelessWidget {
  final int maxLines;
  final bool isSelected;
  final bool enableBorder;
  final TextStyle textStyle;
  final String text;
  final String icon;
  final String caption;
  final Function() onTap;
  final Color textColor;
  final Color selectedIconColor;
  final Color iconColor;
  final Widget suffix;
  final EdgeInsetsGeometry suffixPadding;
  final TextOverflow textOverflow;

  const NewItemTile({
    Key key,
    this.caption,
    this.enableBorder = true,
    this.icon,
    this.iconColor,
    this.isSelected = false,
    this.maxLines,
    this.onTap,
    this.selectedIconColor,
    this.suffix,
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
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                _Icon(
                  icon: icon,
                  iconColor: iconColor,
                  isSelected: isSelected,
                  selectedIconColor: selectedIconColor,
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
                                  color: Get.theme
                                      .colors()
                                      .onBackground
                                      .withOpacity(0.75))),
                        Text(text,
                            maxLines: maxLines,
                            overflow: textOverflow,
                            style: textStyle ??
                                TextStyleHelper.subtitle1(
                                    // ignore: prefer_if_null_operators
                                    color: textColor != null
                                        ? textColor
                                        : isSelected
                                            ? Get.theme.colors().onBackground
                                            : Get.theme
                                                .colors()
                                                .onSurface
                                                .withOpacity(0.4))),
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
            if (enableBorder) const StyledDivider(leftPadding: 72.5),
          ],
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    Key key,
    this.icon,
    this.selectedIconColor,
    this.iconColor,
    this.isSelected,
  }) : super(key: key);

  final bool isSelected;
  final Color selectedIconColor;
  final Color iconColor;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: icon != null
          ? AppIcon(
              icon: icon,
              color: selectedIconColor != null
                  ? isSelected
                      ? selectedIconColor
                      : iconColor ??
                          Get.theme.colors().onSurface.withOpacity(0.4)
                  : iconColor ?? Get.theme.colors().onSurface.withOpacity(0.4),
            )
          : null,
    );
  }
}
