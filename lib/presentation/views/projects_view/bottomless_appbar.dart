import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/custom_theme.dart';

class BottomlessAppBar extends StatelessWidget implements PreferredSizeWidget {
  BottomlessAppBar({
    Key key,
    this.title,
    this.bottom,
  }) : super(key: key);

  final Widget title;
  final Widget bottom;

  @override
  final Size preferredSize = Size(double.infinity, 60);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppBar(
            iconTheme: IconThemeData(
              color: Colors.blue,
            ),
            backgroundColor: Theme.of(context).customColors().background,
            centerTitle: false,
            title: title,
          ),
        ],
      ),
    );
  }
}
