import 'package:flutter/material.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final String titleText;
  final bool centerTitle;
  final bool showBackButton;
  final double bottomHeight;
  final List<Widget> actions;
  final Widget bottom;
  final double elevation;

  StyledAppBar({
    Key key,
    this.actions,
    this.elevation = 1,
    this.title,
    this.titleText,
    this.centerTitle,
    this.bottom,
    this.bottomHeight = 44,
    this.showBackButton = true,
  })  : assert(titleText == null || title == null),
        // assert((bottom != null || bottomHeight == null) ||
        //     (bottom == null && bottomHeight == null)),
        // assert((bottom != null || bottomHeight == null)),
        preferredSize =
            Size.fromHeight(bottom != null ? 56 + bottomHeight : 56),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      iconTheme: IconThemeData(color: const Color(0xff1A73E9)),
      backgroundColor: lightColors.onPrimarySurface,
      automaticallyImplyLeading: showBackButton,
      elevation: elevation,
      textTheme: TextTheme(
          headline6: TextStyleHelper.headline6(color: lightColors.onSurface)),
      actions: actions,
      // ignore: prefer_if_null_operators
      title: title != null
          ? title
          : titleText != null
              ? Text(titleText)
              : null,
      bottom: bottom == null
          ? null
          : PreferredSize(
              preferredSize: Size.fromHeight(bottomHeight), child: bottom),
    );
  }
}
