import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class WideButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final Function() onPressed;
  final String text;
  const WideButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: onPressed,
      disabledColor: Theme.of(context).customColors().surface,
      minWidth: double.infinity,
      color: color ?? Theme.of(context).customColors().primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.only(top: 10, bottom: 12),
      child: Text(
        text,
        style: TextStyleHelper.button(
            color: textColor ?? Theme.of(context).customColors().onNavBar),
      ),
    );
  }
}
