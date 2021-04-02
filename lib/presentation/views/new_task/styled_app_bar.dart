import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/custom_theme.dart';
import 'package:projects/presentation/shared/text_styles.dart';

class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;

  StyledAppBar({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  final Size preferredSize = Size(double.infinity, 56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).customColors().onPrimarySurface,
      iconTheme: IconThemeData(color: const Color(0xff1A73E9)),
      elevation: 1,
      // title: title,
      actions: [
        IconButton(
            icon: Icon(Icons.check_rounded), onPressed: () => print('da'))
      ],
      title: Text('New task',
          style: TextStyleHelper.headline6(
              color: Theme.of(context).customColors().onSurface)),
    );
  }
}
