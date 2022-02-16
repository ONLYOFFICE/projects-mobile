/*
 * flutter_platform_widgets
 * Copyright (c) 2018 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/widgets.dart';

import 'package:projects/presentation/shared/wrappers/platform.dart';
import 'package:projects/presentation/shared/wrappers/widget_base.dart';

class PlatformWidget extends PlatformWidgetBase<Widget, Widget> {
  final PlatformBuilder<Widget?>? material;
  final PlatformBuilder<Widget?>? cupertino;

  PlatformWidget({
    Key? key,
    this.cupertino,
    this.material,
  }) : super(key: key);

  @override
  Widget createMaterialWidget(BuildContext context) {
    return material?.call(context, platform(context)) ?? const SizedBox.shrink();
  }

  @override
  Widget createCupertinoWidget(BuildContext context) {
    return cupertino?.call(context, platform(context)) ?? const SizedBox.shrink();
  }
}
