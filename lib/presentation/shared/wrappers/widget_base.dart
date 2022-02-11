/*
 * flutter_platform_widgets
 * Copyright (c) 2018 Lance Johnstone. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:projects/presentation/shared/wrappers/platform.dart';

typedef PlatformBuilder<T> = T Function(BuildContext context, PlatformTarget platform);
typedef PlatformIndexBuilder<T> = T Function(
    BuildContext context, PlatformTarget platform, int index);

abstract class PlatformWidgetBase<I extends Widget, A extends Widget> extends StatelessWidget {
  const PlatformWidgetBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMaterial(context)) {
      return createMaterialWidget(context);
    } else if (isCupertino(context)) {
      return createCupertinoWidget(context);
    }

    return throw UnsupportedError('This platform is not supported: $defaultTargetPlatform');
  }

  Widget createCupertinoWidget(BuildContext context);

  Widget createMaterialWidget(BuildContext context);
}
