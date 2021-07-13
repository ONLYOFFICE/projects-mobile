import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class StyledDivider extends StatelessWidget {
  final double leftPadding;
  final double rightPadding;
  final double height;
  final double thickness;
  const StyledDivider({
    Key key,
    this.leftPadding,
    this.rightPadding,
    this.height = 1,
    this.thickness = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      key: key,
      indent: leftPadding,
      endIndent: rightPadding,
      color: Get.theme.colors().outline,
      thickness: thickness,
      height: height,
    );
  }
}
