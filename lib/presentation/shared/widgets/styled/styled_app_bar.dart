/*
 * (c) Copyright Ascensio System SIA 2010-2021
 *
 * This program is a free software product. You can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License (AGPL)
 * version 3 as published by the Free Software Foundation. In accordance with
 * Section 7(a) of the GNU AGPL its Section 15 shall be amended to the effect
 * that Ascensio System SIA expressly excludes the warranty of non-infringement
 * of any third-party rights.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE. For
 * details, see the GNU AGPL at: http://www.gnu.org/licenses/agpl-3.0.html
 *
 * You can contact Ascensio System SIA at 20A-12 Ernesta Birznieka-Upisha
 * street, Riga, Latvia, EU, LV-1050.
 *
 * The  interactive user interfaces in modified source and object code versions
 * of the Program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU AGPL version 3.
 *
 * Pursuant to Section 7(b) of the License you must retain the original Product
 * logo when distributing the program. Pursuant to Section 7(e) we decline to
 * grant you any rights under trademark law for use of our trademarks.
 *
 * All the Product's GUI elements, including illustrations and icon sets, as
 * well as technical writing content are licensed under the terms of the
 * Creative Commons Attribution-ShareAlike 4.0 International. See the License
 * terms at http://creativecommons.org/licenses/by-sa/4.0/legalcode
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double titleHeight;
  final double elevation;
  final double bottomHeight;
  double get getBottomHeight => bottom == null ? 0 : bottomHeight;
  final bool showBackButton;
  final bool? centerTitle;
  final Widget? title;
  final Widget? leading;
  final Widget? bottom;
  final String? titleText;
  final List<Widget>? actions;
  final Function()? onLeadingPressed;
  final Color? backgroundColor;
  final double? leadingWidth;
  final Widget backButtonIcon;

  StyledAppBar({
    Key? key,
    this.actions,
    this.bottom,
    this.bottomHeight = 44,
    this.centerTitle = false,
    this.elevation = 1,
    this.leading,
    this.onLeadingPressed,
    this.showBackButton = true,
    this.backButtonIcon = const BackButtonIcon(),
    this.title,
    this.titleHeight = 56,
    this.titleText,
    this.leadingWidth,
    this.backgroundColor,
  })  : assert(titleText == null || title == null),
        assert(leading == null || onLeadingPressed == null),
        preferredSize = Size.fromHeight(bottom != null ? titleHeight + bottomHeight : titleHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      iconTheme: const IconThemeData(color: Color(0xff1A73E9)),
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: showBackButton,
      elevation: elevation,
      shadowColor: Get.theme.colors().outline,
      leadingWidth: leadingWidth,
      leading: leading == null && showBackButton
          ? PlatformIconButton(
              padding: EdgeInsets.zero,
              icon: backButtonIcon,
              onPressed: onLeadingPressed ?? Get.find<NavigationController>().back,
            )
          : leading,
      toolbarTextStyle: TextStyleHelper.headline6(color: Get.theme.colors().onSurface),
      actions: actions,
      title: title != null
          ? PreferredSize(preferredSize: Size.fromHeight(titleHeight), child: title!)
          : titleText != null
              ? Text(
                  titleText!,
                  style: TextStyleHelper.headline6(color: Get.theme.colors().onSurface),
                )
              : null,
      bottom: bottom == null
          ? null
          : PreferredSize(preferredSize: Size.fromHeight(bottomHeight), child: bottom!),
    );
  }
}

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    Key? key,
    this.materialTitle,
    this.cupertinoTitle,
    this.bottom,
    this.actions = const [],
    this.isCollapsed = false,
  }) : super(key: key);

  final Widget? materialTitle;
  final Widget? cupertinoTitle;
  final PreferredSizeWidget? bottom;
  final List<Widget> actions;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      material: (context, target) => MaterialAppBar(
        title: materialTitle,
        bottom: bottom,
        actions: actions,
      ),
      cupertino: (context, target) => CupertinoAppBar(
        title: cupertinoTitle,
        actions: actions.isNotEmpty ? [...actions, const SizedBox(width: 6)] : actions,
        isCollapsed: isCollapsed,
      ),
    );
  }
}

class MaterialAppBar extends StatelessWidget {
  const MaterialAppBar({Key? key, this.title, this.actions = const [], this.bottom})
      : super(key: key);

  final List<Widget> actions;
  final PreferredSizeWidget? bottom;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Get.theme.colors().background,
      pinned: true,
      title: title,
      actions: actions,
      bottom: bottom,
    );
  }
}

class CupertinoAppBar extends StatelessWidget {
  const CupertinoAppBar(
      {Key? key, required this.title, this.actions = const [], this.isCollapsed = false})
      : super(key: key);

  final List<Widget> actions;
  final bool isCollapsed;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return isCollapsed
        ? SliverPersistentHeader(
            pinned: true,
            delegate: CupertinoCollapsedNavBar(
                persistentHeight: 44 + MediaQuery.of(context).padding.top,
                title: title,
                actions: actions),
          )
        : CupertinoSliverNavigationBar(
            backgroundColor: Get.theme.colors().background,
            padding: EdgeInsetsDirectional.zero,
            largeTitle: title,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          );
  }
}

class CupertinoCollapsedNavBar extends SliverPersistentHeaderDelegate {
  const CupertinoCollapsedNavBar({
    required this.persistentHeight,
    this.actions = const [],
    this.title,
  });

  final double persistentHeight;
  final List<Widget> actions;
  final Widget? title;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return CupertinoNavigationBar(
      padding: EdgeInsetsDirectional.zero,
      transitionBetweenRoutes: false,
      backgroundColor: Get.theme.colors().background,
      middle: title,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions,
      ),
    );
  }

  @override
  double get maxExtent => persistentHeight;

  @override
  double get minExtent => persistentHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
