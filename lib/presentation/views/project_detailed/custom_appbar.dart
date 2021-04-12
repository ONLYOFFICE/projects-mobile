import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/custom_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget bottom;
  final double height;
  CustomAppBar({Key key, this.title, this.bottom, this.height})
      : super(key: key);

  @override
  final Size preferredSize = Size(double.infinity, 100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.blue,
      ),
      backgroundColor: Theme.of(context).customColors().background,
      centerTitle: false,
      title: title,
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(50), child: bottom ?? SizedBox()),
    );
  }
}
