/*
 * flutter_platform_widgets
 * Copyright (c) 2018 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart' show CircularProgressIndicator;
import 'package:flutter/widgets.dart';

import 'package:projects/presentation/shared/wrappers/platform.dart';
import 'package:projects/presentation/shared/wrappers/widget_base.dart';

const double _kDefaultIndicatorRadius = 10;

class MaterialProgressIndicatorData {
  MaterialProgressIndicatorData({
    this.key,
    this.backgroundColor,
    this.strokeWidth,
    this.value,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
    this.color,
  });
  final Key? key;
  final Color? backgroundColor;
  final double? strokeWidth;
  final double? value;
  final Animation<Color>? valueColor;
  final String? semanticsLabel;
  final String? semanticsValue;
  final Color? color;
}

class CupertinoProgressIndicatorData {
  CupertinoProgressIndicatorData({
    this.key,
    this.animating,
    this.radius: _kDefaultIndicatorRadius,
  });

  final Key? key;
  final bool? animating;
  final double? radius;
}

class PlatformCircularProgressIndicator
    extends PlatformWidgetBase<CupertinoActivityIndicator, CircularProgressIndicator> {
  final Key? widgetKey;

  Color? color;

  final PlatformBuilder<MaterialProgressIndicatorData>? material;
  final PlatformBuilder<CupertinoProgressIndicatorData>? cupertino;

  PlatformCircularProgressIndicator({
    Key? key,
    this.widgetKey,
    this.color,
    this.material,
    this.cupertino,
  }) : super(key: key);

  @override
  CircularProgressIndicator createMaterialWidget(BuildContext context) {
    final data = material?.call(context, platform(context));

    return CircularProgressIndicator(
      key: data?.key ?? widgetKey,
      backgroundColor: data?.backgroundColor,
      strokeWidth: data?.strokeWidth ?? 4.0,
      value: data?.value,
      valueColor: data?.valueColor,
      semanticsLabel: data?.semanticsLabel,
      semanticsValue: data?.semanticsValue,
      color: data?.color ?? color,
    );
  }

  @override
  CupertinoActivityIndicator createCupertinoWidget(BuildContext context) {
    final data = cupertino?.call(context, platform(context));

    return CupertinoActivityIndicator(
      key: data?.key ?? widgetKey,
      animating: data?.animating ?? true,
      radius: data?.radius ?? _kDefaultIndicatorRadius,
    );
  }
}
