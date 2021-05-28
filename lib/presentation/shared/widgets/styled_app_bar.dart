import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double titleHeight;
  final double elevation;
  final double bottomHeight;
  final bool showBackButton;
  final bool centerTitle;
  final Widget title;
  final Widget leading;
  final Widget bottom;
  final String titleText;
  final List<Widget> actions;
  final Function() onLeadingPressed;

  StyledAppBar({
    Key key,
    this.actions,
    this.bottom,
    this.bottomHeight = 44,
    this.centerTitle,
    this.elevation = 1,
    this.leading,
    this.onLeadingPressed,
    this.showBackButton = true,
    this.title,
    this.titleHeight = 56,
    this.titleText,
  })  : assert(titleText == null || title == null),
        assert(leading == null || onLeadingPressed == null),
        preferredSize = Size.fromHeight(
            bottom != null ? titleHeight + bottomHeight : titleHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      iconTheme: const IconThemeData(color: Color(0xff1A73E9)),
      backgroundColor: lightColors.onPrimarySurface,
      automaticallyImplyLeading: showBackButton,
      elevation: elevation,
      leading: leading == null && showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onLeadingPressed ?? Get.back,
            )
          : leading,
      textTheme: TextTheme(
          headline6: TextStyleHelper.headline6(color: lightColors.onSurface)),
      actions: actions,
      // ignore: prefer_if_null_operators
      title: title != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(titleHeight), child: title)
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
