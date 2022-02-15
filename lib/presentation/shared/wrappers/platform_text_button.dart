/*
 * flutter_platform_widgets
 * Copyright (c) 2021 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/cupertino.dart' show CupertinoButton, CupertinoColors, CupertinoTheme;
import 'package:flutter/material.dart' show TextButton, ButtonStyle;
import 'package:flutter/widgets.dart';

import 'package:projects/presentation/shared/wrappers/platform.dart';
import 'package:projects/presentation/shared/wrappers/widget_base.dart';

const double _kMinInteractiveDimensionCupertino = 44;

abstract class _BaseData {
  _BaseData({
    this.widgetKey,
    this.child,
    this.onPressed,
  });

  final Key? widgetKey;
  final Widget? child;
  final VoidCallback? onPressed;
}

class MaterialTextButtonData extends _BaseData {
  MaterialTextButtonData({
    Key? widgetKey,
    Widget? child,
    VoidCallback? onPressed,
    this.onLongPress,
    this.focusNode,
    this.style,
    this.autofocus,
    this.clipBehavior,
    this.icon,
    this.onHover,
    this.onFocusChange,
  }) : super(
          widgetKey: widgetKey,
          child: child,
          onPressed: onPressed,
        );

  final VoidCallback? onLongPress;
  final FocusNode? focusNode;
  final ButtonStyle? style;
  final bool? autofocus;
  final Clip? clipBehavior;
  final Widget? icon;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
}

class CupertinoTextButtonData extends _BaseData {
  CupertinoTextButtonData({
    Key? widgetKey,
    Widget? child,
    VoidCallback? onPressed,
    this.color,
    this.padding,
    this.disabledColor,
    this.borderRadius,
    this.minSize,
    this.pressedOpacity,
    this.alignment,
    this.originalStyle = false,
  }) : super(
          widgetKey: widgetKey,
          child: child,
          onPressed: onPressed,
        );

  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Color? disabledColor;
  final BorderRadius? borderRadius;
  final double? minSize;
  final double? pressedOpacity;
  final AlignmentGeometry? alignment;

  // If true will use the filled style rather than the text style
  final bool originalStyle;
}

class PlatformTextButton extends PlatformWidgetBase<Widget, TextButton> {
  final Key? widgetKey;

  final VoidCallback? onPressed;
  final Widget? child;

  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final Color? color;

  final PlatformBuilder<CupertinoTextButtonData>? cupertino;
  final PlatformBuilder<MaterialTextButtonData>? material;

  PlatformTextButton({
    Key? key,
    this.widgetKey,
    this.onPressed,
    this.child,
    this.padding,
    this.alignment,
    this.color,
    this.material,
    this.cupertino,
  }) : super(key: key);

  @override
  TextButton createMaterialWidget(BuildContext context) {
    final data = material?.call(context, platform(context));

    final icon = data?.icon;

    if (icon != null) {
      return TextButton.icon(
        key: data?.widgetKey ?? widgetKey,
        label: data?.child ?? child!,
        icon: icon,
        onPressed: data?.onPressed ?? onPressed,
        onLongPress: data?.onLongPress,
        autofocus: data?.autofocus ?? false,
        clipBehavior: data?.clipBehavior ?? Clip.none,
        focusNode: data?.focusNode,
        style: data?.style ??
            TextButton.styleFrom(
              primary: color,
              padding: padding,
              alignment: alignment,
            ),
        onHover: data?.onHover,
        onFocusChange: data?.onFocusChange,
      );
    }

    return TextButton(
      key: data?.widgetKey ?? widgetKey,
      onPressed: data?.onPressed ?? onPressed,
      onLongPress: data?.onLongPress,
      autofocus: data?.autofocus ?? false,
      clipBehavior: data?.clipBehavior ?? Clip.none,
      focusNode: data?.focusNode,
      style: data?.style ??
          TextButton.styleFrom(
            primary: color,
            padding: padding,
            alignment: alignment,
          ),
      onHover: data?.onHover,
      onFocusChange: data?.onFocusChange,
      child: data?.child ?? child!,
    );
  }

  @override
  Widget createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context, platform(context));

    if (data?.originalStyle ?? false) {
      final button = CupertinoButton.filled(
        key: data?.widgetKey ?? widgetKey,
        onPressed: data?.onPressed ?? onPressed,
        borderRadius: data?.borderRadius ?? const BorderRadius.all(Radius.circular(8)),
        minSize: data?.minSize ?? _kMinInteractiveDimensionCupertino,
        padding: data?.padding ?? padding,
        pressedOpacity: data?.pressedOpacity ?? 0.4,
        disabledColor: data?.disabledColor ?? CupertinoColors.quaternarySystemFill,
        alignment: data?.alignment ?? alignment ?? Alignment.center,
        child: data?.child ?? child!,
      );
      if (color != null) {
        final themeData = CupertinoTheme.of(context);
        return CupertinoTheme(
          data: themeData.copyWith(primaryColor: color),
          child: button,
        );
      }
      return button;
    } else {
      return CupertinoButton(
        key: data?.widgetKey ?? widgetKey,
        onPressed: data?.onPressed ?? onPressed,
        borderRadius: data?.borderRadius ?? const BorderRadius.all(Radius.circular(8)),
        minSize: data?.minSize ?? _kMinInteractiveDimensionCupertino,
        padding: data?.padding ?? padding,
        pressedOpacity: data?.pressedOpacity ?? 0.4,
        disabledColor: data?.disabledColor ?? CupertinoColors.quaternarySystemFill,
        alignment: data?.alignment ?? alignment ?? Alignment.center,
        color: color ?? data?.color,
        child: data?.child ?? child!,
      );
    }
  }
}
