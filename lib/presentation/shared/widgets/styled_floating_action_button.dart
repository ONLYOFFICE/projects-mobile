import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class StyledFloatingActionButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final Color backgroundColor;

  const StyledFloatingActionButton({
    Key key,
    this.backgroundColor, //= Theme.of(context).customColors().lightSecondary,
    this.onPressed,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(
            color: Theme.of(context).customColors().onSurface.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 1)),
        BoxShadow(
            color: Theme.of(context).customColors().onSurface.withOpacity(0.12),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 4)),
      ]),
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).customColors().lightSecondary,
        onPressed: onPressed,
        elevation: 0,
        child: child,
      ),
    );
  }
}
