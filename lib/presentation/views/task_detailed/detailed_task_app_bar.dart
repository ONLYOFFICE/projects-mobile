import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class DetailedTaskAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget title;
  final Widget bottom;
  final double elevation;
  final List<Widget> actions;

  DetailedTaskAppBar({
    Key key,
    this.title,
    this.bottom,
    this.elevation = 1,
    this.actions,
  }) : super(key: key);

  @override
  final Size preferredSize = Size(double.infinity, 100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).customColors().background,
      centerTitle: false,
      title: title,
      elevation: elevation,
      iconTheme: IconThemeData(color: Theme.of(context).customColors().primary),
      bottom: PreferredSize(preferredSize: Size.fromHeight(20), child: bottom),
      actions: actions,
    );
  }
}
