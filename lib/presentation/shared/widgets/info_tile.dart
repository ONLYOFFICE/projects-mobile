import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class InfoTile extends StatelessWidget {
  final Widget icon;
  final String caption;
  final String subtitle;
  final TextStyle captionStyle;
  final TextStyle subtitleStyle;
  final Widget subtitleWidget;
  final Widget suffix;

  const InfoTile({
    Key key,
    this.icon,
    this.caption,
    this.captionStyle,
    this.subtitle,
    this.subtitleStyle,
    this.subtitleWidget,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 56, child: icon),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (caption != null)
                Text(caption, style: captionStyle ?? TextStyleHelper.caption()),
              if (subtitleWidget != null) subtitleWidget,
              if (subtitleWidget == null && subtitle != null)
                Text(subtitle,
                    style: subtitleStyle ??
                        TextStyleHelper.subtitle1(
                            color: Theme.of(context).customColors().onSurface))
            ],
          ),
        ),
        if (suffix != null) suffix
      ],
    );
  }
}

class InfoTileWithButton extends StatelessWidget {
  final Widget icon;
  final String caption;
  final String subtitle;
  final TextStyle captionStyle;
  final TextStyle subtitleStyle;
  final IconData iconData;
  final Function() onTapFunction;

  const InfoTileWithButton({
    Key key,
    this.icon,
    this.caption,
    this.captionStyle,
    this.subtitle,
    this.subtitleStyle,
    this.iconData,
    this.onTapFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: icon,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(caption, style: captionStyle ?? TextStyleHelper.caption()),
                Text(subtitle,
                    style: subtitleStyle ?? TextStyleHelper.subtitle1())
              ],
            ),
          ),
          InkWell(
            onTap: onTapFunction,
            child: Icon(
              iconData,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 23),
        ],
      ),
    );
  }
}
