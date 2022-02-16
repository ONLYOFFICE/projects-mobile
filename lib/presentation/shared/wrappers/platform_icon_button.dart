/*
 * flutter_platform_widgets
 * Copyright (c) 2018 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/cupertino.dart' show CupertinoButton, CupertinoColors;
import 'package:flutter/material.dart' show IconButton, VisualDensity;
import 'package:flutter/widgets.dart';
import 'package:projects/presentation/shared/wrappers/platform.dart';
import 'package:projects/presentation/shared/wrappers/widget_base.dart';

const double _kMinInteractiveDimensionCupertino = 44;

abstract class _BaseData {
  _BaseData(
      {this.widgetKey, this.icon, this.onPressed, this.padding, this.color, this.disabledColor});

  final Key? widgetKey;
  final Widget? icon;
  final void Function()? onPressed;
  final EdgeInsets? padding;
  final Color? color;
  final Color? disabledColor;
}

class CupertinoIconButtonData extends _BaseData {
  CupertinoIconButtonData(
      {Key? widgetKey,
      Widget? icon,
      void Function()? onPressed,
      EdgeInsets? padding,
      Color? color,
      Color? disabledColor,
      this.borderRadius,
      this.minSize,
      this.pressedOpacity,
      this.alignment})
      : super(
            widgetKey: widgetKey,
            icon: icon,
            onPressed: onPressed,
            padding: padding,
            color: color,
            disabledColor: disabledColor);

  final BorderRadius? borderRadius;
  final double? minSize;
  final double? pressedOpacity;
  final AlignmentGeometry? alignment;
}

class MaterialIconButtonData extends _BaseData {
  MaterialIconButtonData({
    Key? widgetKey,
    Widget? icon,
    void Function()? onPressed,
    EdgeInsets? padding,
    Color? color,
    Color? disabledColor,
    this.alignment,
    this.highlightColor,
    this.iconSize = 24.0,
    this.splashColor,
    this.tooltip,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus,
    this.enableFeedback,
    this.visualDensity,
    this.constraints,
    this.splashRadius,
    this.mouseCursor,
  }) : super(
          widgetKey: widgetKey,
          icon: icon,
          onPressed: onPressed,
          padding: padding,
          color: color,
          disabledColor: disabledColor,
        );

  final AlignmentGeometry? alignment;
  final Color? highlightColor;
  final double? iconSize;
  final Color? splashColor;
  final String? tooltip;
  final Color? focusColor;
  final Color? hoverColor;
  final FocusNode? focusNode;
  final bool? autofocus;
  final bool? enableFeedback;
  final VisualDensity? visualDensity;
  final BoxConstraints? constraints;
  final double? splashRadius;
  final MouseCursor? mouseCursor;
}

class PlatformIconButton extends PlatformWidgetBase<CupertinoButton, Widget> {
  final Key? widgetKey;

  final Widget? icon;
  final Widget? cupertinoIcon;
  final Widget? materialIcon;
  final void Function()? onPressed;
  final Color? color;
  final EdgeInsets? padding;
  final Color? disabledColor;

  final PlatformBuilder<MaterialIconButtonData>? material;
  final PlatformBuilder<CupertinoIconButtonData>? cupertino;

  PlatformIconButton({
    Key? key,
    this.widgetKey,
    this.icon,
    this.cupertinoIcon,
    this.materialIcon,
    this.onPressed,
    this.color,
    this.disabledColor,
    this.padding,
    this.material,
    this.cupertino,
  }) : super(key: key);

  @override
  Widget createMaterialWidget(BuildContext context) {
    final data = material?.call(context, platform(context));

    // icon is required non nullable
    assert(data?.icon != null || materialIcon != null || icon != null);

    return IconButton(
      key: data?.widgetKey ?? widgetKey,
      icon: data?.icon ?? materialIcon ?? icon!,
      onPressed: data?.onPressed ?? onPressed,
      padding: data?.padding ?? padding ?? const EdgeInsets.all(8),
      color: data?.color ?? color,
      alignment: data?.alignment ?? Alignment.center,
      disabledColor: data?.disabledColor ?? disabledColor,
      highlightColor: data?.highlightColor,
      iconSize: data?.iconSize ?? 24.0,
      splashColor: data?.splashColor,
      tooltip: data?.tooltip,
      focusColor: data?.focusColor,
      focusNode: data?.focusNode,
      hoverColor: data?.hoverColor,
      autofocus: data?.autofocus ?? false,
      enableFeedback: data?.enableFeedback ?? true,
      visualDensity: data?.visualDensity,
      constraints: data?.constraints,
      splashRadius: data?.splashRadius,
      mouseCursor: data?.mouseCursor ?? SystemMouseCursors.click,
    );
  }

  @override
  CupertinoButton createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context, platform(context));

    // child is required non nullable
    assert(data?.icon != null || cupertinoIcon != null || icon != null);

    return CupertinoButton(
      key: data?.widgetKey ?? widgetKey,
      onPressed: data?.onPressed ?? onPressed,
      padding: data?.padding ?? padding,
      color: data?.color ?? color,
      borderRadius: data?.borderRadius ?? const BorderRadius.all(Radius.circular(8)),
      minSize: data?.minSize ?? _kMinInteractiveDimensionCupertino,
      pressedOpacity: data?.pressedOpacity ?? 0.4,
      disabledColor: data?.disabledColor ?? disabledColor ?? CupertinoColors.quaternarySystemFill,
      alignment: data?.alignment ?? Alignment.center,
      child: data?.icon ?? cupertinoIcon ?? icon!,
    );
  }
}
