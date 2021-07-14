import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class SearchField extends StatelessWidget {
  final bool autofocus;
  final bool showClearIcon;
  final Color color;
  final double width;
  final double height;
  final String hintText;
  final Widget suffixIcon;
  final EdgeInsetsGeometry margin;
  final TextEditingController controller;
  final Function(String value) onChanged;
  final Function(String value) onSubmitted;
  final Function() onSuffixTap;
  final Function() onClearPressed;

  const SearchField({
    Key key,
    this.autofocus = false,
    this.color,
    this.controller,
    this.height = 32,
    this.hintText,
    this.margin = const EdgeInsets.only(left: 16, right: 16, bottom: 10),
    this.onChanged,
    this.onClearPressed,
    this.onSubmitted,
    this.onSuffixTap,
    this.showClearIcon = false,
    this.suffixIcon,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        autofocus: autofocus,
        decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: color ?? Get.theme.colors().bgDescription,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    const BorderSide(width: 0, style: BorderStyle.none)),
            labelStyle: TextStyleHelper.body2(
                color: Get.theme.colors().onSurface.withOpacity(0.4)),
            hintStyle: TextStyleHelper.body2(
                color: Get.theme.colors().onSurface.withOpacity(0.4)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            suffixIcon: showClearIcon
                ? GestureDetector(
                    onTap: onClearPressed,
                    child: const SizedBox(
                        height: 32,
                        width: 32,
                        child: Icon(Icons.clear_rounded)))
                : GestureDetector(
                    onTap: onSuffixTap,
                    child: SizedBox(height: 32, child: suffixIcon))),
      ),
    );
  }
}
