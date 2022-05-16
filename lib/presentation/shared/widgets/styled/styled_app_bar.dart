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

import 'dart:io';

import 'package:easy_localization/easy_localization.dart' as localizations;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/navigation_controller.dart';
import 'package:projects/domain/controllers/platform_controller.dart';
import 'package:projects/internal/utils/text_utils.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';
import 'package:projects/presentation/shared/theme/text_styles.dart';

// iOS default navbar back button
const double _kNavBarBackButtonTapWidth = 50;

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
  final String? previousPageTitle;
  final double? titleWidth;

  StyledAppBar({
    Key? key,
    this.actions,
    this.bottom,
    this.bottomHeight = 44,
    this.centerTitle,
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
    this.previousPageTitle,
    this.titleWidth,
  })  : assert(titleText == null || title == null),
        assert(leading == null || onLeadingPressed == null),
        preferredSize = Size.fromHeight(bottom != null ? titleHeight + bottomHeight : titleHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    var leadingWidthCalculated = _kNavBarBackButtonTapWidth;

    var titleWidthCalculated = titleWidth;
    if (title == null && titleText != null && titleWidthCalculated == null) {
      titleWidthCalculated = TextUtils.getTextWidth(
        titleText!,
        TextStyleHelper.headline6(),
      );
    }

    final widthWindow =
        Get.find<PlatformController>().isMobile ? MediaQuery.of(context).size.width : 540;

    if (titleWidthCalculated != null) {
      leadingWidthCalculated = (widthWindow - titleWidthCalculated / 2) > 56
          ? (widthWindow - titleWidthCalculated) / 2
          : 56.0;
    } else if (leadingWidth != null) {
      leadingWidthCalculated = leadingWidth!;
    } else if (title == null) {
      leadingWidthCalculated = widthWindow / 2;
    } else {
      leadingWidthCalculated = _kNavBarBackButtonTapWidth;
    }

    return AppBar(
      // TODO: fix bottom padding in modal screen (iPad)
      // primary: ModalNavigationData.key?.currentState?.mounted != true,
      centerTitle: centerTitle ?? Platform.isIOS,
      titleSpacing: Platform.isIOS ? 4 : null,
      iconTheme: const IconThemeData(color: Color(0xff1A73E9)),
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: showBackButton,
      elevation: elevation,
      shadowColor: Theme.of(context).colors().outline,
      leadingWidth: Platform.isIOS ? leadingWidthCalculated : leadingWidth,
      leading: leading == null && showBackButton
          ? PlatformWidget(
              material: (_, __) => BackButton(
                onPressed: onLeadingPressed ?? Get.find<NavigationController>().back,
              ),
              cupertino: (_, __) => CupertinoStyledBackButton(
                previousScreenName: previousPageTitle,
                onPressed: onLeadingPressed ?? Get.find<NavigationController>().back,
              ),
            )
          : leading,
      toolbarTextStyle: TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface),
      titleTextStyle: TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface),
      actions: actions,
      title: title != null
          ? PreferredSize(preferredSize: Size.fromHeight(titleHeight), child: title!)
          : titleText != null
              ? Text(
                  titleText!,
                  style: TextStyleHelper.headline6(color: Theme.of(context).colors().onSurface),
                  textAlign: Platform.isIOS ? TextAlign.center : null,
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
    this.actions = const [],
    this.isCollapsed = false,
  }) : super(key: key);

  final Widget? materialTitle;
  final Widget? cupertinoTitle;
  final List<Widget> actions;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      material: (context, target) => MaterialAppBar(
        title: materialTitle,
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
      backgroundColor: Theme.of(context).colors().background,
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
            backgroundColor: Theme.of(context).colors().background,
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
      backgroundColor: Theme.of(context).colors().background,
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
    return true;
  }
}

class CupertinoStyledBackButton extends StatelessWidget {
  const CupertinoStyledBackButton({Key? key, this.onPressed, this.previousScreenName})
      : super(key: key);

  final Function()? onPressed;
  final String? previousScreenName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: double.infinity,
      child: CupertinoButton(
        onPressed: onPressed,
        padding: const EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 0),
        child: DefaultTextStyle(
          style: CupertinoTheme.of(context).textTheme.navActionTextStyle,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: _kNavBarBackButtonTapWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(padding: EdgeInsetsDirectional.only(start: 4)),
                const _BackChevron(),
                if (previousScreenName != null) ...[
                  const Padding(padding: EdgeInsetsDirectional.only(start: 6)),
                  Expanded(child: _BackButtonText(text: previousScreenName!)),
                ],
                if (previousScreenName == null) const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButtonText extends StatelessWidget {
  const _BackButtonText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constrains) {
        final defaultBackText = localizations.tr('back').toLowerCase().capitalizeFirst!;
        final textStyle = DefaultTextStyle.of(context).style;

        var span = TextSpan(
          text: text,
          style: textStyle,
        );

        var tp = TextPainter(
          maxLines: 1,
          textAlign: TextAlign.left,
          text: span,
          textDirection: TextDirection.ltr,
        );

        tp.layout(maxWidth: constrains.maxWidth);

        var exceeded = tp.didExceedMaxLines;

        if (!exceeded) {
          return Text(
            text,
            style: textStyle,
            textAlign: TextAlign.start,
          );
        }

        span = TextSpan(
          text: defaultBackText,
          style: textStyle,
        );

        tp = TextPainter(
          maxLines: 1,
          textAlign: TextAlign.start,
          text: span,
          textDirection: TextDirection.ltr,
        );

        tp.layout(maxWidth: constrains.maxWidth);

        exceeded = tp.didExceedMaxLines;

        return exceeded
            ? const SizedBox.shrink()
            : Text(
                defaultBackText,
                style: textStyle,
                textAlign: TextAlign.start,
              );
      },
    );
  }
}

class _BackChevron extends StatelessWidget {
  const _BackChevron({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final textStyle = DefaultTextStyle.of(context).style;

    Widget iconWidget = Padding(
      padding: const EdgeInsetsDirectional.only(start: 6, end: 2),
      child: Text.rich(
        TextSpan(
          text: String.fromCharCode(CupertinoIcons.back.codePoint),
          style: TextStyle(
            inherit: false,
            color: textStyle.color,
            fontSize: 30,
            fontFamily: CupertinoIcons.back.fontFamily,
            package: CupertinoIcons.back.fontPackage,
          ),
        ),
      ),
    );
    switch (textDirection) {
      case TextDirection.rtl:
        iconWidget = Transform(
          transform: Matrix4.identity()..scale(-1.0, 1, 1),
          alignment: Alignment.center,
          transformHitTests: false,
          child: iconWidget,
        );
        break;
      case TextDirection.ltr:
        break;
    }

    return iconWidget;
  }
}
