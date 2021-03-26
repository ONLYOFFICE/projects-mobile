import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/custom_theme.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;

  SearchAppBar({Key key, this.title}) : super(key: key);

  @override
  final Size preferredSize = Size(double.infinity, 90);

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
