import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/custom_theme.dart';

class DetailedTaskAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget title;
  final Widget bottom;

  DetailedTaskAppBar({Key key, this.title, this.bottom}) : super(key: key);

  @override
  final Size preferredSize = Size(double.infinity, 100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).customColors().primary,
      centerTitle: false,
      title: title,
      bottom: PreferredSize(preferredSize: Size.fromHeight(20), child: bottom),
    );
  }
}
