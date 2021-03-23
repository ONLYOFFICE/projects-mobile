import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/app_colors.dart';

class StyledFloatingActionButton extends StatelessWidget {

  final Function() onPressed;
  final Widget child;
  final Color backgroundColor;

  const StyledFloatingActionButton({
    Key key,
    this.backgroundColor = AppColors.lightSecondary,
    this.onPressed,
    this.child,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 1)
          ),
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.12),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 4)
          ),
        ]
      ),
      child: FloatingActionButton(
        backgroundColor: backgroundColor,
        onPressed: onPressed,
        elevation: 0,
        child: child,
      ),
    );
  }
}