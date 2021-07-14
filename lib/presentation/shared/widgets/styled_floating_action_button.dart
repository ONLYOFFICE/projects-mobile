import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class StyledFloatingActionButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final Color backgroundColor;

  const StyledFloatingActionButton({
    Key key,
    this.backgroundColor, //= Get.theme.customColors().lightSecondary,
    this.onPressed,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(
            color: Get.theme.colors().onSurface.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 1)),
        BoxShadow(
            color: Get.theme.colors().onSurface.withOpacity(0.12),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 4)),
      ]),
      child: FloatingActionButton(
        backgroundColor: Get.theme.colors().lightSecondary,
        onPressed: onPressed,
        elevation: 0,
        child: child,
      ),
    );
  }
}
