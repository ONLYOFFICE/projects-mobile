import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class WideButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final Function() onPressed;
  final String text;
  const WideButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.color,
    this.padding = const EdgeInsets.only(top: 10, bottom: 12),
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: onPressed,
      disabledColor: Get.theme.colors().surface,
      minWidth: double.infinity,
      color: color ?? Get.theme.colors().primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      padding: padding,
      child: Text(
        text,
        style: TextStyleHelper.button(
            color: textColor ?? Get.theme.colors().onNavBar),
      ),
    );
  }
}
